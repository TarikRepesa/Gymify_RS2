import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gymify_desktop/models/dashboard_report.dart';
import 'package:gymify_desktop/models/membership_package_analytics.dart';
import 'package:gymify_desktop/models/membership_revenue_summary.dart';
import 'package:gymify_desktop/providers/report_provider.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({super.key, this.year});

  final int? year;

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color gymBlue = Color(0xFF387EFF);
  static const Color bg = Color(0xFFF5F7FB);
  static const Color financeGreen = Color(0xFF0F9D58);

  bool _loading = true;
  String? _error;

  DashboardReport? _dashboardReport;
  MembershipRevenueSummary? _membershipSummary;

  late int _selectedYear;

  int get _year => _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.year ?? DateTime.now().year;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final provider = context.read<ReportProvider>();

      final dashboardFuture = provider.getDashboard(
        year: _year,
        takeTopTrainers: 5,
      );

      final membershipFuture = provider.getMembershipRevenueSummary(
        year: _year,
      );

      final results = await Future.wait([
        dashboardFuture,
        membershipFuture,
      ]);

      if (!mounted) return;

      setState(() {
        _dashboardReport = results[0] as DashboardReport;
        _membershipSummary = results[1] as MembershipRevenueSummary;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<List<int>> _buildDashboardPdfBytes({
    required DashboardReport report,
    required int year,
  }) async {
    final doc = pw.Document();
    final now = DateTime.now();
    final dateFmt = DateFormat('dd.MM.yyyy HH:mm');

    final top = [...report.topTrainers]..sort((a, b) => b.count.compareTo(a.count));
    final best = report.bestTrainingAllTime;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 28),
        build: (_) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Gymify - Izvjestaj o trenerima i treninzima",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    "Generisano: ${dateFmt.format(now)}",
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColors.blue200),
                ),
                child: pw.Text(
                  "Godina: $year",
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 18),
          pw.Text(
            "Najefikasniji trening svih vremena",
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          if (best == null)
            pw.Text("Nema podataka.")
          else
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(10),
                border: pw.Border.all(color: PdfColors.blue200),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    best.name,
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text("Trener: ${best.trainerName}"),
                  pw.Text("Ucestvovanja: ${best.participatedOfAllTime}"),
                ],
              ),
            ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Najposjeceniji treneri ($year)",
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          if (top.isEmpty)
            pw.Text("Nema podataka.")
          else
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(5),
                2: const pw.FlexColumnWidth(2),
              },
              headers: const ["#", "Trener", "Posjete"],
              data: List.generate(top.length, (i) {
                final t = top[i];
                return [
                  (i + 1).toString(),
                  t.name,
                  t.count.toString(),
                ];
              }),
            ),
        ],
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            "Stranica ${context.pageNumber} / ${context.pagesCount}",
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
        ),
      ),
    );

    return doc.save();
  }

  Future<List<int>> _buildMembershipPdfBytes({
    required MembershipRevenueSummary summary,
  }) async {
    final doc = pw.Document();
    final now = DateTime.now();
    final dateFmt = DateFormat('dd.MM.yyyy HH:mm');

    final packages = [...summary.packageAnalytics]
      ..sort((a, b) => b.totalIncome.compareTo(a.totalIncome));

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 28),
        build: (_) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Gymify - Izvjestaj o clanarinama i prihodima",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    "Generisano: ${dateFmt.format(now)}",
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: pw.BoxDecoration(
                  color: PdfColors.green50,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColors.green200),
                ),
                child: pw.Text(
                  "Godina: ${summary.year}",
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 18),
          pw.Text(
            "Pregled kljucnih pokazatelja",
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _pdfKpiBox(
                "Ukupan prihod",
                "${summary.totalIncome.toStringAsFixed(2)} KM",
              ),
              _pdfKpiBox("Ukupno uplata", "${summary.totalPayments}"),
              _pdfKpiBox("Aktivni clanovi", "${summary.activeMembers}"),
              _pdfKpiBox("Istekle clanarine", "${summary.expiredMembers}"),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Prihod po mjesecima",
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          if (summary.monthlyIncome.isEmpty)
            pw.Text("Nema podataka.")
          else
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              headers: const ["Mjesec", "Prihod", "Broj uplata"],
              data: summary.monthlyIncome
                  .map(
                    (m) => [
                      m.label,
                      "${m.totalIncome.toStringAsFixed(2)} KM",
                      m.paymentCount.toString(),
                    ],
                  )
                  .toList(),
            ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Paketi clanarina",
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          if (packages.isEmpty)
            pw.Text("Nema podataka.")
          else
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              headers: const ["#", "Paket", "Kupovina", "Prihod"],
              data: List.generate(packages.length, (i) {
                final p = packages[i];
                return [
                  (i + 1).toString(),
                  p.membershipName,
                  p.purchaseCount.toString(),
                  "${p.totalIncome.toStringAsFixed(2)} KM",
                ];
              }),
            ),
        ],
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            "Stranica ${context.pageNumber} / ${context.pagesCount}",
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
        ),
      ),
    );

    return doc.save();
  }

  pw.Widget _pdfKpiBox(String title, String value) {
    return pw.Container(
      width: 120,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: const pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printDashboardReport() async {
    if (_dashboardReport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nema podataka za printanje.")),
      );
      return;
    }

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Sacuvaj PDF izvjestaj',
      fileName: 'Gymify_Trening_Izvjestaj_$_year.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (path == null) return;

    try {
      setState(() => _loading = true);

      final bytes = await _buildDashboardPdfBytes(
        report: _dashboardReport!,
        year: _year,
      );

      final file = File(path);
      await file.writeAsBytes(bytes, flush: true);
      await OpenFilex.open(file.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ne mogu napraviti PDF: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _printMembershipReport() async {
    if (_membershipSummary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nema podataka za printanje.")),
      );
      return;
    }

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Sacuvaj PDF izvjestaj',
      fileName: 'Gymify_Clanarine_I_Prihodi_$_year.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (path == null) return;

    try {
      setState(() => _loading = true);

      final bytes = await _buildMembershipPdfBytes(
        summary: _membershipSummary!,
      );

      final file = File(path);
      await file.writeAsBytes(bytes, flush: true);
      await OpenFilex.open(file.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ne mogu napraviti PDF: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_error != null)
              ? _ErrorState(message: _error!, onRetry: _load)
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final dashboard = _dashboardReport;
    final membership = _membershipSummary;

    if (dashboard == null || membership == null) {
      return const Center(
        child: Text("Nema podataka za prikaz."),
      );
    }

    final topTrainers = dashboard.topTrainers;
    final best = dashboard.bestTrainingAllTime;
    final monthlyIncome = membership.monthlyIncome;
    final packages = membership.packageAnalytics;

    final trainerPalette = [
      const Color(0xFF3B82F6),
      const Color(0xFF22C55E),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
    ];

    final packagePalette = [
      const Color(0xFF0EA5E9),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
      const Color(0xFF14B8A6),
    ];

    final totalTrainerVisits = topTrainers.fold<double>(
      0,
      (sum, e) => sum + e.count.toDouble(),
    );

    final maxMonthlyIncome = monthlyIncome.isEmpty
        ? 0.0
        : monthlyIncome
            .map((e) => e.totalIncome)
            .reduce((a, b) => a > b ? a : b);

    final bestPackage = packages.isEmpty
        ? null
        : ([...packages]..sort((a, b) => b.totalIncome.compareTo(a.totalIncome))).first;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Izvjestaji i analitika",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ),
              _YearDropdown(
                value: _selectedYear,
                onChanged: (value) {
                  if (value == null || value == _selectedYear) return;

                  setState(() {
                    _selectedYear = value;
                  });

                  _load();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Pregled performansi trenera, treninga, clanarina i prihoda za $_year. godinu",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 26),

          _ReportSectionHeader(
            title: "Trening izvjestaj",
            subtitle:
                "Vizualni pregled najposjecenijih trenera i najefikasnijeg treninga svih vremena za izabranu godinu.",
            color: gymBlueDark,
            icon: Icons.fitness_center,
          ),
          const SizedBox(height: 18),

          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: [
              Container(
                width: 500,
                padding: const EdgeInsets.all(18),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Najposjeceniji treneri ($_year)",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 250,
                      child: topTrainers.isEmpty
                          ? const _EmptyBox(text: "Nema podataka.")
                          : PieChart(
                              PieChartData(
                                centerSpaceRadius: 44,
                                sectionsSpace: 2,
                                sections: List.generate(topTrainers.length, (i) {
                                  final item = topTrainers[i];
                                  final percent = totalTrainerVisits == 0
                                      ? 0
                                      : (item.count / totalTrainerVisits) * 100;

                                  return PieChartSectionData(
                                    color: trainerPalette[i % trainerPalette.length],
                                    value: item.count.toDouble(),
                                    radius: 72,
                                    title: "${percent.toStringAsFixed(1)}%",
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  );
                                }),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    if (topTrainers.isNotEmpty)
                      Column(
                        children: List.generate(topTrainers.length, (i) {
                          final item = topTrainers[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: trainerPalette[i % trainerPalette.length],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(item.name)),
                                Text(
                                  item.count.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                  ],
                ),
              ),
              Container(
                width: 360,
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Najefikasniji trening svih vremena",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (best == null)
                      const _EmptyBox(text: "Nema podataka.")
                    else ...[
                      Row(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: gymBlueDark.withOpacity(0.12),
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              color: gymBlueDark,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  best.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Trener: ${best.trainerName}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Ucestvovanja: ${best.participatedOfAllTime}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Builder(
                        builder: (_) {
                          final maxYearCount = topTrainers.isEmpty
                              ? 0
                              : topTrainers
                                  .map((e) => e.count)
                                  .reduce((a, b) => a > b ? a : b);

                          final denom = maxYearCount == 0 ? 1 : maxYearCount;
                          final value =
                              (best.participatedOfAllTime / denom).clamp(0.0, 1.0);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Indikator performansi",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: value,
                                  minHeight: 10,
                                  backgroundColor: const Color(0xFFEFEFEF),
                                  color: gymBlueDark,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "sta ulazi u trening PDF",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                const _PdfInfoRow(text: "Najefikasniji trening svih vremena"),
                const _PdfInfoRow(text: "Ime trenera i broj ukupnih ucestvovanja"),
                const _PdfInfoRow(text: "Top treneri po broju posjeta"),
                const _PdfInfoRow(text: "Tabela najposjecenijih trenera"),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerRight,
                  child: _ActionButton(
                    label: "Printaj trening izvjestaj",
                    icon: Icons.picture_as_pdf_outlined,
                    color: gymBlueDark,
                    onPressed: _printDashboardReport,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 34),

          _ReportSectionHeader(
            title: "Financijski izvjestaj",
            subtitle:
                "Pregled prihoda, uplata i paketa clanarina za izabranu godinu.",
            color: financeGreen,
            icon: Icons.payments_outlined,
          ),
          const SizedBox(height: 18),

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _KpiCard(
                title: "Ukupan prihod",
                value: "${membership.totalIncome.toStringAsFixed(2)} KM",
                icon: Icons.account_balance_wallet_outlined,
                accent: financeGreen,
              ),
              _KpiCard(
                title: "Ukupno uplata",
                value: "${membership.totalPayments}",
                icon: Icons.receipt_long_outlined,
                accent: gymBlue,
              ),
              _KpiCard(
                title: "Aktivni clanovi",
                value: "${membership.activeMembers}",
                icon: Icons.people_alt_outlined,
                accent: const Color(0xFF7C3AED),
              ),
              _KpiCard(
                title: "Istekle clanarine",
                value: "${membership.expiredMembers}",
                icon: Icons.event_busy_outlined,
                accent: const Color(0xFFDC2626),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: [
              Container(
                width: 620,
                padding: const EdgeInsets.all(18),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Prihod po mjesecima ($_year)",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 280,
                      child: monthlyIncome.isEmpty
                          ? const _EmptyBox(text: "Nema podataka.")
                          : BarChart(
                              BarChartData(
                                maxY: maxMonthlyIncome == 0 ? 100 : maxMonthlyIncome * 1.25,
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: maxMonthlyIncome == 0
                                      ? 20
                                      : (maxMonthlyIncome * 1.25) / 5,
                                ),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 54,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(fontSize: 10),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index < 0 || index >= monthlyIncome.length) {
                                          return const SizedBox.shrink();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(
                                            monthlyIncome[index].label,
                                            style: const TextStyle(fontSize: 10),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                barGroups: List.generate(
                                  monthlyIncome.length,
                                  (index) {
                                    final item = monthlyIncome[index];
                                    return BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          toY: item.totalIncome,
                                          width: 18,
                                          borderRadius: BorderRadius.circular(6),
                                          color: gymBlue,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 360,
                padding: const EdgeInsets.all(18),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Paketi clanarina",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 240,
                      child: packages.isEmpty
                          ? const _EmptyBox(text: "Nema podataka.")
                          : PieChart(
                              PieChartData(
                                centerSpaceRadius: 40,
                                sectionsSpace: 2,
                                sections: List.generate(packages.length, (i) {
                                  final item = packages[i];
                                  final totalCount = packages.fold<int>(
                                    0,
                                    (sum, e) => sum + e.purchaseCount,
                                  );
                                  final percent = totalCount == 0
                                      ? 0
                                      : (item.purchaseCount / totalCount) * 100;

                                  return PieChartSectionData(
                                    color: packagePalette[i % packagePalette.length],
                                    value: item.purchaseCount.toDouble(),
                                    radius: 70,
                                    title: "${percent.toStringAsFixed(1)}%",
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  );
                                }),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    if (packages.isNotEmpty)
                      Column(
                        children: List.generate(packages.length, (i) {
                          final item = packages[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: packagePalette[i % packagePalette.length],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(item.membershipName)),
                                Text(
                                  item.purchaseCount.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (bestPackage != null) _BestPackageCard(package: bestPackage),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "sta ulazi u financijski PDF",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                const _PdfInfoRow(text: "Ukupan prihod, broj uplata i status clanarina"),
                const _PdfInfoRow(text: "Tabela prihoda po mjesecima"),
                const _PdfInfoRow(text: "Analiza paketa clanarina"),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerRight,
                  child: _ActionButton(
                    label: "Printaj financijski izvjestaj",
                    icon: Icons.picture_as_pdf_outlined,
                    color: financeGreen,
                    onPressed: _printMembershipReport,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _YearDropdown extends StatelessWidget {
  const _YearDropdown({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7EAF0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButton<int>(
        value: value,
        underline: const SizedBox(),
        borderRadius: BorderRadius.circular(12),
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        items: const [
          DropdownMenuItem(
            value: 2025,
            child: Text("2025"),
          ),
          DropdownMenuItem(
            value: 2026,
            child: Text("2026"),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _ReportSectionHeader extends StatelessWidget {
  const _ReportSectionHeader({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PdfInfoRow extends StatelessWidget {
  const _PdfInfoRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BestPackageCard extends StatelessWidget {
  const _BestPackageCard({required this.package});

  final MembershipPackageAnalytics package;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFF0F9D58).withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              color: Color(0xFF0F9D58),
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Najjaci paket po prihodu",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  package.membershipName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Kupovina: ${package.purchaseCount} • Prihod: ${package.totalIncome.toStringAsFixed(2)} KM",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: const Color(0xFFE7EAF0)),
    boxShadow: const [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 14,
        offset: Offset(0, 6),
      ),
    ],
  );
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w800),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 44),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text("Pokusaj ponovo"),
            ),
          ],
        ),
      ),
    );
  }
}
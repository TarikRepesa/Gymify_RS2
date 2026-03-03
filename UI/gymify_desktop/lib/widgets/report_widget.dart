import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gymify_desktop/models/dashboard_report.dart';
import 'package:gymify_desktop/providers/report_provider.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({super.key, this.year});

  /// Ako ne proslijediš godinu, uzima se trenutna godina.
  final int? year;

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color bg = Color(0xFFF5F7FB);

  bool _loading = true;
  String? _error;

  DashboardReport? _report;

  @override
  void initState() {
    super.initState();
    _load();
  }

  int get _year => widget.year ?? DateTime.now().year;

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
        // HEADER
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Gymify Izvjestaj",
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

        pw.SizedBox(height: 16),

        // KPI: BEST TRAINING
        pw.Text(
          "Najefikasniji trening svih vremena",
          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
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

        pw.SizedBox(height: 18),

        // TABLE: TOP TRAINERS
        pw.Text(
          "Najposjeceniji treneri ($year)",
          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
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
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
      ),
    ),
  );

  return doc.save();
}

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final provider = context.read<ReportProvider>();
      final res = await provider.getDashboard(year: _year, takeTopTrainers: 5);

      if (!mounted) return;
      setState(() {
        _report = res;
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

  Future<void> _printReport() async {
  if (_report == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Nema podataka za printanje.")),
    );
    return;
  }

  // 1) Save As dialog
  final path = await FilePicker.platform.saveFile(
    dialogTitle: 'Sačuvaj PDF izvještaj',
    fileName: 'Gymify_Izvjestaj_$_year.pdf',
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (path == null) return; // cancel

  try {
    setState(() => _loading = true);

    // 2) napravi PDF bytes
    final bytes = await _buildDashboardPdfBytes(
      report: _report!,
      year: _year,
    );

    // 3) snimi
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    // 4) otvori PDF
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
    final topTrainers = _report?.topTrainers ?? [];
    final best = _report?.bestTrainingAllTime;

    final totalTrainerVisits = topTrainers.fold<double>(
      0,
      (sum, e) => sum + e.count.toDouble(),
    );

    final palette = [
      const Color(0xFF3B82F6),
      const Color(0xFF22C55E),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        children: [
          // TITLE + PRINT BUTTON
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Izvještaji",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: _printReport,
                  icon: const Icon(Icons.print, size: 18),
                  label: const Text(
                    "Printaj izvještaj",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gymBlueDark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  /// ================= PIE CHART =================
                  Container(
                    width: 500,
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Najposjećeniji treneri ($_year)",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          height: 250,
                          child: topTrainers.isEmpty
                              ? const _EmptyBox(text: "Nema podataka.")
                              : PieChart(
                                  PieChartData(
                                    centerSpaceRadius: 40,
                                    sections: List.generate(topTrainers.length,
                                        (i) {
                                      final item = topTrainers[i];
                                      final percent = totalTrainerVisits == 0
                                          ? 0
                                          : (item.count / totalTrainerVisits) *
                                              100;

                                      return PieChartSectionData(
                                        color: palette[i % palette.length],
                                        value: item.count.toDouble(),
                                        radius: 70,
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

                        const SizedBox(height: 15),

                        /// Legenda
                        if (topTrainers.isNotEmpty)
                          Column(
                            children: List.generate(topTrainers.length, (i) {
                              final item = topTrainers[i];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      color: palette[i % palette.length],
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(item.name),
                                    ),
                                    Text(item.count.toString()),
                                  ],
                                ),
                              );
                            }),
                          ),
                      ],
                    ),
                  ),

                  /// ================= KPI CARD (BEST TRAINING) =================
                  Container(
                    width: 350,
                    padding: const EdgeInsets.all(20),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Najefikasniji trening svih vremena",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 25),

                        if (best == null)
                          const _EmptyBox(text: "Nema podataka.")
                        else ...[
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
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
                              const SizedBox(width: 16),
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
                                        fontWeight: FontWeight.bold,
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
                                      "Učestvovanja: ${best.participatedOfAllTime}",
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
                          const SizedBox(height: 18),

                          // mala "progress" vizuelizacija: best u odnosu na top trenera te godine (čisto UI)
                          Builder(
                            builder: (_) {
                              final maxYearCount = topTrainers.isEmpty
                                  ? 0
                                  : topTrainers
                                      .map((e) => e.count)
                                      .reduce((a, b) => a > b ? a : b);

                              // Ne mora biti realno poređenje (različite metrike),
                              // ali služi kao "vizuelni bar". Ako ne želiš, izbriši.
                              final denom = maxYearCount == 0 ? 1 : maxYearCount;
                              final value =
                                  (best.participatedOfAllTime / denom)
                                      .clamp(0.0, 1.0);

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
                                  LinearProgressIndicator(
                                    value: value,
                                    minHeight: 8,
                                    backgroundColor: const Color(0xFFEFEFEF),
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
            ],
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: const Color(0xFFE8E8E8)),
    boxShadow: const [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 12,
        offset: Offset(0, 6),
      )
    ],
  );
}

/// -----------------
/// Small UI helpers
/// -----------------

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
  const _ErrorState({required this.message, required this.onRetry});

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
            ElevatedButton(onPressed: onRetry, child: const Text("Pokušaj ponovo")),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:gymify_mobile/providers/training_provider.dart';
import 'package:gymify_mobile/widgets/review_widget.dart';
import 'package:provider/provider.dart';
import 'package:gymify_mobile/config/api_config.dart';
import 'package:gymify_mobile/dialogs/confirmation_dialogs.dart';
import 'package:gymify_mobile/helper/date_helper.dart';
import 'package:gymify_mobile/helper/image_helper.dart';
import 'package:gymify_mobile/helper/univerzal_pagging_helper.dart';
import 'package:gymify_mobile/models/reservation.dart';
import 'package:gymify_mobile/providers/reservation_provider.dart';
import 'package:gymify_mobile/widgets/swipe_widget.dart';

class ReservationWidget extends StatefulWidget {
  const ReservationWidget({super.key});

  @override
  State<ReservationWidget> createState() => _ReservationWidgetState();
}

class _ReservationWidgetState extends State<ReservationWidget> {
  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color lightGrey = Color(0xFFF2F2F2);

  final TextEditingController _searchCtrl = TextEditingController();

  late final UniversalPagingProvider<Reservation> _paging;

  @override
  void initState() {
    super.initState();

    _paging = UniversalPagingProvider<Reservation>(
      pageSize: 5,
      fetcher:
          ({
            required int page,
            required int pageSize,
            String? filter,
            Map<String, dynamic>? extra,
            bool includeTotalCount = true,
          }) async {
            final provider = context.read<ReservationProvider>();

            final query = _buildQuery(
              page: page,
              pageSize: pageSize,
              filter: filter,
              extra: extra,
              includeTotalCount: includeTotalCount,
            );

            return provider.get(filter: query);
          },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _paging.loadPage(pageNumber: 0);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _paging.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildQuery({
    required int page,
    required int pageSize,
    String? filter,
    Map<String, dynamic>? extra,
    required bool includeTotalCount,
  }) {
    return <String, dynamic>{
      "page": page,
      "pageSize": pageSize,
      if (includeTotalCount) "includeTotalCount": true,

      "IncludeTraining": true,
      "IncludeUser": true,

      if (filter != null && filter.isNotEmpty) "FTS": filter,

      ...?extra,
    };
  }

  Future<void> _onSearchChanged(String value) async {
    final v = value.trim();
    await _paging.applyExtra({"FTS": v});
  }

  Future<void> _resetFilters() async {
    setState(() {
      _searchCtrl.clear();
    });

    await _paging.applyExtra({});
    await _paging.loadPage(pageNumber: 0);
  }

  Future<void> _cancelReservation(Reservation r) async {
    final trainingName = r.training?.name ?? "trening";
    final trainingId = r.trainingId; // ili r.training?.id
    final trainingProvider = context.read<TrainingProvider>();

    final ok = await ConfirmDialogs.yesNoConfirmation(
      context,
      title: "Otkazivanje",
      question:
          "Da li ste sigurni da želite otkazati rezervaciju za:\n\n$trainingName?",
      yesText: "Otkaži",
      noText: "Nazad",
      danger: true,
    );

    if (!ok) return;

    try {
      final provider = context.read<ReservationProvider>();
      await provider.delete(r.id);

      await trainingProvider.down(trainingId);

      await ConfirmDialogs.okConfirmation(
        context,
        title: "Uspješno",
        message:
            "Rezervacija je uspješno otkazana.\n\nSvoje rezervacije možete pratiti u sekciji 'Rezervacije'.",
        okText: "U redu",
      );

      await _paging.refresh();
    } catch (e) {
      await ConfirmDialogs.okConfirmation(
        context,
        title: "Greška",
        message: "Nije moguće otkazati rezervaciju.\n\n$e",
        okText: "OK",
        danger: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _paging.refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: const Text(
                  "REZERVACIJE",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              // SEARCH + RESET
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: _InputLike(
                        hint: "Unesi ime treninga",
                        controller: _searchCtrl,
                        onChanged: _onSearchChanged,
                        leading: const Icon(Icons.search, size: 20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _resetFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Icon(Icons.refresh),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // LIST + SWIPE PAGING
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: SwipePagedList<Reservation>(
                  provider: _paging,
                  separatorHeight: 14,
                  itemBuilder: (context, r) {
                    final t = r.training;
                    final title = t?.name ?? "Trening";
                    final trainer = _trainerName(t);
                    final start = t?.startDate;

                    return _ReservationCard(
                      reservationId: r.id,
                      title: title,
                      trainer: trainer,
                      startDate: start,
                      createdAt: r.createdAt,
                      trainingImage: t?.trainingImage,
                      onCancel: () => _cancelReservation(r),
                      onReviewSuccess: () async {
                        final provider = context.read<ReservationProvider>();
                        await provider.delete(r.id);
                        await _paging.refresh();
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _trainerName(dynamic training) {
    try {
      final u = training?.user; // kod tebe je Training.user
      if (u == null) return "N/A";
      final fn = (u.firstName ?? "").toString().trim();
      final ln = (u.lastName ?? "").toString().trim();
      final full = "$fn $ln".trim();
      return full.isEmpty ? (u.username ?? "N/A") : full;
    } catch (_) {
      return "N/A";
    }
  }
}

// =========================
// UI bits
// =========================

class _InputLike extends StatelessWidget {
  const _InputLike({
    required this.hint,
    this.leading,
    this.controller,
    this.onTap,
    this.onChanged,
  });

  final String hint;
  final Widget? leading;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final readOnly = onTap != null && controller == null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 10)],
              Expanded(
                child: controller == null
                    ? Text(
                        hint,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: readOnly ? Colors.black87 : Colors.black54,
                        ),
                      )
                    : TextField(
                        controller: controller,
                        onChanged: onChanged,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black45,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
              ),
              if (controller == null) const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  const _ReservationCard({
    this.reservationId,
    required this.title,
    required this.trainer,
    required this.startDate,
    required this.createdAt,
    required this.trainingImage,
    required this.onCancel,
    this.onReviewSuccess,
  });

  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color lightGrey = Color(0xFFF2F2F2);

  final int? reservationId;
  final String title;
  final String trainer;
  final DateTime? startDate;
  final DateTime createdAt;
  final String? trainingImage;
  final VoidCallback onCancel;
  final Future<void> Function()? onReviewSuccess;

  bool get _trainingFinished {
    if (startDate == null) return false;
    return startDate!.toLocal().isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 4),
            color: Color(0x11000000),
          ),
        ],
      ),
      child: Column(
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 110,
              width: double.infinity,
              child: ImageHelper.hasValidImage(trainingImage)
                  ? (ImageHelper.isHttp(trainingImage!)
                        ? Image.network(
                            trainingImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _imgFallback(),
                          )
                        : Image.network(
                            "${ApiConfig.apiBase}/images/trainings/$trainingImage",
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _imgFallback(),
                          ))
                  : _imgFallback(),
            ),
          ),

          // BODY
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),

                _kv("Trener:", trainer),
                const SizedBox(height: 6),

                _kv(
                  "Datum treninga:",
                  startDate != null ? DateHelper.format(startDate!) : "-",
                ),
                const SizedBox(height: 6),

                _kv(
                  "Vrijeme treninga:",
                  startDate != null ? DateHelper.formatTime(startDate!) : "-",
                ),
                const SizedBox(height: 6),

                _kv("Rezervisano:", DateHelper.format(createdAt)),
                const SizedBox(height: 12),

                if (_trainingFinished) ...[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Trening završen — nadam se da ste uživali 😊",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionBtn(
                          text: "OSTAVI RECENZIJU",
                          color: gymBlueDark,
                          onTap: () async {
                            final ok = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReviewWidget(
                                  title: "RECENZIJA",
                                  subtitle: "Ostavi recenziju za: $title",
                                ),
                              ),
                            );

                            if (ok == true && onReviewSuccess != null) {
                              await onReviewSuccess!(); // 👈 javi parent-u
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: _ActionBtn(
                          text: "OTKAŽI",
                          color: Colors.red,
                          onTap: onCancel,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgFallback() {
    return Container(
      color: lightGrey,
      child: const Center(
        child: Icon(Icons.image_outlined, size: 42, color: Colors.black26),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Row(
      children: [
        Expanded(
          child: Text(
            k,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Text(
            v,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.text,
    required this.color,
    required this.onTap,
  });

  final String text;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

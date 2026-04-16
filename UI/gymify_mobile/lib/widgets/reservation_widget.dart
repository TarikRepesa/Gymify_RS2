import 'package:flutter/material.dart';
import 'package:gymify_mobile/dialogs/base_dialogs.dart';
import 'package:gymify_mobile/providers/loyalty_point_history_provider.dart';
import 'package:gymify_mobile/providers/loyalty_point_provider.dart';
import 'package:gymify_mobile/providers/training_provider.dart';
import 'package:gymify_mobile/utils/session.dart';
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
      await _paging.applyExtra({"Status": "Confirmed"});
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
      "userId": Session.userId,

      "IncludeTraining": true,
      "IncludeUser": true,

      if (filter != null && filter.isNotEmpty) "FTS": filter,

      ...?extra,
    };
  }

  Future<void> _onSearchChanged(String value) async {
    final v = value.trim();
    await _paging.applyExtra({"FTS": v, "Status": "Confirmed"});
  }

  Future<void> _resetFilters() async {
    setState(() {
      _searchCtrl.clear();
    });

    await _paging.applyExtra({"Status": "Confirmed"});
  }

  Future<String?> _showCancelReasonDialog(BuildContext context) async {
    final controller = TextEditingController();
    String? errorText;

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return GymifyBaseDialog(
              title: "Otkazivanje rezervacije",
              onClose: () => Navigator.of(ctx).pop(),
              width: 520,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Unesite razlog otkazivanja treninga:",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Npr. Ne mogu stići na vrijeme...",
                      errorText: errorText,
                      filled: true,
                      fillColor: const Color(0xFFF7F9FC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF0D47A1),
                          width: 1.4,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(ctx).pop(),
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 18,
                            ),
                            label: const Text(
                              "Nazad",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D47A1),
                              side: const BorderSide(
                                color: Color(0xFF0D47A1),
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final reason = controller.text.trim();

                              if (reason.isEmpty) {
                                setState(() {
                                  errorText = "Razlog otkazivanja je obavezan.";
                                });
                                return;
                              }

                              Navigator.of(ctx).pop(reason);
                            },
                            icon: const Icon(Icons.check_rounded, size: 18),
                            label: const Text(
                              "Potvrdi",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D47A1),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _cancelReservation(Reservation r) async {
    final lpProvider = context.read<LoyaltyPointProvider>();
    final lpProviderH = context.read<LoyaltyPointHistoryProvider>();
    final trainingName = r.training?.name ?? "trening";
    final trainingId = r.trainingId;
    final trainingProvider = context.read<TrainingProvider>();

    final ok = await ConfirmDialogs.yesNoConfirmation(
      context,
      title: "Otkazivanje",
      question:
          "Da li ste sigurni da želite otkazati rezervaciju za:\n\n$trainingName?",
      yesText: "Dalje",
      noText: "Nazad",
      danger: true,
    );

    if (!ok) return;

    final reason = await _showCancelReasonDialog(context);
    if (reason == null) return;

    try {
      final provider = context.read<ReservationProvider>();

      await provider.cancelReservation(r.id!, reason);

      await trainingProvider.down(trainingId);

      await lpProvider.subtractPoints({"userId": Session.userId, "points": 10});

      await lpProviderH.insert({
        "userId": Session.userId,
        "status": "Otkazivanje rezervacije",
        "amountPointsParticipation": 10,
        "createdAt": DateTime.now().toIso8601String(),
      });

      await ConfirmDialogs.okConfirmation(
        context,
        title: "Uspješno",
        message: "Rezervacija je uspješno otkazana.",
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

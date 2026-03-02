import 'package:flutter/material.dart';
import 'package:gymify_mobile/config/api_config.dart';
import 'package:gymify_mobile/dialogs/confirmation_dialogs.dart';
import 'package:gymify_mobile/helper/date_helper.dart';
import 'package:gymify_mobile/helper/image_helper.dart';
import 'package:gymify_mobile/providers/reservation_provider.dart';
import 'package:gymify_mobile/utils/session.dart';
import 'package:gymify_mobile/widgets/swipe_widget.dart';
import 'package:provider/provider.dart';
import 'package:gymify_mobile/helper/univerzal_pagging_helper.dart';
import 'package:gymify_mobile/models/training.dart';
import 'package:gymify_mobile/providers/training_provider.dart';

class TrainingWidget extends StatefulWidget {
  const TrainingWidget({super.key});

  @override
  State<TrainingWidget> createState() => _TrainingWidgetState();
}

class _TrainingWidgetState extends State<TrainingWidget> {
  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color lightGrey = Color(0xFFF2F2F2);

  final TextEditingController _searchCtrl = TextEditingController();
  DateTime? _selectedDate;

  late final UniversalPagingProvider<Training> _paging;

  @override
  void initState() {
    super.initState();

    _paging = UniversalPagingProvider<Training>(
      pageSize: 5,
      fetcher:
          ({
            required int page,
            required int pageSize,
            String? filter,
            Map<String, dynamic>? extra,
            bool includeTotalCount = true,
          }) async {
            final provider = context.read<TrainingProvider>();

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
    final q = <String, dynamic>{
      // ✅ Ako backend koristi druga imena, promijeni OVDJE:
      "page": page,
      "pageSize": pageSize,
      "IncludeUser": true,

      if (includeTotalCount) "includeTotalCount": true,
      if (filter != null && filter.isNotEmpty) "filter": filter,
      ...?extra,
    };

    // (Opcionalno) slanje datuma kao filter
    if (_selectedDate != null) {
      final d = _selectedDate!;
      final dd = d.day.toString().padLeft(2, '0');
      final mm = d.month.toString().padLeft(2, '0');
      final yyyy = d.year.toString();
      q["date"] = "$yyyy-$mm-$dd";
    }

    return q;
  }

  Future<void> _resetFilters() async {
    setState(() {
      _selectedDate = null;
      _searchCtrl.clear();
    });
    _paging.applyExtra({});
    await _paging.loadPage(pageNumber: 0);
  }

  Future<void> _onDateSearch() async {
    if (_selectedDate == null) {
      await _paging.applyExtra({});
    } else {
      await _paging.applyExtra({"StartDate": _selectedDate});
    }
  }

  Future<void> _reserveTraining(Training t) async {
    final ok = await ConfirmDialogs.yesNoConfirmation(
      context,
      title: "Rezervacija",
      question:
          "Da li ste sigurni da želite rezervisati trening:\n\n${t.name}?",
      yesText: "Rezerviši",
      noText: "Odustani",
    );

    if (!ok) return;

    try {
      final reservationProvider = context.read<ReservationProvider>();

      final request = {
        "userId": Session.userId,
        "trainingId": t.id,
        "createdAt": DateTime.now().toIso8601String()
      };

      await reservationProvider.insert(request);

      await ConfirmDialogs.okConfirmation(
        context,
        title: "Uspješno",
        message:
            "Rezervacija je uspješno kreirana.\n\nSve rezervacije možete pogledati u sekciji 'Rezervacije'.",
        okText: "U redu",
      );

      await _paging.refresh();
    } catch (e) {
      await ConfirmDialogs.okConfirmation(
        context,
        title: "Greška",
        message: "Nije moguće napraviti rezervaciju.\n\n$e",
        okText: "OK",
        danger: true,
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1, 1, 1),
      lastDate: DateTime(now.year + 2, 12, 31),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: const ColorScheme.light(primary: gymBlueDark)),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
      await _onDateSearch(); // 🔥 poziva applyExtra
    }
  }

  String _dateText() {
    if (_selectedDate == null) return "Odaberi datum";
    final d = _selectedDate!;
    return "${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}";
  }

  Future<void> _onSearchChanged(String value) async {
    await _paging.applyExtra({"FTS": value});
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
              // Header title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: const Text(
                  "TRENINGI",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              // Filters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    _InputLike(
                      onTap: _pickDate,
                      hint: _dateText(),
                      leading: const Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
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
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // List (paging + swipe) - bez Expanded, jer smo u scroll view
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: SwipePagedList<Training>(
                  provider: _paging,
                  separatorHeight: 14,
                  itemBuilder: (context, t) {
                    // ✅ prilagodi polja po tvom Training modelu
                    final title = (t.name ?? "Trening").toString();
                    final trainerName = _trainerName(t);
                    final isFull = _isFull(t);

                    return _TrainingCard(
                      title: title,
                      trainer: trainerName,
                      isFull: isFull,
                      maxParticipants: t.maxAmountOfParticipants,
                      currentParticipants: t.currentParticipants,
                      trainingImage: t.trainingImage,
                      startDate: t.startDate,
                      onReserve: isFull ? null : () async => await _reserveTraining(t),
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

  // ✅ Helperi - prilagodi po tvom Training modelu
  String _trainerName(Training t) {
    final trainer = t.user;
    if (trainer == null) return "N/A";

    final fn = (trainer.firstName ?? "").trim();
    final ln = (trainer.lastName ?? "").trim();
    final full = "$fn $ln".trim();
    return full.isEmpty ? (trainer.username ?? "N/A") : full;
  }

  bool _isFull(Training t) {
    final cap = t.maxAmountOfParticipants;
    final reserved = t.currentParticipants;
    if (cap != null && reserved != null) return reserved >= cap;
  }
}

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

class _TrainingCard extends StatelessWidget {
  const _TrainingCard({
    required this.title,
    required this.trainer,
    required this.isFull,
    required this.onReserve,
    this.maxParticipants,
    this.currentParticipants,
    this.trainingImage,
    this.startDate,
  });

  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color lightGrey = Color(0xFFF2F2F2);

  final String title;
  final String trainer;
  final bool isFull;
  final VoidCallback? onReserve;
  final int? maxParticipants;
  final int? currentParticipants;
  final String? trainingImage;
  final DateTime? startDate;

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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: ImageHelper.hasValidImage(trainingImage)
                  ? (ImageHelper.isHttp(trainingImage!)
                        ? Image.network(
                            trainingImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: lightGrey,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 42,
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          )
                        : Image.network(
                            "${ApiConfig.apiBase}/images/trainings/${trainingImage}",
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: lightGrey,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 42,
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ))
                  : Container(
                      color: lightGrey,
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 42,
                          color: Colors.black26,
                        ),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
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
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Trener:",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        trainer,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Popunjeno:",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        isFull ? "Da" : "Ne",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: isFull ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Max ljudi:",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        maxParticipants?.toString() ?? "-",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Prijavljeno:",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        currentParticipants?.toString() ?? "-",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Datum početka:",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        startDate != null ? DateHelper.format(startDate!) : "-",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Vrijeme početka:",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        startDate != null
                            ? DateHelper.formatTime(startDate!)
                            : "-",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionBtn(
                        text: "REZERVISI",
                        color: onReserve == null ? Colors.grey : gymBlue,
                        onTap: onReserve,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
  final VoidCallback? onTap;

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

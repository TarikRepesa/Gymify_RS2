import 'package:flutter/material.dart';
import 'package:gymify_mobile/config/api_config.dart';
import 'package:gymify_mobile/dialogs/confirmation_dialogs.dart';
import 'package:gymify_mobile/helper/date_helper.dart';
import 'package:gymify_mobile/helper/image_helper.dart';
import 'package:gymify_mobile/providers/loyalty_point_history_provider.dart';
import 'package:gymify_mobile/providers/loyalty_point_provider.dart';
import 'package:gymify_mobile/providers/member_provider.dart';
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

  List<Training> _recommendedTrainings = [];
  bool _isLoadingRecommended = false;

  @override
  void initState() {
    super.initState();

    _paging = UniversalPagingProvider<Training>(
      pageSize: 5,
      fetcher: ({
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
      await _loadRecommended();
      await _paging.applyExtra({"IsOld": false});
      await _paging.loadPage(pageNumber: 0);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _paging.dispose();
    super.dispose();
  }

  Future<void> _loadRecommended() async {
    setState(() => _isLoadingRecommended = true);

    try {
      final provider = context.read<TrainingProvider>();

      final items = await provider.getRecommended(
        filter: {"userId": Session.userId, "take": 3},
      );

      if (!mounted) return;

      setState(() {
        _recommendedTrainings = items;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _recommendedTrainings = [];
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingRecommended = false);
      }
    }
  }

  Future<bool> _hasValidMembership() async {
  try {
    final memberProvider = context.read<MemberProvider>();

    final result = await memberProvider.get(
      filter: {
        "userId": Session.userId,
        "page": 0,
        "pageSize": 1,
      },
    );

    if (result.items.isEmpty) {
      return false;
    }

    final member = result.items.first;
    final expirationDate = member.expirationDate;

    if (expirationDate == null) {
      return false;
    }

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final expirationOnly = DateTime(
      expirationDate.year,
      expirationDate.month,
      expirationDate.day,
    );

    return !expirationOnly.isBefore(todayOnly);
  } catch (_) {
    return false;
  }
}

  Map<String, dynamic> _buildQuery({
    required int page,
    required int pageSize,
    String? filter,
    Map<String, dynamic>? extra,
    required bool includeTotalCount,
  }) {
    final q = <String, dynamic>{
      "page": page,
      "pageSize": pageSize,
      "IncludeUser": true,
      "IsOld": false,
      if (includeTotalCount) "includeTotalCount": true,
      if (filter != null && filter.isNotEmpty) "filter": filter,
      ...?extra,
    };

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

    await _paging.applyExtra({"IsOld": false});
    await _paging.loadPage(pageNumber: 0);
  }

  Future<void> _onDateSearch() async {
    if (_selectedDate == null) {
      await _paging.applyExtra({"IsOld": false});
    } else {
      await _paging.applyExtra({
        "StartDate": _selectedDate,
        "IsOld": false,
      });
    }
  }

  Future<void> _reserveTraining(Training t) async {
  final reservationProvider = context.read<ReservationProvider>();
  final trainingProvider = context.read<TrainingProvider>();
  final lpProviderH = context.read<LoyaltyPointHistoryProvider>();
  final lpProvider = context.read<LoyaltyPointProvider>();

  final userId = Session.userId;
  final trainingId = t.id;

  final hasValidMembership = await _hasValidMembership();

  if (!hasValidMembership) {
    await ConfirmDialogs.okConfirmation(
      context,
      title: "Članarina istekla",
      message:
          "Ne možete rezervisati trening jer nemate aktivnu članarinu.\n\nMolimo vas da obnovite članarinu pa pokušate ponovo.",
      okText: "U redu",
      danger: true,
    );
    return;
  }

  final already = await reservationProvider.exists({
    "userId": userId,
    "trainingId": t.id,
  });

  if (already) {
    await ConfirmDialogs.okConfirmation(
      context,
      title: "Info",
      message: "Već imate rezervisan ovaj trening.",
      okText: "U redu",
    );
    return;
  }

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
    final request = {
      "userId": userId,
      "trainingId": trainingId,
      "createdAt": DateTime.now().toIso8601String(),
      "status": "Confirmed",
      "cancelledAt": null,
      "cancelReason": null,
    };

    await reservationProvider.insert(request);

    await trainingProvider.up(t.id);

    await lpProvider.addPoints({"userId": Session.userId, "points": 10});

    await lpProviderH.insert({
      "userId": Session.userId,
      "status": "Plaćanje nagrade",
      "amountPointsParticipation": 10,
      "createdAt": DateTime.now().toIso8601String(),
    });

    await ConfirmDialogs.okConfirmation(
      context,
      title: "Uspješno",
      message:
          "Rezervacija je uspješno kreirana.\n\nSve rezervacije možete pogledati u sekciji 'Rezervacije'.",
      okText: "U redu",
    );

    await _loadRecommended();
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
      await _onDateSearch();
    }
  }

  String _dateText() {
    if (_selectedDate == null) return "Odaberi datum";
    final d = _selectedDate!;
    return "${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}";
  }

  Future<void> _onSearchChanged(String value) async {
    await _paging.applyExtra({
      "FTS": value,
      "IsOld": false,
    });
  }

  Widget _buildRecommendedSection() {
    if (_isLoadingRecommended) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_recommendedTrainings.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: const Text(
          "Nemamo još dovoljno podataka za personalizovane preporuke. Nakon nekoliko rezervacija prikazat će se treninzi koji najviše odgovaraju vašim navikama.",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      );
    }

    return Column(
      children: _recommendedTrainings.map((t) {
        final title = (t.name ?? "Trening").toString();
        final trainerName = _trainerName(t);
        final isFull = _isFull(t);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _TrainingCard(
            title: title,
            trainer: trainerName,
            isFull: isFull,
            maxParticipants: t.maxAmountOfParticipants,
            currentParticipants: t.currentParticipants,
            durationMinutes: t.durationMinutes,
            intensityLevel: t.intensityLevel,
            purpose: t.purpose,
            trainingImage: t.trainingImage,
            startDate: t.startDate,
            onReserve: isFull ? null : () async => await _reserveTraining(t),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await _loadRecommended();
          await _paging.refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Preporučeni za vas",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: gymBlueDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: _buildRecommendedSection(),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Pretraži sve treninge",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: gymBlueDark,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

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

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: SwipePagedList<Training>(
                  provider: _paging,
                  separatorHeight: 14,
                  itemBuilder: (context, t) {
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
                      durationMinutes: t.durationMinutes,
                      intensityLevel: t.intensityLevel,
                      purpose: t.purpose,
                      startDate: t.startDate,
                      onReserve: isFull
                          ? null
                          : () async => await _reserveTraining(t),
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

    if (cap != null && reserved != null) {
      return reserved >= cap;
    }

    return false;
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
    this.durationMinutes,
    this.intensityLevel,
    this.purpose,
  });

  static const Color gymBlue = Color(0xFF1976D2);
  static const Color lightGrey = Color(0xFFF2F2F2);

  final String title;
  final String trainer;
  final bool isFull;
  final VoidCallback? onReserve;
  final int? maxParticipants;
  final int? currentParticipants;
  final String? trainingImage;
  final DateTime? startDate;
  final int? durationMinutes;
  final int? intensityLevel;
  final String? purpose;

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
                            "${ApiConfig.apiBase}/images/trainings/$trainingImage",
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
                        "Namjena:",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        purpose ?? "-",
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
                        "Trajanje:",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        durationMinutes != null
                            ? "${durationMinutes} min"
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

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Intenzitet:",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        intensityLevel?.toString() ?? "-",
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
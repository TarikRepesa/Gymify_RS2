import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymify_mobile/providers/loyalty_point_history_provider.dart';
import 'package:gymify_mobile/providers/loyalty_point_provider.dart';
import 'package:provider/provider.dart';

import 'package:gymify_mobile/dialogs/confirmation_dialogs.dart';
import 'package:gymify_mobile/models/reward.dart';
import 'package:gymify_mobile/models/user_reward.dart';
import 'package:gymify_mobile/providers/reward_provider.dart';
import 'package:gymify_mobile/providers/user_reward_provider.dart';
import 'package:gymify_mobile/utils/session.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color bg = Color(0xFFF5F7FB);

  bool _loading = true;
  String? _error;

  List<Reward> _rewards = [];
  List<UserReward> _userRewards = [];

  final Map<int, bool> _unlocking = {}; // rewardId -> loading

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final rewardProvider = context.read<RewardProvider>();
      final userRewardProvider = context.read<UserRewardProvider>();

      final rewardsResult = await rewardProvider.get(
        filter: {
          // ako imaš include polja na backendu, slobodno:
          // "IncludeSomething": true
        },
      );

      final userId = Session.userId;
      if (userId == null) throw Exception("Nema userId u sesiji.");

      final userRewardsResult = await userRewardProvider.get(
        filter: {"UserId": userId},
      );

      _rewards = rewardsResult.items;
      _userRewards = userRewardsResult.items;

      if (!mounted) return;
      setState(() => _loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  UserReward? _findUserReward(int rewardId) {
    try {
      return _userRewards.firstWhere((x) => x.rewardId == rewardId);
    } catch (_) {
      return null;
    }
  }

  String _rewardName(Reward r) {
    try {
      // ignore: invalid_use_of_protected_member
      final name = (r as dynamic).name;
      if (name != null && name.toString().trim().isNotEmpty)
        return name.toString();
    } catch (_) {}
    return "Nagrada";
  }

  String _rewardDesc(Reward r) {
    try {
      final d = (r as dynamic).description;
      if (d != null && d.toString().trim().isNotEmpty) return d.toString();
    } catch (_) {}
    return "Otključaj nagradu i iskoristi kod na recepciji ili u aplikaciji.";
  }

  int? _rewardRequiredPoints(Reward r) {
    try {
      final v = (r as dynamic).requiredPoints;
      if (v == null) return null;
      return int.tryParse(v.toString());
    } catch (_) {}
    return null;
  }

  String? _rewardImage(Reward r) {
    try {
      final v = (r as dynamic).image;
      if (v == null) return null;
      final s = v.toString().trim();
      return s.isEmpty ? null : s;
    } catch (_) {}
    try {
      final v = (r as dynamic).imageUrl;
      if (v == null) return null;
      final s = v.toString().trim();
      return s.isEmpty ? null : s;
    } catch (_) {}
    return null;
  }

  Future<void> _unlock(Reward r) async {
    final lpProvider = context.read<LoyaltyPointProvider>();
    final lpProviderH = context.read<LoyaltyPointHistoryProvider>();

    final loyalty = await lpProvider.get(filter: {"UserId": Session.userId});

    final currentPoints = loyalty.items.isNotEmpty
        ? loyalty.items.first.totalPoints
        : 0;

    final requiredPoints = r.requiredPoints ?? 0;

    if (currentPoints < requiredPoints) {
      await ConfirmDialogs.okConfirmation(
        context,
        title: "Nedovoljno poena",
        message:
            "Nemate dovoljno poena za ovu nagradu.\n\n"
            "Potrebno: $requiredPoints\n"
            "Imate: $currentPoints",
        okText: "U redu",
        danger: true,
      );
      return;
    }

    final userId = Session.userId;
    if (userId == null) return;

    final already = _findUserReward(r.id);
    if (already != null) {
      await _showCodeSheet(r: r, ur: already);
      return;
    }

    final ok = await ConfirmDialogs.yesNoConfirmation(
      context,
      title: "Otključavanje nagrade",
      question:
          "Da li želite otključati nagradu:\n\n"
          "${_rewardName(r)}?\n\n"
          "⚠ Kada jednom otključate nagradu, "
          "poeni će biti iskorišteni i ova radnja se ne može poništiti.",
      yesText: "Otključaj",
      noText: "Nazad",
      danger: true,
    );
    if (!ok) return;

    setState(() => _unlocking[r.id] = true);

    try {
      final userRewardProvider = context.read<UserRewardProvider>();

      final request = <String, dynamic>{"userId": userId, "rewardId": r.id};

      await userRewardProvider.insert(request);

      await lpProvider.subtractPoints({
        "userId": Session.userId,
        "points": r.requiredPoints,
      });
 
      await lpProviderH.insert({
        "userId": Session.userId,
        "status": "Plaćanje nagrade",
        "amountPointsParticipation": r.requiredPoints,
        "createdAt": DateTime.now().toIso8601String()
      });


      await ConfirmDialogs.okConfirmation(
        context,
        title: "Uspješno",
        message: "Nagrada je otključana. Kod je spreman za korištenje.",
        okText: "U redu",
      );

      await _load();

      final ur = _findUserReward(r.id);
      if (ur != null && mounted) {
        await _showCodeSheet(r: r, ur: ur);
      }
    } catch (e) {
      await ConfirmDialogs.okConfirmation(
        context,
        title: "Greška",
        message: "Nije moguće otključati nagradu.\n\n$e",
        okText: "OK",
        danger: true,
      );
    } finally {
      if (mounted) setState(() => _unlocking[r.id] = false);
    }
  }

  Future<void> _showCodeSheet({
    required Reward r,
    required UserReward ur,
  }) async {
    final code = (ur.code ?? "").trim();
    final used = ur.isUsed == true;

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _rewardName(r).toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7FB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    Text(
                      used ? "KOD (ISKORIŠTEN)" : "KOD",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: used ? Colors.red : gymBlueDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SelectableText(
                      code.isEmpty ? "N/A" : code,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: (code.isEmpty || used)
                                  ? null
                                  : () async {
                                      await Clipboard.setData(
                                        ClipboardData(text: code),
                                      );
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Kod kopiran."),
                                        ),
                                      );
                                    },
                              icon: const Icon(Icons.copy, size: 18),
                              label: const Text(
                                "KOPIRAJ",
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: gymBlueDark,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Text(
                "Kod pokaži na recepciji ili unesi gdje je predviđeno u aplikaciji.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: const Text(
          "Nagrade",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_error != null)
          ? _ErrorState(message: _error!, onRetry: _load)
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                children: [
                  _TopInfoCard(
                    title: "Nagrade i kodovi",
                    subtitle:
                        "Otključaj nagrade i preuzmi kod. Ako je nagrada već otključana, kod je ovdje.",
                  ),
                  const SizedBox(height: 12),

                  if (_rewards.isEmpty)
                    const _EmptyState()
                  else
                    ..._rewards.map((r) {
                      final ur = _findUserReward(r.id);
                      final unlocked = ur != null;
                      final used = ur?.isUsed == true;
                      final requiredPts = _rewardRequiredPoints(r);
                      final img = _rewardImage(r);
                      final isBusy = _unlocking[r.id] == true;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _RewardCard(
                          name: _rewardName(r),
                          description: _rewardDesc(r),
                          requiredPoints: requiredPts,
                          imageUrl: img,
                          unlocked: unlocked,
                          used: used,
                          code: ur?.code,
                          busy: isBusy,
                          onPrimaryTap: () {
                            if (unlocked) {
                              _showCodeSheet(r: r, ur: ur!);
                            } else {
                              _unlock(r);
                            }
                          },
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}

/// ================= UI COMPONENTS =================

class _TopInfoCard extends StatelessWidget {
  const _TopInfoCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard_rounded, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.name,
    required this.description,
    required this.requiredPoints,
    required this.imageUrl,
    required this.unlocked,
    required this.used,
    required this.code,
    required this.busy,
    required this.onPrimaryTap,
  });

  static const Color gymBlueDark = Color(0xFF0D47A1);

  final String name;
  final String description;
  final int? requiredPoints;
  final String? imageUrl;
  final bool unlocked;
  final bool used;
  final String? code;
  final bool busy;
  final VoidCallback onPrimaryTap;

  @override
  Widget build(BuildContext context) {
    final statusText = unlocked
        ? (used ? "ISKORIŠTENO" : "OTKLJUČANO")
        : "ZAKLJUČANO";

    final statusColor = unlocked
        ? (used ? Colors.red : const Color(0xFF16A34A))
        : const Color(0xFF6B7280);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // IMAGE HEADER
          if (imageUrl != null && imageUrl!.trim().isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imgFallback(),
                ),
              ),
            )
          else
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: SizedBox(
                height: 90,
                width: double.infinity,
                child: _imgFallback(),
              ),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE + STATUS
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: statusColor.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Text(
                  description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 10),

                if (requiredPoints != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.stars_rounded,
                        size: 18,
                        color: gymBlueDark,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Potrebno: $requiredPoints poena",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: busy ? null : onPrimaryTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: unlocked ? Colors.white : gymBlueDark,
                      foregroundColor: unlocked ? gymBlueDark : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: unlocked
                          ? BorderSide(color: gymBlueDark.withOpacity(0.25))
                          : BorderSide.none,
                    ),
                    child: busy
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            unlocked ? "PRIKAŽI KOD" : "OTKLJUČAJ",
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgFallback() {
    return Container(
      color: const Color(0xFFEFF2F7),
      child: const Center(
        child: Icon(Icons.card_giftcard, size: 40, color: Colors.black26),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: const Column(
        children: [
          Icon(Icons.inbox_outlined, size: 44),
          SizedBox(height: 10),
          Text(
            "Trenutno nema nagrada.",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
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
            ElevatedButton(
              onPressed: onRetry,
              child: const Text("Pokušaj ponovo"),
            ),
          ],
        ),
      ),
    );
  }
}

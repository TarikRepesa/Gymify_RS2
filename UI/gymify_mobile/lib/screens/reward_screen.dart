import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymify_mobile/dialogs/confirmation_dialogs.dart';
import 'package:gymify_mobile/helper/date_helper.dart';
import 'package:gymify_mobile/helper/univerzal_pagging_helper.dart';
import 'package:gymify_mobile/models/reward.dart';
import 'package:gymify_mobile/models/search_result.dart';
import 'package:gymify_mobile/models/user_reward.dart';
import 'package:gymify_mobile/providers/loyalty_point_provider.dart';
import 'package:gymify_mobile/providers/reward_provider.dart';
import 'package:gymify_mobile/providers/user_reward_provider.dart';
import 'package:gymify_mobile/utils/session.dart';
import 'package:gymify_mobile/widgets/swipe_widget.dart';
import 'package:provider/provider.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color bg = Color(0xFFF5F7FB);

  late final RewardProvider _rewardProvider;
  late final UserRewardProvider _userRewardProvider;
  late final LoyaltyPointProvider _loyaltyPointProvider;
  late final UniversalPagingProvider<Reward> _pagingProvider;

  bool _didChange = false;
  List<UserReward> _userRewards = [];
  final Map<int, bool> _unlocking = {};

  @override
  void initState() {
    super.initState();
    _rewardProvider = context.read<RewardProvider>();
    _userRewardProvider = context.read<UserRewardProvider>();
    _loyaltyPointProvider = context.read<LoyaltyPointProvider>();

    _pagingProvider = UniversalPagingProvider<Reward>(
      pageSize: 5,
      fetcher: _fetchVisibleRewardsPage,
    );

    Future.microtask(() => _pagingProvider.loadPage());
  }

  Future<SearchResult<Reward>> _fetchVisibleRewardsPage({
    required int page,
    required int pageSize,
    String? filter,
    Map<String, dynamic>? extra,
    bool includeTotalCount = true,
  }) async {
    final userId = Session.userId;
    if (userId == null) {
      throw Exception("Nema userId u sesiji.");
    }

    final rewardsResult = await _rewardProvider.get(filter: {});
    final userRewardsResult = await _userRewardProvider.get(
      filter: {
        "UserId": userId,
      },
    );

    _userRewards = userRewardsResult.items;

    var visibleRewards = rewardsResult.items.where(_shouldShowReward).toList();

    if (filter != null && filter.trim().isNotEmpty) {
      final f = filter.trim().toLowerCase();
      visibleRewards = visibleRewards.where((r) {
        final rewardName = r.name.toLowerCase();
        final rewardDesc = (r.description ?? '').toLowerCase();
        final ur = _findUserReward(r.id);
        final code = (ur?.code ?? '').toLowerCase();

        return rewardName.contains(f) ||
            rewardDesc.contains(f) ||
            code.contains(f);
      }).toList();
    }

    final start = page * pageSize;
    final end = (start + pageSize) > visibleRewards.length
        ? visibleRewards.length
        : (start + pageSize);

    final pagedItems = start >= visibleRewards.length
        ? <Reward>[]
        : visibleRewards.sublist(start, end);

    return SearchResult<Reward>(
      items: pagedItems,
      totalCount: includeTotalCount ? visibleRewards.length : 0,
    );
  }

  UserReward? _findUserReward(int rewardId) {
    for (final ur in _userRewards) {
      if (ur.rewardId == rewardId) return ur;
    }
    return null;
  }

  String _rewardName(Reward r) {
    final name = r.name.trim();
    return name.isEmpty ? "Nagrada" : name;
  }

  String _rewardDesc(Reward r) {
    final desc = (r.description ?? '').trim();
    if (desc.isNotEmpty) return desc;
    return "Otključaj nagradu i iskoristi kod u teretani.";
  }

  bool _rewardExpiredByDate(Reward r) {
    return r.validTo.isBefore(DateTime.now());
  }

  bool _rewardNotStarted(Reward r) {
    return r.validFrom.isAfter(DateTime.now());
  }

  bool _canBePurchased(Reward r) {
    return r.status == "Active" &&
        !_rewardExpiredByDate(r) &&
        !_rewardNotStarted(r);
  }

  bool _ownedCodeStillVisible(Reward r, UserReward ur) {
    if (_normalizeStatus(ur.status) == "Used") return true;
    return !_rewardExpiredByDate(r);
  }

  bool _shouldShowReward(Reward r) {
    final ur = _findUserReward(r.id);

    if (ur != null) {
      return _ownedCodeStillVisible(r, ur);
    }

    return _canBePurchased(r);
  }

  String _normalizeStatus(String? status) {
    final s = (status ?? '').trim();
    if (s.isEmpty) return "Active";
    return s;
  }

  bool _effectiveUsed(UserReward? ur) {
    return _normalizeStatus(ur?.status) == "Used";
  }

  Future<int> _currentPoints() async {
    final loyalty = await _loyaltyPointProvider.get(
      filter: {
        "UserId": Session.userId,
        "page": 0,
        "pageSize": 1,
      },
    );

    if (loyalty.items.isEmpty) return 0;
    return loyalty.items.first.totalPoints;
  }

  Future<void> _unlock(Reward r) async {
    final userId = Session.userId;
    if (userId == null) return;

    final already = _findUserReward(r.id);
    if (already != null) {
      if (_effectiveUsed(already)) return;
      await _showCodeSheet(r: r, ur: already);
      return;
    }

    if (r.status == "Planned") {
      await ConfirmDialogs.okConfirmation(
        context,
        title: "Nagrada nije dostupna",
        message: "Ova nagrada još nije dostupna za otključavanje.",
        okText: "U redu",
        danger: true,
      );
      return;
    }

    if (!_canBePurchased(r)) {
      await ConfirmDialogs.okConfirmation(
        context,
        title: "Nagrada nije dostupna",
        message: "Ova nagrada više nije dostupna.",
        okText: "U redu",
        danger: true,
      );
      return;
    }

    final currentPoints = await _currentPoints();
    final requiredPoints = r.requiredPoints;

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

    final ok = await ConfirmDialogs.yesNoConfirmation(
      context,
      title: "Otključavanje nagrade",
      question:
          "Da li želite otključati nagradu:\n\n"
          "${_rewardName(r)}?\n\n"
          "Poeni će biti iskorišteni i ova radnja se ne može poništiti.",
      yesText: "Otključaj",
      noText: "Nazad",
      danger: true,
    );

    if (!ok) return;

    setState(() {
      _unlocking[r.id] = true;
    });

    try {
      await _userRewardProvider.insert({
        "userId": userId,
        "rewardId": r.id,
      });

      _didChange = true;

      await ConfirmDialogs.okConfirmation(
        context,
        title: "Uspješno",
        message: "Nagrada je otključana. Kod je spreman za korištenje.",
        okText: "U redu",
      );

      await _pagingProvider.refresh();

      final ur = _findUserReward(r.id);
      if (ur != null && mounted && !_effectiveUsed(ur)) {
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
      if (mounted) {
        setState(() {
          _unlocking[r.id] = false;
        });
      }
    }
  }

  Future<void> _showCodeSheet({
    required Reward r,
    required UserReward ur,
  }) async {
    final code = (ur.code ?? "").trim();
    final isUsed = _effectiveUsed(ur);

    if (isUsed) return;

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
                    const Text(
                      "KOD",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: gymBlueDark,
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
                    SizedBox(
                      height: 44,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: code.isEmpty
                            ? null
                            : () async {
                                await Clipboard.setData(
                                  ClipboardData(text: code),
                                );
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
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
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                r.status == "SoftDeleted"
                    ? "Ova nagrada više nije u ponudi, ali tvoj kod i dalje vrijedi do ${DateHelper.format(r.validTo)}."
                    : "Kod možeš pokazati u bilo kojoj našoj najbližoj teretani.\nVaži do: ${DateHelper.format(r.validTo)}",
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

  void _closeScreen() {
    Navigator.pop(context, _didChange);
  }

  @override
  void dispose() {
    _pagingProvider.dispose();
    super.dispose();
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
          onPressed: _closeScreen,
        ),
        title: const Text(
          "Nagrade",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          _closeScreen();
          return false;
        },
        child: RefreshIndicator(
          onRefresh: _pagingProvider.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
            children: [
              const _TopInfoCard(
                title: "Nagrade i kodovi",
                subtitle:
                    "Otključaj nagrade i preuzmi kod. Ako je nagrada već otključana, kod je ovdje.",
              ),
              const SizedBox(height: 12),
              SwipePagedList<Reward>(
                provider: _pagingProvider,
                separatorHeight: 12,
                itemBuilder: (context, r) {
                  final ur = _findUserReward(r.id);
                  final unlocked = ur != null;
                  final used = _effectiveUsed(ur);
                  final unavailable = !_canBePurchased(r);
                  final isBusy = _unlocking[r.id] == true;

                  return _RewardCard(
                    name: _rewardName(r),
                    description: _rewardDesc(r),
                    requiredPoints: r.requiredPoints,
                    unlocked: unlocked,
                    used: used,
                    unavailable: unavailable,
                    status: r.status,
                    validTo: r.validTo,
                    busy: isBusy,
                    onPrimaryTap: () {
                      if (unlocked) {
                        if (used) return;
                        _showCodeSheet(r: r, ur: ur!);
                      } else {
                        _unlock(r);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    required this.unlocked,
    required this.used,
    required this.unavailable,
    required this.status,
    required this.validTo,
    required this.busy,
    required this.onPrimaryTap,
  });

  static const Color gymBlueDark = Color(0xFF0D47A1);

  final String name;
  final String description;
  final int requiredPoints;
  final bool unlocked;
  final bool used;
  final bool unavailable;
  final String status;
  final DateTime validTo;
  final bool busy;
  final VoidCallback onPrimaryTap;

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;

    if (unlocked) {
      if (used) {
        statusText = "ISKORIŠTENO";
        statusColor = Colors.red;
      } else if (status == "SoftDeleted") {
        statusText = "KOD AKTIVAN";
        statusColor = Colors.orange;
      } else {
        statusText = "OTKLJUČANO";
        statusColor = const Color(0xFF16A34A);
      }
    } else {
      if (status == "Planned") {
        statusText = "PLANIRANO";
        statusColor = Colors.blue;
      } else if (unavailable) {
        statusText = "NEDOSTUPNO";
        statusColor = const Color(0xFF6B7280);
      } else {
        statusText = "ZAKLJUČANO";
        statusColor = const Color(0xFF6B7280);
      }
    }

    final buttonDisabled = busy || used || (!unlocked && unavailable);

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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            if (unlocked) ...[
              const SizedBox(height: 10),
              Text(
                "Kod vrijedi do: ${DateHelper.format(validTo)}",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF374151),
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: buttonDisabled ? null : onPrimaryTap,
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
                        unlocked
                            ? (used ? "ISKORIŠTENO" : "PRIKAŽI KOD")
                            : (unavailable ? "NEDOSTUPNO" : "OTKLJUČAJ"),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
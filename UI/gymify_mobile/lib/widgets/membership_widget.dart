import 'package:flutter/material.dart';
import 'package:gymify_mobile/dialogs/confirmation_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:gymify_mobile/models/member.dart';
import 'package:gymify_mobile/models/membership.dart';
import 'package:gymify_mobile/providers/member_provider.dart';
import 'package:gymify_mobile/providers/membership_provider.dart';
import 'package:gymify_mobile/utils/session.dart';
import 'package:gymify_mobile/helper/stripe_payment_helper.dart';

class MembershipWidget extends StatefulWidget {
  const MembershipWidget({super.key});

  @override
  State<MembershipWidget> createState() => _MembershipWidgetState();
}

class _MembershipWidgetState extends State<MembershipWidget> {
  bool _loading = true;
  String? _error;

  Member? _currentMember;
  List<Membership> _plans = [];

  bool _yearly = false;
  Membership? _selectedPlan;
  bool _processing = false;

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
      final memberProvider = context.read<MemberProvider>();
      final membershipProvider = context.read<MembershipProvider>();

      final plansResult = await membershipProvider.get();
      final membersResult = await memberProvider.get(
        filter: {"IncludeMembership": true},
      );

      final plans = plansResult.items;
      final members = membersResult.items;

      Member? member;
      for (var m in members) {
        if (m.userId == Session.userId) {
          member = m;
          break;
        }
      }

      Membership? selectedPlan;
      if (plans.isNotEmpty) {
        if (member?.membershipId != null) {
          try {
            selectedPlan = plans.firstWhere((p) => p.id == member!.membershipId);
          } catch (_) {
            selectedPlan = plans.first;
          }
        } else {
          selectedPlan = plans.first;
        }
      }

      setState(() {
        _plans = plans;
        _currentMember = member;
        _selectedPlan = selectedPlan;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  bool get _hasMembership => _currentMember != null;

  bool get _isExpired {
    if (_currentMember == null) return true;
    return DateTime.now().isAfter(_currentMember!.expirationDate);
  }

  bool get _isActive => _hasMembership && !_isExpired;

  Membership? get _currentPlan => _currentMember?.membership;

  String _fmtDate(DateTime d) {
    final two = (int v) => v.toString().padLeft(2, '0');
    return "${two(d.day)}.${two(d.month)}.${d.year}";
  }

  double _priceForUi(Membership m) => _yearly ? m.yearPrice : m.monthlyPrice;

  Future<void> _submit() async {
  if (_selectedPlan == null || Session.userId == null) return;

  setState(() => _processing = true);

  try {
    final selected = _selectedPlan!;

    final stripeSuccess = await StripePaymentHelper.payMembership(
      context,
      userId: Session.userId!,
      membershipId: selected.id,
      yearly: _yearly,
    );

    if (!stripeSuccess) {
      if (mounted) setState(() => _processing = false);
      return;
    }

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    await ConfirmDialogs.okConfirmation(
      context,
      title: "Uspješno",
      message: "Plaćanje je uspješno završeno.",
      okText: "U redu",
    );

    if (!mounted) return;
    await _load();
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Greška: $e")),
    );
  } finally {
    if (mounted) setState(() => _processing = false);
  }
}

  String _primaryCtaText() {
    if (!_hasMembership) return "Učlani se";
    if (_isExpired) return "Obnovi članarinu";
    if (_selectedPlan != null && _currentPlan != null) {
      if (_selectedPlan!.id != _currentPlan!.id) return "Promijeni članarinu";
    }
    return "Produži članarinu";
  }

  bool _ctaEnabled() {
    return _selectedPlan != null && !_processing;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Članarina")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Greška pri učitavanju:\n$_error",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Članarina"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          children: [
            _StatusCard(
              hasMembership: _hasMembership,
              isActive: _isActive,
              isExpired: _isExpired,
              currentPlanName: _currentPlan?.name,
              paymentDate: _currentMember?.paymentDate,
              expirationDate: _currentMember?.expirationDate,
              fmt: _fmtDate,
            ),
            const SizedBox(height: 14),
            _PeriodToggle(
              yearly: _yearly,
              onChanged: (v) => setState(() => _yearly = v),
            ),
            const SizedBox(height: 14),
            Text(
              _hasMembership ? "Odaberi plan" : "Izaberi plan za učlanjenje",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            ..._plans.map((p) {
              final selected = _selectedPlan?.id == p.id;
              final current = _currentPlan?.id == p.id;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PlanTile(
                  plan: p,
                  selected: selected,
                  isCurrent: current,
                  price: _priceForUi(p),
                  yearly: _yearly,
                  onTap: () => setState(() => _selectedPlan = p),
                ),
              );
            }),
            const SizedBox(height: 18),
            _PrimaryActionBar(
              enabled: _ctaEnabled(),
              loading: _processing,
              ctaText: _primaryCtaText(),
              onPressed: _processing ? null : _submit,
            ),
            const SizedBox(height: 12),
            if (_hasMembership && _isActive)
              const _HintBox(
                text:
                    "Savjet: Ako promijeniš paket dok je aktivan, backend trenutno produžava članarinu od aktivnog datuma isteka ili od dana uplate, zavisno od toga šta je kasnije.",
              ),
          ],
        ),
      ),
    );
  }
}

/* ----------------------- UI WIDGETS ----------------------- */

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.hasMembership,
    required this.isActive,
    required this.isExpired,
    required this.currentPlanName,
    required this.paymentDate,
    required this.expirationDate,
    required this.fmt,
  });

  final bool hasMembership;
  final bool isActive;
  final bool isExpired;

  final String? currentPlanName;
  final DateTime? paymentDate;
  final DateTime? expirationDate;

  final String Function(DateTime) fmt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String title;
    String subtitle;

    if (!hasMembership) {
      title = "Nisi član";
      subtitle = "Odaberi paket i uplati prvu članarinu.";
    } else if (isActive) {
      title = "Članarina aktivna";
      subtitle = "Možeš produžiti ili promijeniti paket.";
    } else {
      title = "Članarina istekla";
      subtitle = "Obnovi članarinu da nastaviš koristiti usluge.";
    }

    final badgeText = !hasMembership
        ? "NEAKTIVNO"
        : (isActive ? "AKTIVNO" : "ISTEKLO");

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x11000000),
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _Badge(text: badgeText),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (hasMembership) ...[
            const SizedBox(height: 12),
            _InfoRow(label: "Trenutni paket", value: currentPlanName ?? "—"),
            const SizedBox(height: 6),
            _InfoRow(
              label: "Datum uplate",
              value: paymentDate != null ? fmt(paymentDate!) : "—",
            ),
            const SizedBox(height: 6),
            _InfoRow(
              label: "Ističe",
              value: expirationDate != null ? fmt(expirationDate!) : "—",
            ),
          ],
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final isActive = text == "AKTIVNO";
    final isExpired = text == "ISTEKLO";

    final bg = isActive
        ? const Color(0xFFECFDF3)
        : isExpired
            ? const Color(0xFFFFF1F2)
            : const Color(0xFFF3F4F6);

    final fg = isActive
        ? const Color(0xFF027A48)
        : isExpired
            ? const Color(0xFFB42318)
            : const Color(0xFF374151);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 11,
          color: fg,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class _PeriodToggle extends StatelessWidget {
  const _PeriodToggle({
    required this.yearly,
    required this.onChanged,
  });

  final bool yearly;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Period naplate",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Row(
            children: [
              Text(
                "Mjesečno",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: yearly ? Colors.black45 : Colors.black87,
                ),
              ),
              Switch(
                value: yearly,
                onChanged: onChanged,
              ),
              Text(
                "Godišnje",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: yearly ? Colors.black87 : Colors.black45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.plan,
    required this.selected,
    required this.isCurrent,
    required this.price,
    required this.yearly,
    required this.onTap,
  });

  final Membership plan;
  final bool selected;
  final bool isCurrent;
  final double price;
  final bool yearly;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = selected ? Colors.black87 : Colors.black12;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Color(0x11000000),
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.black87 : Colors.transparent,
                border: Border.all(color: Colors.black26),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            "Trenutni",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    yearly
                        ? "Godišnja članarina (12 mjeseci)"
                        : "Mjesečna članarina (1 mjesec)",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${price.toStringAsFixed(0)} KM",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  yearly ? "/ godišnje" : "/ mjesečno",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryActionBar extends StatelessWidget {
  const _PrimaryActionBar({
    required this.enabled,
    required this.loading,
    required this.ctaText,
    required this.onPressed,
  });

  final bool enabled;
  final bool loading;
  final String ctaText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                ctaText,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }
}

class _HintBox extends StatelessWidget {
  const _HintBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black54,
          height: 1.4,
        ),
      ),
    );
  }
}
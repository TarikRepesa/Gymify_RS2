import 'package:flutter/material.dart';
import 'package:gymify_mobile/widgets/home_widget.dart';
import 'package:gymify_mobile/widgets/membership_widget.dart';
import 'package:gymify_mobile/widgets/profile_widget.dart';
import 'package:gymify_mobile/widgets/reservation_widget.dart';
import 'package:gymify_mobile/widgets/staff_widget.dart';
import 'package:gymify_mobile/widgets/training_widget.dart';

class BaseMobileScreen extends StatefulWidget {
  const BaseMobileScreen({super.key});

  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);

  @override
  State<BaseMobileScreen> createState() => _BaseMobileScreenState();
}

class _BaseMobileScreenState extends State<BaseMobileScreen> {
  int _index = 0;

  late List<_TabItem> _tabs;

  GlobalKey<ProfileWidgetState> profileKey = GlobalKey<ProfileWidgetState>();

  @override
  void initState() {
    super.initState();
    _buildTabs();
  }

  Widget _buildTabBody(String label) {
    switch (label) {
      case "Početna":
        return HomeWidget(key: UniqueKey());
      case "Osoblje":
        return StaffWidget(key: UniqueKey());
      case "Treninzi":
        return TrainingWidget(key: UniqueKey());
      case "Članarine":
        return MembershipWidget(key: UniqueKey());
      case "Rezervacije":
        return ReservationWidget(key: UniqueKey());
      case "Profil":
        profileKey = GlobalKey<ProfileWidgetState>();
        return ProfileWidget(key: profileKey);
      default:
        return const SizedBox.shrink();
    }
  }

  void _buildTabs() {
    _tabs = [
      _TabItem(
        label: "Početna",
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        body: _buildTabBody("Početna"),
      ),
      _TabItem(
        label: "Osoblje",
        icon: Icons.person_3_outlined,
        activeIcon: Icons.person_3,
        body: _buildTabBody("Osoblje"),
      ),
      _TabItem(
        label: "Treninzi",
        icon: Icons.fitness_center_outlined,
        activeIcon: Icons.fitness_center,
        body: _buildTabBody("Treninzi"),
      ),
      _TabItem(
        label: "Članarine",
        icon: Icons.card_membership_outlined,
        activeIcon: Icons.card_membership,
        body: _buildTabBody("Članarine"),
      ),
      _TabItem(
        label: "Rezervacije",
        icon: Icons.note_alt_outlined,
        activeIcon: Icons.note_alt,
        body: _buildTabBody("Rezervacije"),
      ),
      _TabItem(
        label: "Profil",
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        body: _buildTabBody("Profil"),
      ),
    ];
  }

  void _resetTab(int index) {
    final current = _tabs[index];

    _tabs[index] = _TabItem(
      label: current.label,
      icon: current.icon,
      activeIcon: current.activeIcon,
      body: _buildTabBody(current.label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _tabs.map((t) => t.body).toList(),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 18,
              offset: Offset(0, -8),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: BaseMobileScreen.gymBlueDark,
          unselectedItemColor: const Color(0xFF8A8A8A),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          onTap: (index) async {
            final profileTabIndex = _tabs.indexWhere((t) => t.label == "Profil");

            if (_index == profileTabIndex) {
              final profileState = profileKey.currentState;

              if (profileState != null && profileState.hasUnsavedChanges()) {
                final shouldLeave = await profileState.confirmLeaveDialog();
                if (!shouldLeave) return;
              }
            }

            setState(() {
              _resetTab(index);
              _index = index;
            });
          },
          items: [
            for (final t in _tabs)
              BottomNavigationBarItem(
                icon: Icon(t.icon),
                activeIcon: Icon(t.activeIcon ?? t.icon),
                label: t.label,
              ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final Widget body;

  const _TabItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.body,
  });
}
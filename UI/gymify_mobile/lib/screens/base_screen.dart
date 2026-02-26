import 'package:flutter/material.dart';
import 'package:gymify_mobile/widgets/home_widget.dart';

class BaseMobileScreen extends StatefulWidget {
  const BaseMobileScreen({super.key});

  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);

  @override
  State<BaseMobileScreen> createState() => _BaseMobileScreenState();
}

class _BaseMobileScreenState extends State<BaseMobileScreen> {
  int _index = 0;

  late final List<_TabItem> _tabs = [
    _TabItem(
      label: "Početna",
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      body: const HomeWidget(),
    ),
    _TabItem(
      label: "Treninzi",
      icon: Icons.fitness_center_outlined,
      activeIcon: Icons.fitness_center,
      body: const Center(child: Text("Treninzi")),
    ),
    _TabItem(
      label: "Članarine",
      icon: Icons.card_membership_outlined,
      activeIcon: Icons.card_membership,
      body: const Center(child: Text("Članarine")),
    ),
    _TabItem(
      label: "Profil",
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      body: const Center(child: Text("Profil")),
    ),
  ];

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
          type: BottomNavigationBarType.fixed,
          selectedItemColor: BaseMobileScreen.gymBlueDark,
          unselectedItemColor: const Color(0xFF8A8A8A),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          onTap: (i) => setState(() => _index = i),
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
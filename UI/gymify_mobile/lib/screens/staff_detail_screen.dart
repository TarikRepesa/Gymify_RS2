import 'package:flutter/material.dart';
import 'package:gymify_mobile/config/api_config.dart';
import 'package:gymify_mobile/helper/date_helper.dart';
import 'package:gymify_mobile/helper/image_helper.dart';
import 'package:gymify_mobile/models/user.dart';

class StaffDetailsScreen extends StatelessWidget {
  const StaffDetailsScreen({super.key, required this.user});

  final User user;

  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color lightGrey = Color(0xFFF2F2F2);

  @override
  Widget build(BuildContext context) {
    final fullName = "${user.firstName} ${user.lastName}".trim().isEmpty
        ? user.username
        : "${user.firstName} ${user.lastName}".trim();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: gymBlueDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "DETALJI OSOBLJA",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.6),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // HEADER CARD
            _Card(
              child: Row(
                children: [
                  _Avatar(userImage: user.userImage, username: user.username),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "@${user.username}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Chip(
                              text: user.isActive ? "Aktivan" : "Neaktivan",
                              bg: user.isActive
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFEBEE),
                              fg: user.isActive ? Colors.green : Colors.red,
                              icon: user.isActive
                                  ? Icons.check_circle_outline
                                  : Icons.block,
                            ),
                            ..._roleChips(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // INFO GRID (kartice)
            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    title: "Email",
                    value: user.email.isEmpty ? "-" : user.email,
                    icon: Icons.email_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    title: "Telefon",
                    value:
                        (user.phoneNumber == null ||
                            user.phoneNumber!.trim().isEmpty)
                        ? "-"
                        : user.phoneNumber!,
                    icon: Icons.phone_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoTile(
                    title: "Datum rođenja",
                    value: user.dateOfBirth == null
                        ? "-"
                        : DateHelper.format(user.dateOfBirth!),
                    icon: Icons.cake_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    title: "Kreiran",
                    value: DateHelper.format(user.createdAt),
                    icon: Icons.calendar_month_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // NOTE / BIO (dummy sekcija)
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "O meni",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.aboutMe ?? "Nema detalja",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _roleChips() {
    final chips = <Widget>[];

    if (user.isAdmin == true) {
      chips.add(
        const _Chip(
          text: "Admin",
          bg: Color(0xFFE3F2FD),
          fg: Color(0xFF1565C0),
          icon: Icons.admin_panel_settings_outlined,
        ),
      );
    }
    if (user.isTrener == true) {
      chips.add(
        const _Chip(
          text: "Trener",
          bg: Color(0xFFF3E5F5),
          fg: Color(0xFF6A1B9A),
          icon: Icons.fitness_center,
        ),
      );
    }
    if (user.isRadnik == true) {
      chips.add(
        const _Chip(
          text: "Radnik",
          bg: Color(0xFFFFF3E0),
          fg: Color(0xFFEF6C00),
          icon: Icons.badge_outlined,
        ),
      );
    }

    if (chips.isEmpty) {
      chips.add(
        const _Chip(
          text: "Osoblje",
          bg: Color(0xFFF5F5F5),
          fg: Color(0xFF444444),
          icon: Icons.person_outline,
        ),
      );
    }

    return chips;
  }
}

// ===== UI bits =====

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
      child: child,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.userImage, required this.username});

  static const Color lightGrey = Color(0xFFF2F2F2);

  final String? userImage;
  final String username;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 78,
        height: 78,
        child: ImageHelper.hasValidImage(userImage)
            ? (ImageHelper.isHttp(userImage!)
                  ? Image.network(
                      userImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallback(),
                    )
                  : Image.network(
                      "${ApiConfig.apiBase}/images/users/$userImage",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallback(),
                    ))
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: lightGrey,
      child: const Center(
        child: Icon(Icons.person, size: 42, color: Colors.black26),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.text,
    required this.bg,
    required this.fg,
    required this.icon,
  });

  final String text;
  final Color bg;
  final Color fg;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 11,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF374151)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
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
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

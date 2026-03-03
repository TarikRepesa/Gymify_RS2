import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gymify_mobile/screens/login_screen.dart';
import 'package:gymify_mobile/screens/reward_screen.dart';
import 'package:provider/provider.dart';
import 'package:gymify_mobile/helper/date_helper.dart';
import 'package:gymify_mobile/helper/image_helper.dart';
import 'package:gymify_mobile/helper/text_editing_controller_helper.dart';
import 'package:gymify_mobile/models/user.dart';
import 'package:gymify_mobile/providers/image_provider.dart';
import 'package:gymify_mobile/providers/user_provider.dart';
import 'package:gymify_mobile/providers/loyalty_point_provider.dart';
import 'package:gymify_mobile/utils/session.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);

  late final UserProvider _userProvider;
  late final LoyaltyPointProvider _loyaltyProvider;

  final _formKey = GlobalKey<FormState>();
  late final Fields fields;

  User? _user;
  bool _loading = true;
  String? _error;

  // ✅ loyalty state
  bool _loyaltyLoading = false;
  int _totalPoints = 0;

  File? _pickedImage;
  bool _isImageChanged = false;

  Map<String, String> _initial = {};

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _loyaltyProvider = context.read<LoyaltyPointProvider>();

    fields = Fields.fromNames([
      'firstName',
      'lastName',
      'email',
      'username',
      'phoneNumber',
      'birthDate',
      'aboutMe',
    ]);

    _loadUser();
  }

  @override
  void dispose() {
    fields.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final userId = Session.userId;
      if (userId == null) throw Exception("Nema userId u sesiji.");

      final u = await _userProvider.getById(userId);

      fields.setText('firstName', u.firstName);
      fields.setText('lastName', u.lastName);
      fields.setText('email', u.email);
      fields.setText('username', u.username);
      fields.setText('phoneNumber', u.phoneNumber ?? '');

      try {
        fields.setText('aboutMe', (u.aboutMe ?? '').toString());
      } catch (_) {
        fields.setText('aboutMe', '');
      }

      if (u.dateOfBirth != null) {
        fields.setText('birthDate', DateHelper.format(u.dateOfBirth!));
      } else {
        fields.setText('birthDate', '');
      }

      _user = u;
      _pickedImage = null;
      _isImageChanged = false;
      _initial = Map<String, String>.from(fields.values());

      // ✅ load loyalty points
      await _loadLoyaltyPoints(userId);

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

  Future<void> _loadLoyaltyPoints(int userId) async {
    setState(() {
      _loyaltyLoading = true;
    });

    try {
      // Najčešći pattern kod tebe: provider.get(filter: Map) -> SearchResult sa items
      final result = await _loyaltyProvider.get(
        filter: <String, dynamic>{
          // ⚠️ Ako ti je na backendu drugačiji naziv, promijeni ovdje:
          "UserId": userId,
          "page": 0,
          "pageSize": 1,
          "IncludeUser": false,
        },
      );

      int points = 0;

      try {
        // ako je tip SearchResult<LoyaltyPoint>
        final items = (result as dynamic).items as List<dynamic>;
        if (items.isNotEmpty) {
          points = (items.first as dynamic).totalPoints as int;
        }
      } catch (_) {
        // fallback: ako result dođe kao lista ili nešto drugo
        try {
          final items = (result as List);
          if (items.isNotEmpty) {
            points = (items.first as dynamic).totalPoints as int;
          }
        } catch (_) {
          points = 0;
        }
      }

      if (!mounted) return;
      setState(() {
        _totalPoints = points;
        _loyaltyLoading = false;
      });
    } catch (_) {
      // Nemoj rušiti profil zbog loyalty poziva – samo prikaži 0
      if (!mounted) return;
      setState(() {
        _totalPoints = 0;
        _loyaltyLoading = false;
      });
    }
  }

  bool _hasChanges() {
    if (_isImageChanged) return true;

    final now = fields.values();
    for (final k in _initial.keys) {
      if ((now[k] ?? '') != (_initial[k] ?? '')) return true;
    }
    return false;
  }

  Future<void> _pickImage() async {
    final file = await ImageHelper.openImagePicker();
    if (file == null) return;

    setState(() {
      _pickedImage = file;
      _isImageChanged = true;
    });
  }

  Future<void> _save() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final userId = Session.userId;
    if (userId == null) return;

    try {
      final oldImg = _user?.userImage;
      String? finalImage = oldImg;

      if (finalImage != null && finalImage.trim().isEmpty) {
        finalImage = null;
      }

      if (_pickedImage != null) {
        final uploadedFileName = await ImageAppProvider.upload(
          file: _pickedImage!,
          folder: "users",
        );
        finalImage = uploadedFileName;
      }

      await _userProvider.update(userId, {
        "firstName": fields.text("firstName"),
        "lastName": fields.text("lastName"),
        "email": fields.text("email"),
        "username": fields.text("username"),
        "phoneNumber": fields.text("phoneNumber"),
        "dateOfBirth": DateHelper.toIsoFromUi(fields.text("birthDate")),
        "userImage": finalImage,
        "aboutMe": fields.text("aboutMe"),
        "isActive": _user?.isActive ?? true,
        "createdAt": _user?.createdAt.toIso8601String(),
        "lastLoginAt": _user?.lastLoginAt?.toIso8601String(),
      });

      if (_pickedImage != null &&
          oldImg != null &&
          oldImg.trim().isNotEmpty &&
          oldImg != finalImage) {
        await ImageAppProvider.delete(folder: "users", fileName: oldImg);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil je uspješno sačuvan.")),
      );

      await _loadUser();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Greška: $e")));
    }
  }

  void _logout() {
    Session.odjava();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSave =
        !_loading && _error == null && _user != null && _hasChanges();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_error != null)
          ? _ErrorState(message: _error!, onRetry: _loadUser)
          : (_user == null)
          ? _ErrorState(message: "Korisnik nije učitan.", onRetry: _loadUser)
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _ProfileHeader(
                    user: _user!,
                    pickedImage: _pickedImage,
                    onChangeImage: _pickImage,
                    onLogout: _logout,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
                    child: Column(
                      children: [
                        _LoyaltyCard(
                          loading: _loyaltyLoading,
                          totalPoints: _totalPoints,
                          onRewardsTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RewardsScreen(),
                              ),
                            );

                            if (result == true) {
                              _loadUser(); // ili _loadLoyaltyPoints();
                              setState(() {}); // reset UI
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        _SectionCard(
                          title: "Osnovni podaci",
                          icon: Icons.badge_outlined,
                          child: _ProfileForm(
                            formKey: _formKey,
                            fields: fields,
                            onAnyChanged: () => setState(() {}),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _MiniTipsCard(
                          title: "Savjet",
                          message:
                              "Rezervacijom treninga skupljaš poene. Što više poena, veće pogodnosti 😊",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 18,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canSave ? _save : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: gymBlueDark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Sačuvaj promjene",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// =====================
/// LOYALTY CARD
/// =====================

class _LoyaltyCard extends StatelessWidget {
  const _LoyaltyCard({
    required this.loading,
    required this.totalPoints,
    required this.onRewardsTap,
  });

  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);

  final bool loading;
  final int totalPoints;
  final VoidCallback onRewardsTap;

  @override
  Widget build(BuildContext context) {
    const threshold = 10;
    final remainder = totalPoints % threshold;
    final toNext = remainder == 0 ? 0 : (threshold - remainder);
    final progress = threshold == 0 ? 0.0 : (remainder / threshold);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gymBlueDark, gymBlue],
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.22)),
                ),
                child: const Icon(Icons.stars_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "LOYALTY POENI",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: loading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        "$totalPoints",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 42,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRewardsTap,
              icon: const Icon(Icons.card_giftcard_rounded, size: 18),
              label: const Text(
                "POGLEDAJ NAGRADE",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0D47A1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Svaka rezervacija = +1 poen",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.92),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// =====================
/// HEADER (spušten PROFIL + logout)
/// =====================

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
    required this.pickedImage,
    required this.onChangeImage,
    required this.onLogout,
  });

  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);

  final User user;
  final File? pickedImage;
  final VoidCallback onChangeImage;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final name = "${user.firstName} ${user.lastName}".trim();
    final username = (user.username ?? "").toString();
    final email = (user.email ?? "").toString();

    Widget avatar;
    if (pickedImage != null) {
      avatar = Image.file(pickedImage!, fit: BoxFit.cover);
    } else {
      final img = user.userImage;
      if (ImageHelper.hasValidImage(img)) {
        avatar = Image.network(
          img!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => ImageHelper.userPlaceholder(username),
        );
      } else {
        avatar = ImageHelper.userPlaceholder(username);
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gymBlueDark, gymBlue],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    "PROFIL",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: onLogout,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withOpacity(0.22)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.logout, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Odjava",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Stack(
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: Colors.white.withOpacity(0.18),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                padding: const EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: avatar,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: InkWell(
                  onTap: onChangeImage,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.camera_alt_outlined, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name.isEmpty ? "Korisnik" : name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "@$username · $email",
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.90),
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================
/// FORM SECTION
/// =====================

class _ProfileForm extends StatelessWidget {
  const _ProfileForm({
    required this.formKey,
    required this.fields,
    required this.onAnyChanged,
  });

  final GlobalKey<FormState> formKey;
  final Fields fields;
  final VoidCallback onAnyChanged;

  String? _req(String? v, String msg) =>
      (v == null || v.trim().isEmpty) ? msg : null;

  String? _email(String? v) {
    final value = (v ?? '').trim();
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return regex.hasMatch(value) ? null : "Neispravan email.";
  }

  String? _username(String? v) {
    final value = (v ?? '').trim();
    final regex = RegExp(r'^[a-zA-Z0-9._-]{3,20}$');
    return regex.hasMatch(value) ? null : "Username 3–20 (slova/brojevi/._-).";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _field(
                  label: "Ime",
                  icon: Icons.person_outline,
                  controller: fields.controller("firstName"),
                  validator: (v) => _req(v, "Ime je obavezno."),
                  onChanged: (_) => onAnyChanged(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _field(
                  label: "Prezime",
                  icon: Icons.person_outline,
                  controller: fields.controller("lastName"),
                  validator: (v) => _req(v, "Prezime je obavezno."),
                  onChanged: (_) => onAnyChanged(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _field(
            label: "Email",
            icon: Icons.mail_outline,
            controller: fields.controller("email"),
            keyboardType: TextInputType.emailAddress,
            validator: _email,
            onChanged: (_) => onAnyChanged(),
          ),
          const SizedBox(height: 12),
          _field(
            label: "Username",
            icon: Icons.alternate_email,
            controller: fields.controller("username"),
            validator: _username,
            onChanged: (_) => onAnyChanged(),
          ),
          const SizedBox(height: 12),
          _dateField(
            context: context,
            label: "Datum rođenja",
            controller: fields.controller("birthDate"),
            onAnyChanged: onAnyChanged,
          ),
          const SizedBox(height: 12),
          _field(
            label: "Telefon",
            icon: Icons.phone_outlined,
            controller: fields.controller("phoneNumber"),
            keyboardType: TextInputType.phone,
            validator: (v) => _req(v, "Telefon je obavezan."),
            onChanged: (_) => onAnyChanged(),
          ),
          const SizedBox(height: 12),
          _field(
            label: "O meni (opcionalno)",
            icon: Icons.info_outline,
            controller: fields.controller("aboutMe"),
            maxLines: 3,
            validator: (_) => null,
            onChanged: (_) => onAnyChanged(),
          ),
        ],
      ),
    );
  }

  Widget _dateField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required VoidCallback onAnyChanged,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      validator: (v) => _req(v, "Datum rođenja je obavezan."),
      decoration: _decoration(label, Icons.calendar_month_outlined),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime(now.year - 18),
          firstDate: DateTime(1900),
          lastDate: now,
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: LoginScreen.gymBlueDark,
              ),
            ),
            child: child!,
          ),
        );
        if (picked == null) return;

        controller.text = DateHelper.format(picked);
        onAnyChanged();
      },
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: const Color(0xFFF7F8FA),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0x11000000)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: LoginScreen.gymBlueDark,
          width: 1.6,
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      decoration: _decoration(label, icon),
    );
  }
}

/// =====================
/// COMMON UI
/// =====================

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF1F2937)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MiniTipsCard extends StatelessWidget {
  const _MiniTipsCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, size: 18),
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
                  message,
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

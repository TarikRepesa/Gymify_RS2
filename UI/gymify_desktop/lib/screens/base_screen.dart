import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gymify_desktop/config/api_config.dart';
import 'package:gymify_desktop/dialogs/base_dialogs_frame.dart';
import 'package:gymify_desktop/dialogs/confirmation_dialogs.dart';
import 'package:gymify_desktop/helper/image_helper.dart';
import 'package:gymify_desktop/helper/text_editing_controller_helper.dart';
import 'package:gymify_desktop/providers/image_provider.dart';
import 'package:gymify_desktop/routes/app_routes.dart';
import 'package:gymify_desktop/widgets/trainer_task_widget.dart';
import 'package:gymify_desktop/widgets/worker_task_widget.dart';
import 'package:provider/provider.dart';
import 'package:gymify_desktop/models/user.dart';
import 'package:gymify_desktop/providers/user_provider.dart';
import 'package:gymify_desktop/utils/session.dart';
import 'package:gymify_desktop/widgets/member_widget.dart';
import 'package:gymify_desktop/widgets/membership_widget.dart';
import 'package:gymify_desktop/widgets/notification_widget.dart';
import 'package:gymify_desktop/widgets/report_widget.dart';
import 'package:gymify_desktop/widgets/review_widget.dart';
import 'package:gymify_desktop/widgets/staff_widget.dart';
import 'package:gymify_desktop/widgets/training_widget.dart';

class BaseScreen extends StatefulWidget {
  final String? title;
  const BaseScreen({super.key, this.title});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  // NOTE: _activeItem se sada postavlja po roli (u initState)
  String _activeItem = 'Obavijesti';
  late Widget _bodyWidget;

  late UserProvider _userProvider;
  User? _loggedUser;
  bool _isLoadingUser = true;
  bool _loadedOnce = false;
  bool _hoverUser = false;

  File? _pickedImage;
  bool _isImageChanged = false;

  final _formKey = GlobalKey<FormState>();
  late Fields fields;

  // ---------------- ROLE HELPERS ----------------
  bool _hasRole(String role) =>
      Session.roles.any((r) => r.toLowerCase() == role.toLowerCase());

  bool get _isAdmin => _hasRole("Admin");
  bool get _isWorker => _hasRole("Radnik");
  bool get _isTrainer => _hasRole("Trener");

  List<String> _allowedMenus() {
    if (_isAdmin) {
      return [
        "Osoblje",
        "Članovi",
        "Treninzi",
        "Članarine",
        "Obavijesti",
        "Recenzije",
        "Izvještaj",
      ];
    }

    if (_isWorker) {
      return [
        "Moji zadaci",
        "Članovi",
        "Treninzi",
        "Članarine",
        "Obavijesti",
        "Recenzije",
        "Izvještaj",
      ];
    }

    if (_isTrainer) {
      return ["Moji treninzi", "Obavijesti", "Izvještaj"];
    }

    return [];
  }

  void _ensureActiveMenuAllowed() {
    final menus = _allowedMenus();
    if (menus.isEmpty) return;

    if (!menus.contains(_activeItem)) {
      setState(() {
        _activeItem = menus.first;
        _bodyWidget = _getWidgetForMenu(_activeItem);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Postavi početni meni po roli
    final menus = _allowedMenus();
    _activeItem = menus.isNotEmpty ? menus.first : "Obavijesti";
    _bodyWidget = _getWidgetForMenu(_activeItem);

    fields = Fields.fromNames([
      'firstName',
      'lastName',
      'email',
      'username',
      'phoneNumber',
      'birthDate',
    ]);
  }

  @override
  void dispose() {
    fields.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // didChangeDependencies može više puta
    if (!_loadedOnce) {
      _loadedOnce = true;
      _userProvider = context.read<UserProvider>();
      _loadLoggedUser();
    }
  }

  Future<void> _loadLoggedUser() async {
    try {
      if (Session.userId == null) {
        setState(() => _isLoadingUser = false);
        return;
      }

      final user = await _userProvider.getById(Session.userId!);

      if (!mounted) return;
      setState(() {
        _loggedUser = user;
        _isLoadingUser = false;
      });

      // ako se role/meni promijene, osiguraj active
      _ensureActiveMenuAllowed();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  Widget _getWidgetForMenu(String menu) {
    switch (menu) {
      case 'Osoblje':
        return StaffWidget();
      case 'Članovi':
        return MemberWidget();
      case 'Treninzi':
        return TrainingWidget();
      case 'Članarine':
        return MembershipWidget();
      case 'Obavijesti':
        return NotificationWidget();
      case 'Recenzije':
        return ReviewWidget();
      case 'Izvještaj':
        return ReportWidget();

      // NOVO:
      case 'Moji zadaci':
        return WorkerTaskWidget();
      case 'Moji treninzi':
        return TrainerTaskWidget();

      default:
        return const Center(child: Text('Nije pronađen menu'));
    }
  }

  void _onMenuTap(String menu) {
    final allowed = _allowedMenus();
    if (!allowed.contains(menu)) return;

    setState(() {
      _activeItem = menu;
      _bodyWidget = _getWidgetForMenu(menu);
    });
  }

  Widget _menuItem(String text) {
    final bool isActive = _activeItem == text;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onMenuTap(text),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFFC107) : Colors.transparent,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _datePickerField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required VoidCallback onAnyChanged,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        suffixIcon: const Icon(Icons.calendar_month_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) =>
          v == null || v.isEmpty ? "Datum rođenja je obavezan." : null,
      onTap: () async {
        final now = DateTime.now();

        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime(now.year - 18),
          firstDate: DateTime(1900),
          lastDate: now,
        );

        if (picked == null) return;

        controller.text =
            "${picked.day.toString().padLeft(2, '0')}. "
            "${picked.month.toString().padLeft(2, '0')}. "
            "${picked.year}.";

        onAnyChanged();
      },
    );
  }

  Future<void> _showUserSettingsDialog() async {
    await _loadLoggedUser();
    if (!mounted) return;

    _pickedImage = null;
    _isImageChanged = false;

    final user = _loggedUser;
    if (user != null) {
      fields.setText('firstName', user.firstName);
      fields.setText('lastName', user.lastName);
      fields.setText('email', user.email);
      fields.setText('username', user.username);
      fields.setText('phoneNumber', user.phoneNumber ?? '');
      if (user.dateOfBirth != null) {
        fields.setText(
          'birthDate',
          "${user.dateOfBirth!.day.toString().padLeft(2, '0')}. "
              "${user.dateOfBirth!.month.toString().padLeft(2, '0')}. "
              "${user.dateOfBirth!.year}.",
        );
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          bool hasChanges() {
            if (_isImageChanged) return true;

            if (user == null) return false;
            return fields.text('firstName') != user.firstName ||
                fields.text('lastName') != user.lastName ||
                fields.text('email') != user.email ||
                fields.text('username') != user.username ||
                fields.text('phoneNumber') != (user.phoneNumber ?? '');
          }

          return BaseDialog(
            title: "Postavke profila",
            width: 640,
            height: 650,
            onClose: () {
              Navigator.pop(context);
            },
            child: _userSettingsContent(
              user: user,
              onChangeImage: () async {
                final picked = await ImageHelper.openImagePicker();
                if (picked == null) return;
                setStateDialog(() {
                  _pickedImage = picked;
                  _isImageChanged = true;
                });
              },
              onAnyChanged: () => setStateDialog(() {}),
              isSaveEnabled: hasChanges(),
              onSave: () async {
                final ok = _formKey.currentState?.validate() ?? false;
                if (!ok) return;

                String? finalImage = user?.userImage;
                if (_pickedImage != null) {
                  final uploadedFileName = await ImageAppProvider.upload(
                    file: _pickedImage!,
                    folder: "users",
                  );
                  finalImage = uploadedFileName;
                }

                await _userProvider.update(Session.userId!, {
                  'firstName': fields.text("firstName"),
                  'lastName': fields.text("lastName"),
                  'email': fields.text("email"),
                  'username': fields.text("username"),
                  'phoneNumber': fields.text("phoneNumber"),
                  'dateOfBirth': fields.text("birthDate").isNotEmpty
                      ? DateTime.parse(
                          fields
                              .text("birthDate")
                              .replaceAll('.', '')
                              .split(' ')
                              .reversed
                              .join('-'),
                        ).toIso8601String()
                      : null,
                  'userImage': finalImage,
                });

                await _loadLoggedUser();
                if (context.mounted) Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _userSettingsContent({
    required User? user,
    required Future<void> Function() onChangeImage,
    required VoidCallback onAnyChanged,
    required bool isSaveEnabled,
    required Future<void> Function() onSave,
  }) {
    if (user == null) {
      return const Center(child: Text("Korisnik nije učitan."));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 150,
                  height: 150,
                  color: const Color(0x11000000),
                  child: _pickedImage != null
                      ? Image.file(_pickedImage!, fit: BoxFit.cover)
                      : (ImageHelper.hasValidImage(user.userImage)
                            ? Image.network(
                                ImageHelper.isHttp(user.userImage!)
                                    ? user.userImage!
                                    : "${ApiConfig.apiBase}/images/users/${user.userImage!}",
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    ImageHelper.userPlaceholder(user.username),
                              )
                            : ImageHelper.userPlaceholder(user.username)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user.firstName} ${user.lastName}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3F3F3F),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B6B6B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  await onChangeImage();
                  onAnyChanged();
                },
                icon: const Icon(Icons.photo_camera_outlined, size: 18),
                label: const Text('Promijeni sliku'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _settingsField(
                        label: "Ime",
                        controller: fields.controller("firstName"),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? "Ime je obavezno."
                            : null,
                        onChanged: (_) => onAnyChanged(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _settingsField(
                        label: "Prezime",
                        controller: fields.controller("lastName"),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? "Prezime je obavezno."
                            : null,
                        onChanged: (_) => onAnyChanged(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _settingsField(
                        label: "Email",
                        controller: fields.controller("email"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || !v.contains("@"))
                            ? "Unesite ispravan email."
                            : null,
                        onChanged: (_) => onAnyChanged(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _settingsField(
                        label: "Username",
                        controller: fields.controller("username"),
                        validator: (v) => (v == null || v.trim().length < 3)
                            ? "Username min 3 znaka."
                            : null,
                        onChanged: (_) => onAnyChanged(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _datePickerField(
                  context: context,
                  label: "Datum rođenja",
                  controller: fields.controller("birthDate"),
                  onAnyChanged: onAnyChanged,
                ),
                const SizedBox(height: 12),
                _settingsField(
                  label: "Telefon",
                  controller: fields.controller("phoneNumber"),
                  keyboardType: TextInputType.phone,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? "Telefon je obavezan."
                      : null,
                  onChanged: (_) => onAnyChanged(),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// 🔴 LOGOUT BUTTON
            OutlinedButton.icon(
              onPressed: () async {
                final confirmed = await ConfirmDialogs.yesNoConfirmation(
                  context,
                  title: "Odjava",
                  question: "Da li ste sigurni da se želite odjaviti?",
                  yesText: "Da, odjavi me",
                  noText: "Otkaži",
                );

                if (!confirmed) return;

                Session.odjava();

                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Odjava",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: isSaveEnabled ? () => onSave() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF387EFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Sačuvaj",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _settingsField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _userTile() {
    if (_isLoadingUser) {
      return const SizedBox();
    }

    final user = _loggedUser;
    final fullName = "${user?.firstName ?? ''} ${user?.lastName ?? ''}".trim();

    Widget avatar;

    if (user != null && ImageHelper.hasValidImage(user.userImage)) {
      final imagePath = user.userImage!;
      avatar = CircleAvatar(
        radius: 20,
        backgroundImage: ImageHelper.isHttp(imagePath)
            ? NetworkImage(imagePath)
            : NetworkImage("${ApiConfig.apiBase}/images/users/$imagePath"),
      );
    } else {
      avatar = CircleAvatar(
        radius: 24,
        backgroundColor: Colors.white.withOpacity(0.25),
        child: ImageHelper.userPlaceholder(
          fullName.isEmpty ? "Korisnik" : fullName,
        ),
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoverUser = true),
      onExit: (_) => setState(() => _hoverUser = false),
      child: GestureDetector(
        onTap: _showUserSettingsDialog,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _hoverUser
                ? Colors.white.withOpacity(0.18)
                : Colors.white.withOpacity(0.10),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.18), width: 1),
            ),
          ),
          child: Row(
            children: [
              avatar,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName.isEmpty ? "Korisnik" : fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user?.username ?? "",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.settings, size: 18, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    final menus = _allowedMenus();

    return Container(
      width: 250,
      height: double.infinity,
      color: const Color(0xFF387EFF),
      child: Column(
        children: [
          const SizedBox(height: 40),
          SizedBox(
            height: 120,
            child: Image.asset(
              'assets/images/gymify_logo.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),

          Expanded(
            child: menus.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Nemate privilegije za pristup aplikaciji.",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(children: menus.map(_menuItem).toList()),
                  ),
          ),

          _userTile(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menus = _allowedMenus();
    final body = menus.isEmpty
        ? const Center(child: Text("Nemate privilegije za pristup."))
        : _bodyWidget;

    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: body),
        ],
      ),
    );
  }
}

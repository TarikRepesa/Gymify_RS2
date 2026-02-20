import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/forgot_password_dialog.dart';
import 'package:gymify_desktop/utils/session.dart';
import 'package:provider/provider.dart';
import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/models/login_request.dart';
import 'package:gymify_desktop/providers/auth_provider.dart';
import 'package:gymify_desktop/routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color gymLightBlue = Color(0xFFE3F2FD);
  static const Color textDark = Color(0xFF1C1C1C);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthProvider _authProvider;

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _hoverForgot = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }



  Future<void> _forgotPasswordOrUsername() async {
  await showDialog(
    context: context,
    barrierDismissible: false, 
    builder: (_) => const ForgotPasswordDialog(),
  );
}

  Future<void> login() async {
    final result = await _authProvider.prijava(
      LoginRequest(username: _username.text.trim(), password: _password.text),
    );

    if (result == "ZABRANJENO") {
      SnackbarHelper.showError(
        context,
        'Nemate privilegije za pristup aplikaciji',
      );
      return;
    }

    if (result != "OK") {
      SnackbarHelper.showError(context, 'Pogrešno korisničko ime ili lozinka');
      return;
    }

    if (result == "OK") {
      final allowed = Session.roles.any(
        (r) => [
          "Admin",
          "Radnik",
          "Trener",
        ].any((x) => x.toLowerCase() == r.toLowerCase()),
      );

      if (!allowed) {
        Session.odjava();
        SnackbarHelper.showError(
          context,
          'Nemate privilegije za pristup aplikaciji',
        );
        return;
      }

      Navigator.pushReplacementNamed(context, AppRoutes.base);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [LoginScreen.gymLightBlue, LoginScreen.gymBlue],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.fromLTRB(32, 32, 32, 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 30,
                      offset: Offset(0, 18),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// LOGO
                    SizedBox(
                      height: 120,
                      child: Image.asset(
                        'assets/images/gymify_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// APP NAME
                    const Text(
                      "GYMIFY",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: LoginScreen.gymBlueDark,
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),

                    _inputField(
                      controller: _username,
                      hintText: 'Korisničko ime',
                      icon: Icons.person,
                    ),

                    const SizedBox(height: 16),

                    _inputField(
                      controller: _password,
                      hintText: 'Lozinka',
                      icon: Icons.lock,
                      obscureText: true,
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LoginScreen.gymBlueDark,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "ULOGUJ SE",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => _hoverForgot = true),
                      onExit: (_) => setState(() => _hoverForgot = false),
                      child: GestureDetector(
                        onTap: _forgotPasswordOrUsername,
                        child: Text(
                          "Zaboravili ste korisničko ime ili lozinku?",
                          style: TextStyle(
                            color: _hoverForgot
                                ? LoginScreen.gymBlueDark
                                : LoginScreen.gymBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          prefixIcon: Icon(icon, color: LoginScreen.gymBlue),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.white, width: 1.4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: LoginScreen.gymBlueDark,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

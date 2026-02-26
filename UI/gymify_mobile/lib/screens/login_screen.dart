import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gymify_mobile/dialogs/forgot_password_dialog.dart';
import 'package:gymify_mobile/helper/snackBar_helper.dart';
import 'package:gymify_mobile/models/login_request.dart';
import 'package:gymify_mobile/providers/auth_provider.dart';
import 'package:gymify_mobile/routes/app_routes.dart';

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

  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  bool _isLoading = false;
  bool _obscure = true;

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
      barrierDismissible: true,
      builder: (_) => const ForgotPasswordDialog(),
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final result = await _authProvider.prijava(
        LoginRequest(
          username: _username.text.trim(),
          password: _password.text,
        ),
      );

      if (!mounted) return;

      if (result == "ZABRANJENO") {
        SnackbarHelper.showError(
          context,
          'Nemate privilegije za pristup aplikaciji',
        );
        return;
      }

      if (result != "OK") {
        SnackbarHelper.showError(
          context,
          'Pogrešno korisničko ime ili lozinka',
        );
        return;
      }

      Navigator.pushReplacementNamed(context, AppRoutes.base);
    } catch (e) {
      if (!mounted) return;
      SnackbarHelper.showError(context, 'Greška pri prijavi. Pokušaj ponovo: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              LoginScreen.gymLightBlue,
              LoginScreen.gymBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.only(bottom: bottomInset > 0 ? 12 : 0),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 24,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 4),

                          // Logo + naslov
                          Column(
                            children: [
                              SizedBox(
                                width: 64,
                                height: 64,
                                child: Image.asset(
                                  'assets/images/gymify_logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'GYMIFY',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  color: LoginScreen.gymBlueDark,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            'Prijavi se da nastaviš',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6E6E6E),
                            ),
                          ),

                          const SizedBox(height: 18),

                          _inputField(
                            controller: _username,
                            hintText: 'Korisničko ime',
                            icon: Icons.person_outline,
                            keyboardType: TextInputType.text,
                            autofillHints: const [AutofillHints.username],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Unesi korisničko ime';
                              }
                              if (v.trim().length < 3) {
                                return 'Korisničko ime je prekratko';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          _inputField(
                            controller: _password,
                            hintText: 'Lozinka',
                            icon: Icons.lock_outline,
                            obscureText: _obscure,
                            keyboardType: TextInputType.visiblePassword,
                            autofillHints: const [AutofillHints.password],
                            suffix: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure ? Icons.visibility_off : Icons.visibility,
                                color: const Color(0xFF8A8A8A),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Unesi lozinku';
                              if (v.length < 4) return 'Lozinka je prekratka';
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _forgotPasswordOrUsername,
                              child: const Text(
                                'Zaboravljena lozinka?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF6E6E6E),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 4),

                          SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: LoginScreen.gymBlueDark,
                                foregroundColor: Colors.white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text(
                                      'Uloguj se',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Nemaš račun?',
                                style: TextStyle(
                                  color: Color(0xFF6E6E6E),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.register);
                                },
                                child: const Text(
                                  'Registruj se',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: LoginScreen.gymBlueDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffix,
    List<String>? autofillHints,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        prefixIcon: Icon(icon, color: LoginScreen.gymBlue),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: LoginScreen.gymBlueDark,
            width: 2,
          ),
        ),
      ),
    );
  }
}
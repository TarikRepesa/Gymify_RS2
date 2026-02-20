import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gymify_desktop/providers/user_provider.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();

  String? error;
  String? success;
  bool isLoading = false;

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(email);
  }

  Future<void> _submit() async {
    setState(() {
      error = null;
      success = null;
    });

    final email = _emailController.text.trim();

    if (!_isValidEmail(email)) {
      setState(() => error = "Unesite ispravan email.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final userProvider = context.read<UserProvider>();
      await userProvider.forgotPassword(email);

      if (!mounted) return;

      setState(() {
        success = "Email je poslan. Provjerite inbox/spam folder.";
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = "Neuspješno slanje. Provjerite email ili pokušajte ponovo.";
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "ZABORAVLJENA LOZINKA",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Unesite email povezan sa vašim nalogom.",
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) => isLoading ? null : _submit(),
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              if (error != null) ...[
                const SizedBox(height: 10),
                Text(
                  error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],

              if (success != null) ...[
                const SizedBox(height: 10),
                Text(
                  success!,
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],

              const SizedBox(height: 18),

              Row(
                children: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text("Zatvori"),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6FB7E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Pošalji mail",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
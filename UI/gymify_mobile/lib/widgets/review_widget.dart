import 'package:flutter/material.dart';
import 'package:gymify_mobile/utils/session.dart';
import 'package:provider/provider.dart';

import 'package:gymify_mobile/dialogs/confirmation_dialogs.dart';
import 'package:gymify_mobile/providers/review_provider.dart';

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color lightGrey = Color(0xFFF2F2F2);

  final TextEditingController _messageCtrl = TextEditingController();
  int _stars = 5;
  bool _submitting = false;

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;

    final msg = _messageCtrl.text.trim();
    if (msg.isEmpty) {
      await ConfirmDialogs.okConfirmation(
        context,
        title: "Validacija",
        message: "Molim te unesi poruku recenzije.",
        okText: "OK",
        danger: true,
      );
      return;
    }

    final ok = await ConfirmDialogs.yesNoConfirmation(
      context,
      title: "Potvrda",
      question: "Da li ste sigurni da želite poslati recenziju?",
      yesText: "Pošalji",
      noText: "Nazad",
    );

    if (!ok) return;

    setState(() => _submitting = true);

    try {
      final provider = context.read<ReviewProvider>();

      final request = <String, dynamic>{
        "userId": Session.userId,
        "message": msg,
        "starNumber": _stars,
      };

      await provider.insert(request);

      await ConfirmDialogs.okConfirmation(
        context,
        title: "Uspješno",
        message: "Hvala! Recenzija je uspješno poslana.",
        okText: "U redu",
      );

      if (!mounted) return;
      Navigator.pop(context, true); 
    } catch (e) {
      await ConfirmDialogs.okConfirmation(
        context,
        title: "Greška",
        message: "Nije moguće poslati recenziju.\n\n$e",
        okText: "OK",
        danger: true,
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _reset() {
    setState(() {
      _stars = 5;
      _messageCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gymBlueDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.6),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.subtitle != null && widget.subtitle!.trim().isNotEmpty) ...[
                    Text(
                      widget.subtitle!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  const Text(
                    "Ocjena",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _StarRow(
                        value: _stars,
                        onChanged: (v) => setState(() => _stars = v),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: lightGrey,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Text(
                          "$_stars/5",
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    "Poruka",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: TextField(
                      controller: _messageCtrl,
                      maxLines: 5,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Napiši svoje mišljenje...",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _ActionBtn(
                          text: "RESET",
                          color: Colors.grey.shade300,
                          textColor: Colors.black87,
                          onTap: _submitting ? null : _reset,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionBtn(
                          text: _submitting ? "ŠALJEM..." : "POŠALJI",
                          color: gymBlueDark,
                          textColor: Colors.white,
                          onTap: _submitting ? null : _submit,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== UI =====

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

class _StarRow extends StatelessWidget {
  const _StarRow({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final idx = i + 1;
        final filled = idx <= value;

        return IconButton(
          onPressed: () => onChanged(idx),
          icon: Icon(
            filled ? Icons.star : Icons.star_border,
            color: Colors.orange,
          ),
          splashRadius: 18,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        );
      }),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.text,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 0.6,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
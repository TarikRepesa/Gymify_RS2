import 'package:flutter/material.dart';

enum TriConfirmResult { cancel, bad, good }

class ConfirmDialogs {
  ConfirmDialogs._();

  static const Color _primaryBlue = Color(0xFF1976D2);
  static const Color _primaryBlueDark = Color(0xFF0D47A1);
  static const Color _dangerRed = Color(0xFFE53935);
  static const Color _text = Color(0xFF374151);
  static const Color _muted = Color(0xFF6B7280);

  static const double _radius = 14;

  static Future<T?> _baseDialog<T>(
    BuildContext context, {
    required String title,
    required String message,
    required List<Widget> actions,
    bool barrierDismissible = false,
    Color? headerColor,
    IconData? headerIcon,
  }) {
    final Color headerBg = headerColor ?? _primaryBlueDark;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🟦 HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        headerBg,
                        headerBg == _dangerRed ? _dangerRed : _primaryBlue,
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(_radius),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (headerIcon != null) ...[
                        Icon(headerIcon, color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // BODY
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                      color: _text,
                    ),
                  ),
                ),

                // ACTIONS
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static ButtonStyle _outlineBtn({required Color color}) {
    return OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(color: color, width: 1.2),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  static ButtonStyle _filledBtn({required Color bg, Color fg = Colors.white}) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // ✅ YES / NO
  static Future<bool> yesNoConfirmation(
    BuildContext context, {
    required String question,
    String title = 'Potvrda',
    String yesText = 'Da',
    String noText = 'Ne',
    bool barrierDismissible = false,
    bool danger = false, // ako je true: crveni header + yes dugme crveno
  }) async {
    final res = await _baseDialog<bool>(
      context,
      title: title,
      message: question,
      barrierDismissible: barrierDismissible,
      headerColor: danger ? _dangerRed : _primaryBlueDark,
      headerIcon: danger ? Icons.warning_amber_rounded : Icons.help_outline_rounded,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: _outlineBtn(color: _muted),
          child: Text(noText, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: _filledBtn(bg: danger ? _dangerRed : _primaryBlueDark),
          child: Text(yesText, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
    );

    return res ?? false;
  }

  // ✅ OK
  static Future<void> okConfirmation(
    BuildContext context, {
    required String message,
    String title = 'Informacija',
    String okText = 'OK',
    bool barrierDismissible = false,
    bool danger = false, // ako true: crveni header
  }) async {
    await _baseDialog<void>(
      context,
      title: title,
      message: message,
      barrierDismissible: barrierDismissible,
      headerColor: danger ? _dangerRed : _primaryBlueDark,
      headerIcon: danger ? Icons.error_outline_rounded : Icons.info_outline_rounded,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: _filledBtn(bg: danger ? _dangerRed : _primaryBlueDark),
          child: Text(okText, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }

  // ✅ BAD / GOOD (npr. “Obriši / Sačuvaj”, “Otkaži / Potvrdi”)
  static Future<bool> badGoodConfirmation(
    BuildContext context, {
    required String question,
    String title = 'Potvrda',
    required String goodText,
    required String badText,
    bool barrierDismissible = false,
    bool goodIsPrimaryBlue = true,
  }) async {
    final res = await _baseDialog<bool>(
      context,
      title: title,
      message: question,
      barrierDismissible: barrierDismissible,
      headerColor: _primaryBlueDark,
      headerIcon: Icons.fact_check_outlined,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: _outlineBtn(color: _dangerRed),
          child: Text(badText, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: _filledBtn(bg: goodIsPrimaryBlue ? _primaryBlueDark : _primaryBlue),
          child: Text(goodText, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
    );

    return res ?? false;
  }
}
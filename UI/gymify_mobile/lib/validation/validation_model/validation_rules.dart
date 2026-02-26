

import 'package:gymify_mobile/validation/validation_model/validation_field_rule.dart';

class Rules {
  static FieldRule requiredText(String field, String value, String message) {
    return FieldRule(field, () => value.trim().isEmpty ? message : null);
  }

  static FieldRule minLength(
    String field,
    String value,
    int min,
    String message,
  ) {
    return FieldRule(field, () => value.trim().length < min ? message : null);
  }

  static FieldRule positiveNumber(String field, String value, String message) {
    return FieldRule(field, () {
      final v = double.tryParse(value.replaceAll(',', '.'));
      if (v == null || v <= 0) return message;
      return null;
    });
  }

  static FieldRule requiredDate(String field, DateTime? date, String message) {
    return FieldRule(field, () => date == null ? message : null);
  }

  static FieldRule requiredMapPoint(
    String field,
    dynamic pickedPoint,
    String message,
  ) {
    return FieldRule(field, () => pickedPoint == null ? message : null);
  }

  static FieldRule atLeastOneTag(
    String field,
    List<String>? selectedTags,
    String message,
  ) {
    return FieldRule(
      field,
      () => (selectedTags == null || selectedTags.isEmpty) ? message : null,
    );
  }


  static FieldRule email(
    String field,
    String value, {
    bool required = true,
  }) {
    return FieldRule(field, () {
      final v = value.trim();

      if (!required && v.isEmpty) return null;
      if (v.isEmpty) return 'Email je obavezan.';

      final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      if (!regex.hasMatch(v)) {
        return 'Unesi ispravan email (npr. ime.prezime@domena.com).';
      }

      return null;
    });
  }

  static FieldRule username(
    String field,
    String value, {
    bool required = true,
    int min = 3,
    int max = 20,
  }) {
    return FieldRule(field, () {
      final v = value.trim();

      if (!required && v.isEmpty) return null;
      if (v.isEmpty) return 'Username je obavezan.';

      if (v.length < min || v.length > max) {
        return 'Username mora imati između $min i $max karaktera.';
      }

      final allowed = RegExp(r'^[a-zA-Z0-9._]+$');
      if (!allowed.hasMatch(v)) {
        return 'Username smije sadržati slova, brojeve, "." i "_".';
      }

      if (v.startsWith('.') ||
          v.startsWith('_') ||
          v.endsWith('.') ||
          v.endsWith('_')) {
        return 'Username ne smije početi ili završiti sa "." ili "_".';
      }

      if (v.contains('..') ||
          v.contains('__') ||
          v.contains('._') ||
          v.contains('_.')) {
        return 'Username ne smije imati duple znakove (.., __, ._, _.)';
      }

      return null;
    });
  }



  static FieldRule phone(
    String field,
    String value, {
    bool required = false,
    int minDigits = 7,
    int maxDigits = 15,
  }) {
    return FieldRule(field, () {
      final v = value.trim();

      if (!required && v.isEmpty) return null;
      if (v.isEmpty) return 'Telefon je obavezan.';

      final allowedChars = RegExp(r'^[0-9+\-\s()]+$');
      if (!allowedChars.hasMatch(v)) {
        return 'Unesi ispravan broj telefona.';
      }

      final digits = v.replaceAll(RegExp(r'\D'), '');

      if (digits.length < minDigits || digits.length > maxDigits) {
        return 'Telefon mora imati između $minDigits i $maxDigits cifara.';
      }

      if (v.contains('+') && !v.startsWith('+')) {
        return 'Znak + može biti samo na početku.';
      }

      return null;
    });
  }



  static FieldRule strongPassword(
    String field,
    String value,
  ) {
    return FieldRule(field, () {
      final v = value;

      final hasMin = v.length >= 8;
      final hasUpper = RegExp(r'[A-Z]').hasMatch(v);
      final hasLower = RegExp(r'[a-z]').hasMatch(v);
      final hasDigit = RegExp(r'\d').hasMatch(v);

      if (!hasMin || !hasUpper || !hasLower || !hasDigit) {
        return 'Lozinka mora imati 8+ znakova, veliko/malo slovo i broj.';
      }

      return null;
    });
  }
}

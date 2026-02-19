import 'package:gymify_desktop/validation/validation_model/validation_field_rule.dart';

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

  // static FieldRule atLeastOneImage(
  //   String field,
  //   List<PropertyImageDisplay>? images,
  //   String message,
  // ) {
  //   return FieldRule(field, () {
  //     if (images == null) return message;
  //     final visible = images.where((e) => !e.isDeleted);
  //     return visible.isEmpty ? message : null;
  //   });
  // }

  // static FieldRule mainImageRequired(
  //   String field,
  //   List<PropertyImageDisplay>? images,
  //   String message,
  // ) {
  //   return FieldRule(field, () {
  //     if (images == null) return message;

  //     final visible = images.where((e) => !e.isDeleted);
  //     final mainCount = visible.where((e) => e.propertyImage.isMain).length;

  //     return mainCount == 1 ? null : message;
  //   });
  // }

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

  static FieldRule email(String field, String value, String message) {
  return FieldRule(field, () {
    final v = value.trim();
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return regex.hasMatch(v) ? null : message;
  });
}

static FieldRule username(String field, String value, String message) {
  return FieldRule(field, () {
    final v = value.trim();

    final regex = RegExp(r'^[a-zA-Z0-9._-]{3,20}$');
    return regex.hasMatch(v) ? null : message;
  });
}

static FieldRule strongPassword(String field, String value, String message) {
  return FieldRule(field, () {
    final v = value;

    final hasMin = v.length >= 8;
    final hasUpper = RegExp(r'[A-Z]').hasMatch(v);
    final hasLower = RegExp(r'[a-z]').hasMatch(v);
    final hasDigit = RegExp(r'\d').hasMatch(v);

    return (hasMin && hasUpper && hasLower && hasDigit) ? null : message;
  });
}

}

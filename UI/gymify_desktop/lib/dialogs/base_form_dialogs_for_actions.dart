import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/base_dialogs_frame.dart';
import 'package:gymify_desktop/helper/text_editing_controller_helper.dart';


enum BaseFieldType {
  text,
  number,
  email,
  phone,
  date,
  dropdown,
  password,
  userSearch,
  trainerPick,
}

class BaseFormFieldDef {
  final String name;
  final String label;
  final BaseFieldType type;
  final bool requiredField;

  final List<DropdownMenuItem<String>>? items;
  final String? Function(String?)? validator;
  final String? Function(String? value, Map<String, dynamic> values)?
      crossValidator;

  final bool? readOnly;
  final bool? enabled;

  final void Function(
    Map<String, dynamic> values,
    void Function(String field, dynamic value) setValue,
  )?
  onTap;

  const BaseFormFieldDef({
    required this.name,
    required this.label,
    this.type = BaseFieldType.text,
    this.requiredField = false,
    this.items,
    this.validator,
    this.crossValidator,
    this.readOnly,
    this.enabled,
    this.onTap,
  });
}

Future<void> showBaseFormDialog({
  required BuildContext context,
  required String title,
  required List<BaseFormFieldDef> fieldsDef,
  required Future<void> Function(Map<String, dynamic> payload) onSubmit,
  Map<String, dynamic>? initialValues,
  void Function(
    String changedField,
    Map<String, dynamic> values,
    void Function(String field, dynamic value) setValue,
  )?
  onFieldChanged,
  double width = 560,
  double? height,
}) async {
  final formKey = GlobalKey<FormState>();
  final fields = Fields.fromNames(fieldsDef.map((e) => e.name).toList());
  final scrollController = ScrollController();

  final values = <String, dynamic>{};
  final manuallyEditedFields = <String>{};

  bool isFormValid = false;
  bool didRunInitialValidation = false;

  for (final f in fieldsDef) {
    final v = initialValues != null ? initialValues[f.name] : null;
    values[f.name] = v ?? "";
    if (v != null) {
      fields.setText(f.name, v.toString());
    }
  }

  values.putIfAbsent("userId", () => "");
  values.putIfAbsent("trainerId", () => "");

  final obscure = <String, bool>{};
  for (final f in fieldsDef) {
    if (f.type == BaseFieldType.password) {
      obscure[f.name] = true;
    }
  }

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => StatefulBuilder(
      builder: (ctx, setStateDialog) {
        void setValueInternal(String name, dynamic value) {
          values[name] = value ?? "";
          fields.setText(name, (value ?? "").toString());
        }

        void setValue(String name, dynamic value) {
          setValueInternal(name, value);
          setStateDialog(() {});
        }

        void notifyChanged(String fieldName) {
          values[fieldName] = fields.text(fieldName);

          // 👇 ako je user mijenjao field → zapamti
          manuallyEditedFields.add(fieldName);

          if (onFieldChanged != null) {
            onFieldChanged(
              fieldName,
              Map<String, dynamic>.from(values),
              (k, v) => setValueInternal(k, v), // ⚠️ BITNO
            );
          }
        }

        Future<void> submit() async {
          final ok = formKey.currentState?.validate() ?? false;
          setStateDialog(() => isFormValid = ok);
          if (!ok) return;

          final payload = Map<String, dynamic>.from(values);

          for (final f in fieldsDef) {
            payload[f.name] = fields.text(f.name).trim();
          }

          await onSubmit(payload);

          if (ctx.mounted) Navigator.pop(ctx);
        }

        void validateForm() {
          final valid = formKey.currentState?.validate() ?? false;
          setStateDialog(() => isFormValid = valid);
        }

        String? defaultRequiredValidator(BaseFormFieldDef def, String? v) {
          if (def.requiredField && (v == null || v.trim().isEmpty)) {
            return "${def.label} je obavezno.";
          }
          return null;
        }

        String? composedValidator(BaseFormFieldDef def, String? v) {
          final baseError =
              (def.validator ?? (value) => defaultRequiredValidator(def, value))
                  .call(v);

          if (baseError != null) return baseError;

          if (def.crossValidator != null) {
            return def.crossValidator!(v, Map<String, dynamic>.from(values));
          }

          return null;
        }

        Widget buildField(BaseFormFieldDef def) {
  final isEnabled = def.enabled ?? true;
  final isReadOnly = def.readOnly ?? false;

  switch (def.type) {
    case BaseFieldType.dropdown:
      final currentValue = fields.text(def.name).trim();
      final dropdownItems = def.items ?? [];

      final hasMatchingValue = dropdownItems.any(
        (item) => item.value == currentValue,
      );

      return DropdownButtonFormField<String>(
        isExpanded: true,
        value: currentValue.isEmpty
            ? null
            : (hasMatchingValue ? currentValue : null),
        items: dropdownItems,
        onChanged: isEnabled
            ? (v) {
                fields.setText(def.name, v ?? "");
                values[def.name] = v ?? "";

                if (onFieldChanged != null) {
                  onFieldChanged(
                    def.name,
                    Map<String, dynamic>.from(values),
                    (k, vv) => setValueInternal(k, vv),
                  );
                }

                setStateDialog(() {});
                validateForm();
              }
            : null,
        validator: (v) => composedValidator(def, v),
        decoration: InputDecoration(
          labelText: def.label,
          filled: true,
          fillColor: const Color(0xFFF7F7F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    case BaseFieldType.date:
  return TextFormField(
    controller: fields.controller(def.name),
    readOnly: true,
    enabled: isEnabled,
    validator: (v) => composedValidator(def, v),
    decoration: InputDecoration(
      labelText: def.label,
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      suffixIcon: const Icon(Icons.calendar_month_outlined),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onTap: () async {
      if (!isEnabled) return;

      final now = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

      if (picked == null) return;

      final text =
          "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";

      fields.setText(def.name, text);
      values[def.name] = text;

      if (onFieldChanged != null) {
        onFieldChanged(
          def.name,
          Map<String, dynamic>.from(values),
          (k, v) => setValueInternal(k, v),
        );
      }

      setStateDialog(() {});
      validateForm();
    },
  );

    default:
      return TextFormField(
        controller: fields.controller(def.name),
        enabled: isEnabled,
        readOnly: isReadOnly,
        validator: (v) => composedValidator(def, v),
        onChanged: (_) {
          notifyChanged(def.name);
          validateForm();
        },
        decoration: InputDecoration(
          labelText: def.label,
          filled: true,
          fillColor: const Color(0xFFF7F7F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}

        if (!didRunInitialValidation) {
          didRunInitialValidation = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!ctx.mounted) return;
            validateForm();
          });
        }

        return BaseDialog(
          title: title,
          width: width,
          height: height,
          onClose: () => Navigator.pop(ctx),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  ...fieldsDef.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: buildField(f),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Odustani"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: isFormValid ? submit : null,
                        child: const Text("Sačuvaj"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );

  fields.dispose();
  scrollController.dispose();
}
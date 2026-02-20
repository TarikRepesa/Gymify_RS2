import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/base_dialogs_frame.dart';
import 'package:gymify_desktop/dialogs/user_picker_dialog.dart';
import 'package:gymify_desktop/helper/text_editing_controller_helper.dart';
import 'package:gymify_desktop/providers/user_provider.dart';
import 'package:gymify_desktop/widgets/member_widget.dart';
import 'package:gymify_desktop/widgets/training_widget.dart' hide showUserPickDialog;
import 'package:provider/provider.dart';

enum BaseFieldType {
  text,
  number,
  email,
  phone,
  date,
  dropdown,
  password,
  userSearch,
  trainerPick
}

class BaseFormFieldDef {
  final String name;
  final String label;
  final BaseFieldType type;
  final bool requiredField;

  final List<DropdownMenuItem<String>>? items;
  final String? Function(String?)? validator;

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

  // inicijalno popunjavanje
  final values = <String, dynamic>{};
  for (final f in fieldsDef) {
    final v = initialValues != null ? initialValues[f.name] : null;
    values[f.name] = v ?? "";
    if (v != null) {
      fields.setText(f.name, v.toString());
    }
  }

  if (initialValues != null) {
  if (initialValues.containsKey("userId")) {
    values["userId"] = initialValues["userId"];
  }

  if (initialValues.containsKey("trainerId")) {
    values["trainerId"] = initialValues["trainerId"];
  }
}

  values.putIfAbsent("userId", () => "");
  values.putIfAbsent("trainerId", () => "");

  void setValue(StateSetter setStateDialog, String name, dynamic value) {
    values[name] = value ?? "";
    fields.setText(name, (value ?? "").toString());
    setStateDialog(() {});
  }

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
        Future<void> submit() async {
          final ok = formKey.currentState?.validate() ?? false;
          if (!ok) return;

          final payload = Map<String, dynamic>.from(values);
          for (final f in fieldsDef) {
            payload[f.name] = fields.text(f.name).trim();
          }

          payload["trainerId"] = values["trainerId"];
          payload["userId"] = values["userId"];


          await onSubmit(payload);
          if (ctx.mounted) Navigator.pop(ctx);
        }

        Widget buildField(BaseFormFieldDef def) {
          final isEnabled = def.enabled ?? true;
          final isReadOnly = def.readOnly ?? false;

          String? defaultRequiredValidator(String? v) {
            if (def.requiredField && (v == null || v.trim().isEmpty)) {
              return "${def.label} je obavezno.";
            }
            return null;
          }

          final validator = def.validator ?? defaultRequiredValidator;

          void notifyChanged(String fieldName) {
            values[fieldName] = fields.text(fieldName);
            if (onFieldChanged != null) {
              onFieldChanged(
                fieldName,
                Map<String, dynamic>.from(values),
                (k, v) => setValue(setStateDialog, k, v),
              );
            }
          }

          switch (def.type) {
            case BaseFieldType.trainerPick:
  final canPick = def.enabled ?? true;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: TextFormField(
          controller: fields.controller(def.name),
          enabled: false,
          readOnly: true,
          validator: validator,
          decoration: InputDecoration(
            labelText: def.label,
            hintText: "Klikni 'Dodaj trenera' za odabir",
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      ElevatedButton(
        onPressed: canPick
            ? () async {
                // ✅ OVDJE biraš trenera
                final picked = await showTrainerPickDialog(context: context);
                if (picked == null) return;

                final display =
                    "${picked.firstName ?? ""} ${picked.lastName ?? ""}".trim();

                // prikaz u formi
                fields.setText(def.name, display);
                values[def.name] = display;

                // ✅ pravi ID koji šalješ na backend
                values["trainerId"] = picked.id;

                setStateDialog(() {});
              }
            : null,
        child: const Text("Dodaj trenera"),
      ),
    ],
  );

            case BaseFieldType.dropdown:
              return DropdownButtonFormField<String>(
                value: fields.text(def.name).isEmpty
                    ? null
                    : fields.text(def.name),
                items: def.items ?? const [],
                onChanged: isEnabled
                    ? (v) {
                        fields.setText(def.name, v ?? "");
                        values[def.name] = v ?? "";
                        if (onFieldChanged != null) {
                          onFieldChanged(
                            def.name,
                            Map<String, dynamic>.from(values),
                            (k, vv) => setValue(setStateDialog, k, vv),
                          );
                        }
                        setStateDialog(() {});
                      }
                    : null,
                validator: validator,
                decoration: InputDecoration(
                  labelText: def.label,
                  filled: true,
                  fillColor: const Color(0xFFF7F7F7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );

            case BaseFieldType.userSearch:
              final canPick = def.enabled ?? true;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: fields.controller(def.name),
                      enabled: false,
                      readOnly: true,
                      validator: validator,
                      decoration: InputDecoration(
                        labelText: def.label,
                        hintText: "Klikni 'Dodaj korisnika' za odabir",
                        filled: true,
                        fillColor: const Color(0xFFF7F7F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: canPick
                        ? () async {
                            final picked = await showUserPickDialog(
                              context: context,
                            );
                            if (picked == null) return;

                            final display =
                                "${picked.firstName ?? ""} ${picked.lastName ?? ""}"
                                    .trim();

                            fields.setText(def.name, display);
                            values[def.name] = display;

                            values["userId"] = picked.id; // ✅ int

                            setStateDialog(() {});
                          }
                        : null,
                    child: const Text("Dodaj korisnika"),
                  ),
                ],
              );

            case BaseFieldType.date:
              return TextFormField(
                controller: fields.controller(def.name),
                readOnly: true,
                enabled: isEnabled,
                validator: validator,
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
                      (k, v) => setValue(setStateDialog, k, v),
                    );
                  }
                  setStateDialog(() {});
                },
              );

            case BaseFieldType.password:
              final isObscure = obscure[def.name] ?? true;

              return TextFormField(
                controller: fields.controller(def.name),
                enabled: isEnabled,
                readOnly: isReadOnly,
                validator: validator,
                obscureText: isObscure,
                onChanged: (_) => notifyChanged(def.name),
                decoration: InputDecoration(
                  labelText: def.label,
                  filled: true,
                  fillColor: const Color(0xFFF7F7F7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      obscure[def.name] = !(obscure[def.name] ?? true);
                      setStateDialog(() {});
                    },
                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              );

            default:
              TextInputType keyboard;
              switch (def.type) {
                case BaseFieldType.email:
                  keyboard = TextInputType.emailAddress;
                  break;
                case BaseFieldType.phone:
                  keyboard = TextInputType.phone;
                  break;
                case BaseFieldType.number:
                  keyboard = TextInputType.number;
                  break;
                default:
                  keyboard = TextInputType.text;
              }

              return TextFormField(
                controller: fields.controller(def.name),
                keyboardType: keyboard,
                enabled: isEnabled,
                readOnly: isReadOnly,
                validator: validator,
                onChanged: (_) => notifyChanged(def.name),
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

        return BaseDialog(
          title: title,
          width: width,
          height: height,
          onClose: () => Navigator.pop(ctx),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height ?? MediaQuery.of(ctx).size.height * 0.8,
            ),
            child: PrimaryScrollController(
              controller: scrollController,
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true, // može sad bez errora
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(right: 8),
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...fieldsDef.map(
                          (f) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: buildField(f),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text("Odustani"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF387EFF),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                    ),
                  ),
                ),
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

import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/base_form_dialogs_for_actions.dart';
import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/helper/password_helper.dart';
import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/models/user.dart';
import 'package:gymify_desktop/providers/user_provider.dart';
import 'package:gymify_desktop/providers/work_task_provider.dart';
import 'package:gymify_desktop/providers/training_provider.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_widget.dart';
import 'package:provider/provider.dart';

// koristi tvoj UniversalPagingProvider iz starog projekta
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';

Widget StaffWidget() {
  return ChangeNotifierProvider<UniversalPagingProvider<User>>(
    create: (context) {
      final provider = UniversalPagingProvider<User>(
        pageSize: 5,
        fetcher: ({
          required int page,
          required int pageSize,
          String? filter,
          bool includeTotalCount = true,
        }) {
          return context.read<UserProvider>().getStaffPaged(
                page: page,
                pageSize: pageSize,
                search: filter,
                includeTotalCount: includeTotalCount,
              );
        },
      );

      // auto-load prvu stranicu
      Future.microtask(() => provider.loadPage());
      return provider;
    },
    child: Consumer<UniversalPagingProvider<User>>(
      builder: (context, paging, _) {
        return BaseSearchAndTable<User>(
          title: "Osoblje",
          addButtonText: "Dodaj osoblje",
          onAdd: () async {
            final generatedPass = CredentialHelper.generatePassword();

            await showBaseFormDialog(
              context: context,
              title: "Dodaj osoblje",
              initialValues: {"password": generatedPass, "username": ""},
              fieldsDef: [
                const BaseFormFieldDef(
                  name: "firstName",
                  label: "Ime",
                  requiredField: true,
                ),
                const BaseFormFieldDef(
                  name: "lastName",
                  label: "Prezime",
                  requiredField: true,
                ),
                BaseFormFieldDef(
                  name: "username",
                  label: "Username",
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();

                    if (value.isEmpty) {
                      return "Username je obavezan.";
                    }

                    final regex = RegExp(r'^[a-zA-Z0-9._#-]{3,30}$');
                    if (!regex.hasMatch(value)) {
                      return "Username mora imati 3–30 znakova (slova, brojevi, . _ - #).";
                    }

                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "password",
                  label: "Password",
                  type: BaseFieldType.password,
                  requiredField: true,
                  validator: (v) {
                    final value = v ?? "";

                    if (value.trim().isEmpty) {
                      return "Password je obavezan.";
                    }

                    final hasMinLength = value.length >= 8;
                    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
                    final hasLower = RegExp(r'[a-z]').hasMatch(value);
                    final hasDigit = RegExp(r'\d').hasMatch(value);

                    if (!hasMinLength || !hasUpper || !hasLower || !hasDigit) {
                      return "Min 8 znakova + veliko slovo + malo slovo + broj.";
                    }

                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "role",
                  label: "Uloga",
                  type: BaseFieldType.dropdown,
                  requiredField: true,
                  items: const [
                    DropdownMenuItem(value: "Trener", child: Text("Trener")),
                    DropdownMenuItem(value: "Radnik", child: Text("Radnik")),
                  ],
                ),
                const BaseFormFieldDef(
                  name: "email",
                  label: "Email",
                  type: BaseFieldType.email,
                  requiredField: true,
                ),
                BaseFormFieldDef(
                  name: "dateOfBirth",
                  label: "Datum rodjenja",
                  type: BaseFieldType.date,
                  requiredField: true,
                ),
                const BaseFormFieldDef(
                  name: "phone",
                  label: "Kontakt",
                  type: BaseFieldType.phone,
                  requiredField: true,
                ),
              ],
              onFieldChanged: (name, values, setValue) {
                if (name == "firstName" || name == "lastName") {
                  final fn = (values["firstName"] ?? "").toString();
                  final ln = (values["lastName"] ?? "").toString();

                  if (fn.trim().isEmpty || ln.trim().isEmpty) return;

                  final auto = CredentialHelper.generateUsername(
                    firstName: fn,
                    lastName: ln,
                    special: "#",
                  );

                  final currentU = (values["username"] ?? "").toString();
                  if (currentU.trim().isEmpty) {
                    setValue("username", auto);
                  }
                }
              },
              onSubmit: (payload) async {
                try {
                  await context.read<UserProvider>().insert({
                    "firstName": payload["firstName"],
                    "lastName": payload["lastName"],
                    "email": payload["email"],
                    "phoneNumber": payload["phone"],
                    "dateOfBirth": DateHelper.toIsoFromUi(payload["dateOfBirth"]),
                    "username": payload["username"],
                    "isActive": true,
                    "createdAt": DateTime.now().toIso8601String(),
                    "password": payload["password"],
                    "isAdmin": false,
                    "isTrener": payload["role"] == "Trener",
                    "isRadnik": payload["role"] == "Radnik",
                  });

                  await paging.loadPage();

                  SnackbarHelper.showSuccess(
                    context,
                    "Osoblje uspješno dodano.",
                  );
                } catch (e) {
                  SnackbarHelper.showError(context, e.toString());
                  rethrow; // da dialog ne zatvori ako ima greška
                }
              },
            );
          },
          onSearchChanged: (value) => paging.search(value),
          onClearSearch: () => paging.search(""),
          isLoading: paging.isLoading,
          items: paging.items,
          columns: [
            BaseColumn<User>(
              title: "Ime i prezime",
              flex: 3,
              cell: (u) => Text("${u.firstName} ${u.lastName}".trim()),
            ),
            BaseColumn<User>(
              title: "Uloga",
              flex: 2,
              cell: (u) {
                if (u.isTrener == true) return const Text("Trener");
                if (u.isRadnik == true) return const Text("Radnik");
                return const Text("Nepoznato");
              },
            ),
            BaseColumn<User>(
              title: "Email",
              flex: 3,
              cell: (u) => Text(u.email ?? ""),
            ),
            BaseColumn<User>(
              title: "Kontakt",
              flex: 2,
              cell: (u) => Text(
                u.phoneNumber ?? "",
                style: const TextStyle(decoration: TextDecoration.underline),
              ),
            ),

            // ✅ NOVO: AKCIJA
            BaseColumn<User>(
              title: "Akcija",
              flex: 2,
              cell: (u) {
                final isTrainer = u.isTrener == true;
                final isWorker = u.isRadnik == true;

                if (!isTrainer && !isWorker) return const SizedBox.shrink();

                return Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      isTrainer ? Icons.fitness_center : Icons.task_alt,
                      size: 18,
                    ),
                    label: Text(isTrainer ? "Dodaj trening" : "Dodaj zadatak"),
                    onPressed: () async {
                      if (isTrainer) {
                        await _openAddTrainingDialog(context, u);
                      } else {
                        await _openAddWorkerTaskDialog(context, u);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isTrainer
                          ? const Color(0xFF0D47A1)
                          : const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
          onEdit: (u) async {
            await showBaseFormDialog(
              context: context,
              title: "Uredi osoblje",
              initialValues: {
                "firstName": u.firstName ?? "",
                "lastName": u.lastName ?? "",
                "username": u.username ?? "",
                "email": u.email ?? "",
                "phone": u.phoneNumber ?? "",
                "dateOfBirth": DateHelper.formatNullable(u.dateOfBirth),
                "role": (u.isTrener == true)
                    ? "Trener"
                    : (u.isRadnik == true)
                        ? "Radnik"
                        : "",
              },
              fieldsDef: [
                const BaseFormFieldDef(
                  name: "firstName",
                  label: "Ime",
                  requiredField: true,
                ),
                const BaseFormFieldDef(
                  name: "lastName",
                  label: "Prezime",
                  requiredField: true,
                ),
                BaseFormFieldDef(
                  name: "username",
                  label: "Username",
                  requiredField: true,
                  validator: (v) {
                    if ((v ?? "").trim().isEmpty) {
                      return "Username je obavezan.";
                    }
                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "role",
                  label: "Uloga",
                  type: BaseFieldType.dropdown,
                  requiredField: true,
                  items: const [
                    DropdownMenuItem(value: "Trener", child: Text("Trener")),
                    DropdownMenuItem(value: "Radnik", child: Text("Radnik")),
                  ],
                ),
                const BaseFormFieldDef(
                  name: "email",
                  label: "Email",
                  type: BaseFieldType.email,
                  requiredField: true,
                ),
                BaseFormFieldDef(
                  name: "dateOfBirth",
                  label: "Datum rodjenja",
                  type: BaseFieldType.date,
                  requiredField: true,
                ),
                const BaseFormFieldDef(
                  name: "phone",
                  label: "Kontakt",
                  type: BaseFieldType.phone,
                  requiredField: true,
                ),
              ],
              onSubmit: (payload) async {
                try {
                  await context.read<UserProvider>().update(u.id!, {
                    "firstName": payload["firstName"],
                    "lastName": payload["lastName"],
                    "email": payload["email"],
                    "phoneNumber": payload["phone"],
                    "dateOfBirth": DateHelper.toIsoFromUi(payload["dateOfBirth"]),
                    "username": payload["username"],
                    "isTrener": payload["role"] == "Trener",
                    "isRadnik": payload["role"] == "Radnik",
                  });

                  await paging.loadPage();

                  SnackbarHelper.showUpdate(
                    context,
                    "Podaci uspješno ažurirani.",
                  );
                } catch (e) {
                  SnackbarHelper.showError(context, e.toString());
                  rethrow;
                }
              },
            );
          },
          onDelete: (u) async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text("Brisanje osoblja"),
                content: Text(
                  "Jesi li siguran da želiš obrisati ${u.firstName} ${u.lastName}?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(c, false),
                    child: const Text("Odustani"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(c, true),
                    child: const Text("Obriši"),
                  ),
                ],
              ),
            );

            if (ok != true) return;

            await context.read<UserProvider>().delete(u.id!);
            await paging.loadPage();
          },
          footer: _pagingControls(paging),
        );
      },
    ),
  );
}

Widget _pagingControls(UniversalPagingProvider<User> paging) {
  final totalPages =
      (paging.totalCount + paging.pageSize - 1) ~/ paging.pageSize;

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      IconButton(
        onPressed: paging.hasPreviousPage ? () => paging.previousPage() : null,
        icon: const Icon(Icons.arrow_back),
      ),
      Text(
        totalPages == 0 ? "0 / 0" : "${paging.page + 1} / $totalPages",
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      IconButton(
        onPressed: paging.hasNextPage ? () => paging.nextPage() : null,
        icon: const Icon(Icons.arrow_forward),
      ),
    ],
  );
}

// =============================
// DIALOG: DODAJ TRENING (TRENER)
// =============================
Future<void> _openAddTrainingDialog(BuildContext context, User trainer) async {
  await showBaseFormDialog(
    context: context,
    title: "Dodaj trening",
    initialValues: {
      "trainer": "${trainer.firstName ?? ""} ${trainer.lastName ?? ""}".trim(),
      "trainerId": trainer.id,
      "name": "",
      "maxAmountOfParticipants": "15",
      "currentParticipants": "0",
      "startDate": "",
      "trainingImage": "https://picsum.photos/seed/training/600/400",
    },
    fieldsDef: const [
      BaseFormFieldDef(
        name: "trainer",
        label: "Trener",
        requiredField: true,
        readOnly: true,
        enabled: false,
      ),
      BaseFormFieldDef(
        name: "name",
        label: "Naziv treninga",
        requiredField: true,
      ),
      BaseFormFieldDef(
        name: "maxAmountOfParticipants",
        label: "Max broj učesnika",
        type: BaseFieldType.number,
        requiredField: true,
      ),
      BaseFormFieldDef(
        name: "currentParticipants",
        label: "Trenutni učesnici",
        type: BaseFieldType.number,
        requiredField: true,
      ),
      BaseFormFieldDef(
        name: "startDate",
        label: "Datum početka",
        type: BaseFieldType.date,
        requiredField: true,
      ),
    ],
    onSubmit: (payload) async {
      try {
        await context.read<TrainingProvider>().insert({
          "userId": payload["trainerId"],
          "name": payload["name"],
          "maxAmountOfParticipants": int.parse(payload["maxAmountOfParticipants"]),
          "currentParticipants": int.parse(payload["currentParticipants"]),
          "startDate": DateHelper.toIsoFromUi(payload["startDate"]),
          "paricipatedOfAllTime": 0,
        });

        SnackbarHelper.showSuccess(context, "Trening uspješno dodan.");
      } catch (e) {
        SnackbarHelper.showError(context, e.toString());
        rethrow;
      }
    },
  );
}

// =============================
// DIALOG: DODAJ ZADATAK (RADNIK)
// =============================
Future<void> _openAddWorkerTaskDialog(BuildContext context, User worker) async {
  await showBaseFormDialog(
    context: context,
    title: "Dodaj zadatak",
    initialValues: {
      "worker": "${worker.firstName ?? ""} ${worker.lastName ?? ""}".trim(),
      "userId": worker.id,
      "name": "",
      "details": "",
      "createdTaskDate": DateHelper.format(DateTime.now()),
      "exparationTaskDate": "",
    },
    fieldsDef: const [
      BaseFormFieldDef(
        name: "worker",
        label: "Radnik",
        requiredField: true,
        readOnly: true,
        enabled: false,
      ),
      BaseFormFieldDef(
        name: "name",
        label: "Naziv zadatka",
        requiredField: true,
      ),
      BaseFormFieldDef(
        name: "details",
        label: "Detalji",
        requiredField: true,
      ),
      BaseFormFieldDef(
        name: "createdTaskDate",
        label: "Datum kreiranja",
        type: BaseFieldType.date,
        requiredField: true,
        readOnly: true,
        enabled: false,
      ),
      BaseFormFieldDef(
        name: "exparationTaskDate",
        label: "Rok izvršenja",
        type: BaseFieldType.date,
        requiredField: true,
      ),
    ],
    onSubmit: (payload) async {
      try {
        await context.read<WorkerTaskProvider>().insert({
          "userId": payload["userId"],
          "name": payload["name"],
          "details": payload["details"],
          "createdTaskDate": DateHelper.toIsoFromUi(payload["createdTaskDate"]),
          "exparationTaskDate": DateHelper.toIsoFromUi(payload["exparationTaskDate"]),
          "isFinished": false,
        });

        SnackbarHelper.showSuccess(context, "Zadatak uspješno dodan.");
      } catch (e) {
        SnackbarHelper.showError(context, e.toString());
        rethrow;
      }
    },
  );
}
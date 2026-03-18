import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/base_form_dialogs_for_actions.dart';
import 'package:gymify_desktop/dialogs/confirmation_dialogs.dart';
import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/helper/password_helper.dart';
import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';
import 'package:gymify_desktop/models/user.dart';
import 'package:gymify_desktop/providers/user_provider.dart';
import 'package:gymify_desktop/providers/work_task_provider.dart';
import 'package:gymify_desktop/validation/validation_model/validation_rules.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_widget.dart';
import 'package:provider/provider.dart';

Widget StaffWidget() {
  return ChangeNotifierProvider<UniversalPagingProvider<User>>(
    create: (context) {
      final provider = UniversalPagingProvider<User>(
        pageSize: 5,
        fetcher:
            ({
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
              initialValues: {
                "password": generatedPass,
                "username": "",
                "role": "",
              },
              fieldsDef: [
                BaseFormFieldDef(
                  name: "firstName",
                  label: "Ime",
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();

                    if (value.isEmpty) {
                      return "Ime je obavezno.";
                    }

                    return Rules.minLength(
                      "firstName",
                      value,
                      2,
                      "Ime mora imati najmanje 2 znaka.",
                    ).validate();
                  },
                ),
                BaseFormFieldDef(
                  name: "lastName",
                  label: "Prezime",
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();

                    if (value.isEmpty) {
                      return "Prezime je obavezno.";
                    }

                    return Rules.minLength(
                      "lastName",
                      value,
                      2,
                      "Prezime mora imati najmanje 2 znaka.",
                    ).validate();
                  },
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

                    return Rules.username("username", value).validate();
                  },
                ),
                BaseFormFieldDef(
                  name: "password",
                  label: "Password",
                  type: BaseFieldType.password,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();

                    if (value.isEmpty) {
                      return "Password je obavezan.";
                    }

                    return Rules.strongPassword("password", value).validate();
                  },
                ),
                BaseFormFieldDef(
                  name: "role",
                  label: "Uloga",
                  type: BaseFieldType.dropdown,
                  requiredField: true,
                  items: const [
                    DropdownMenuItem<String>(
                      value: "Trener",
                      child: Text("Trener"),
                    ),
                    DropdownMenuItem<String>(
                      value: "Radnik",
                      child: Text("Radnik"),
                    ),
                  ],
                  validator: (v) {
                    final value = (v ?? "").toString().trim();

                    if (value.isEmpty) {
                      return "Uloga je obavezna.";
                    }

                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "email",
                  label: "Email",
                  type: BaseFieldType.email,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();

                    if (value.isEmpty) {
                      return "Email je obavezan.";
                    }

                    return Rules.email(
                      "email",
                      value,
                      "Unesite ispravan email.",
                    ).validate();
                  },
                ),
                BaseFormFieldDef(
                  name: "dateOfBirth",
                  label: "Datum rodjenja",
                  type: BaseFieldType.date,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").toString().trim();

                    if (value.isEmpty) {
                      return "Datum rodjenja je obavezan.";
                    }

                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "phone",
                  label: "Kontakt",
                  type: BaseFieldType.phone,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();

                    if (value.isEmpty) {
                      return "Kontakt je obavezan.";
                    }

                    return Rules.phone(
                      "phone",
                      value,
                      required: true,
                    ).validate();
                  },
                ),
              ],
              onFieldChanged: (name, values, setValue) {
  // 🔒 reaguj SAMO na ime i prezime
  if (name != "firstName" && name != "lastName") return;

  final fn = (values["firstName"] ?? "").toString().trim();
  final ln = (values["lastName"] ?? "").toString().trim();
  final username = (values["username"] ?? "").toString().trim();

  // ❌ ako user ručno dira username → ne diraj
  if (name == "username") return;

  // 🔴 ako fali ime ili prezime → reset
  if (fn.isEmpty || ln.isEmpty) {
    setValue("username", "");
    return;
  }

  // 🟢 generiši SAMO ako je username prazan
  if (username.isEmpty) {
    final generated = CredentialHelper.generateUsername(
      firstName: fn,
      lastName: ln,
      special: "#",
    );

    setValue("username", generated);
  }
},
              onSubmit: (payload) async {
                try {
                  await context.read<UserProvider>().insert({
                    "firstName": payload["firstName"],
                    "lastName": payload["lastName"],
                    "email": payload["email"],
                    "phoneNumber": payload["phone"],
                    "dateOfBirth": DateHelper.toIsoFromUi(
                      payload["dateOfBirth"],
                    ),
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
                  rethrow;
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
            BaseColumn<User>(
              title: "Akcija",
              flex: 2,
              cell: (u) {
                final isWorker = u.isRadnik == true;

                if (!isWorker) {
                  return const SizedBox.shrink();
                }

                return Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.task_alt, size: 18),
                    label: const Text("Dodaj zadatak"),
                    onPressed: () async {
                      await _openAddWorkerTaskDialog(context, u);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
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
                "role": u.isTrener == true
                    ? "Trener"
                    : u.isRadnik == true
                    ? "Radnik"
                    : "",
              },
              fieldsDef: [
                BaseFormFieldDef(
                  name: "firstName",
                  label: "Ime",
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();

                    if (value.isEmpty) {
                      return "Ime je obavezno.";
                    }

                    return Rules.minLength(
                      "firstName",
                      value,
                      2,
                      "Ime mora imati najmanje 2 znaka.",
                    ).validate();
                  },
                ),
                BaseFormFieldDef(
                  name: "lastName",
                  label: "Prezime",
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();

                    if (value.isEmpty) {
                      return "Prezime je obavezno.";
                    }

                    return Rules.minLength(
                      "lastName",
                      value,
                      2,
                      "Prezime mora imati najmanje 2 znaka.",
                    ).validate();
                  },
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

                    return Rules.username("username", value).validate();
                  },
                ),
                BaseFormFieldDef(
                  name: "role",
                  label: "Uloga",
                  type: BaseFieldType.dropdown,
                  requiredField: true,
                  items: const [
                    DropdownMenuItem<String>(
                      value: "Trener",
                      child: Text("Trener"),
                    ),
                    DropdownMenuItem<String>(
                      value: "Radnik",
                      child: Text("Radnik"),
                    ),
                  ],
                  validator: (v) {
                    final value = (v ?? "").toString().trim();

                    if (value.isEmpty) {
                      return "Uloga je obavezna.";
                    }

                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "email",
                  label: "Email",
                  type: BaseFieldType.email,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();

                    if (value.isEmpty) {
                      return "Email je obavezan.";
                    }

                    return Rules.email(
                      "email",
                      value,
                      "Unesite ispravan email.",
                    ).validate();
                  },
                ),
                BaseFormFieldDef(
                  name: "dateOfBirth",
                  label: "Datum rodjenja",
                  type: BaseFieldType.date,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").toString().trim();

                    if (value.isEmpty) {
                      return "Datum rodjenja je obavezan.";
                    }

                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "phone",
                  label: "Kontakt",
                  type: BaseFieldType.phone,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();

                    if (value.isEmpty) {
                      return "Kontakt je obavezan.";
                    }

                    return Rules.phone(
                      "phone",
                      value,
                      required: true,
                    ).validate();
                  },
                ),
              ],
              onSubmit: (payload) async {
                try {
                  await context.read<UserProvider>().update(u.id!, {
                    "firstName": payload["firstName"],
                    "lastName": payload["lastName"],
                    "email": payload["email"],
                    "phoneNumber": payload["phone"],
                    "dateOfBirth": DateHelper.toIsoFromUi(
                      payload["dateOfBirth"],
                    ),
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
            final ok = await ConfirmDialogs.badGoodConfirmation(
              context,
              title: "Brisanje osoblja",
              question:
                  "Jesi li siguran da želiš obrisati ${u.firstName} ${u.lastName}?",
              goodText: "Obriši",
              badText: "Odustani",
            );

            if (ok != true) return;

            try {
              await context.read<UserProvider>().delete(u.id!);
              await paging.loadPage();

              SnackbarHelper.showDelete(context, "Osoblje uspješno obrisano.");
            } catch (e) {
              SnackbarHelper.showError(context, e.toString());
            }
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
      "expirationTaskDate": "",
    },
    fieldsDef: [
      const BaseFormFieldDef(
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
        validator: (v) {
          final value = (v ?? "").trim();

          if (value.isEmpty) {
            return "Naziv zadatka je obavezan.";
          }

          return Rules.minLength(
            "name",
            value,
            3,
            "Naziv zadatka mora imati najmanje 3 znaka.",
          ).validate();
        },
      ),
      BaseFormFieldDef(
        name: "details",
        label: "Detalji",
        requiredField: true,
        validator: (v) {
          final value = (v ?? "").trim();

          if (value.isEmpty) {
            return "Detalji su obavezni.";
          }

          return Rules.minLength(
            "details",
            value,
            5,
            "Detalji moraju imati najmanje 5 znakova.",
          ).validate();
        },
      ),
      const BaseFormFieldDef(
        name: "createdTaskDate",
        label: "Datum kreiranja",
        type: BaseFieldType.date,
        requiredField: true,
        readOnly: true,
        enabled: false,
      ),
      BaseFormFieldDef(
        name: "expirationTaskDate",
        label: "Rok izvršenja",
        type: BaseFieldType.date,
        requiredField: true,
        validator: (v) {
          final value = (v ?? "").toString().trim();

          if (value.isEmpty) {
            return "Rok izvršenja je obavezan.";
          }

          final date = DateHelper.fromUi(value);

          if (date == null) {
            return "Neispravan datum.";
          }

          final now = DateTime.now();

          if (!date.isAfter(now)) {
            return "Datum mora biti u budućnosti.";
          }

          return null;
        },
      ),
    ],
    onSubmit: (payload) async {
      try {
        await context.read<WorkerTaskProvider>().insert({
          "userId": payload["userId"],
          "name": payload["name"],
          "details": payload["details"],
          "createdTaskDate": DateHelper.toIsoFromUi(payload["createdTaskDate"]),
          "expirationTaskDate": DateHelper.toIsoFromUi(
            payload["expirationTaskDate"],
          ),
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

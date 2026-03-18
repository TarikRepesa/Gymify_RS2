import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/base_form_dialogs_for_actions.dart';
import 'package:gymify_desktop/dialogs/confirmation_dialogs.dart';
import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/models/membership.dart';
import 'package:gymify_desktop/providers/membership_provider.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_widget.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';
import 'package:gymify_desktop/helper/date_helper.dart';

int _parseIntPrice(String? s) {
  return int.tryParse((s ?? "").trim()) ?? 0;
}

String _intPriceToUi(num? v) {
  return (v ?? 0).toInt().toString();
}

String _calculateYearPriceFromMonthly(String? monthlyValue) {
  final monthly = int.tryParse((monthlyValue ?? "").trim());
  if (monthly == null || monthly <= 0) return "";
  return (monthly * 12).toString();
}

Widget MembershipWidget() {
  return ChangeNotifierProvider<UniversalPagingProvider<Membership>>(
    create: (context) {
      final paging = UniversalPagingProvider<Membership>(
        pageSize: 5,
        fetcher: ({
          required int page,
          required int pageSize,
          String? filter,
          bool includeTotalCount = true,
        }) {
          return context.read<MembershipProvider>().get(
            filter: {
              "page": page,
              "pageSize": pageSize,
              "includeTotalCount": includeTotalCount,
              if (filter != null && filter.trim().isNotEmpty)
                "FTS": filter.trim(),
            },
          );
        },
      );

      Future.microtask(() => paging.loadPage());
      return paging;
    },
    child: Consumer<UniversalPagingProvider<Membership>>(
      builder: (context, paging, _) {
        return BaseSearchAndTable<Membership>(
          title: "Članarine",
          addButtonText: "Dodaj članarinu",

          onAdd: () async {
            await showBaseFormDialog(
              context: context,
              title: "Dodaj članarinu",
              initialValues: {
                "name": "",
                "monthlyPrice": "",
                "yearPrice": "",
              },
              fieldsDef: [
                BaseFormFieldDef(
                  name: "name",
                  label: "Ime članarine",
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Ime članarine je obavezno.";
                    if (value.length < 2) return "Ime članarine je prekratko.";
                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "monthlyPrice",
                  label: "Mjesečna cijena (KM)",
                  type: BaseFieldType.number,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Mjesečna cijena je obavezna.";

                    final p = int.tryParse(value);
                    if (p == null) {
                      return "Mjesečna cijena mora biti cijeli broj.";
                    }
                    if (p <= 0) {
                      return "Mjesečna cijena mora biti veća od 0.";
                    }

                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "yearPrice",
                  label: "Godišnja cijena (KM)",
                  type: BaseFieldType.number,
                  requiredField: true,
                  readOnly: true,
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Godišnja cijena je obavezna.";

                    final p = int.tryParse(value);
                    if (p == null) {
                      return "Godišnja cijena mora biti cijeli broj.";
                    }
                    if (p <= 0) {
                      return "Godišnja cijena mora biti veća od 0.";
                    }

                    return null;
                  },
                ),
              ],
              onFieldChanged: (name, values, setValue) {
                if (name == "monthlyPrice") {
                  final yearly = _calculateYearPriceFromMonthly(
                    values["monthlyPrice"]?.toString(),
                  );
                  setValue("yearPrice", yearly);
                }
              },
              onSubmit: (payload) async {
                try {
                  await context.read<MembershipProvider>().insert({
                    "name": (payload["name"] ?? "").toString().trim(),
                    "monthlyPrice": _parseIntPrice(
                      payload["monthlyPrice"]?.toString(),
                    ),
                    "yearPrice": _parseIntPrice(
                      payload["yearPrice"]?.toString(),
                    ),
                    "createdAt": DateTime.now().toIso8601String(),
                  });

                  await paging.loadPage();
                  SnackbarHelper.showSuccess(
                    context,
                    "Članarina uspješno dodana.",
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
            BaseColumn<Membership>(
              title: "Ime članarine",
              flex: 3,
              cell: (m) => Text(m.name ?? ""),
            ),
            BaseColumn<Membership>(
              title: "Mjesečna cijena",
              flex: 2,
              cell: (m) => Text("${(m.monthlyPrice ?? 0).toInt()} KM"),
            ),
            BaseColumn<Membership>(
              title: "Godišnja cijena",
              flex: 2,
              cell: (m) => Text("${(m.yearPrice ?? 0).toInt()} KM"),
            ),
            BaseColumn<Membership>(
              title: "Datum nastanka",
              flex: 2,
              cell: (m) => Text(
                m.createdAt == null || m.createdAt!.year == 1
                    ? ""
                    : DateHelper.format(m.createdAt!),
              ),
            ),
          ],

          onEdit: (m) async {
            await showBaseFormDialog(
              context: context,
              title: "Uredi članarinu",
              initialValues: {
                "name": m.name ?? "",
                "monthlyPrice": _intPriceToUi(m.monthlyPrice),
                "yearPrice": _intPriceToUi(
                  (m.monthlyPrice ?? 0).toInt() * 12,
                ),
              },
              fieldsDef: [
                BaseFormFieldDef(
                  name: "name",
                  label: "Ime članarine",
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Ime članarine je obavezno.";
                    if (value.length < 2) return "Ime članarine je prekratko.";
                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "monthlyPrice",
                  label: "Mjesečna cijena (KM)",
                  type: BaseFieldType.number,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Mjesečna cijena je obavezna.";

                    final p = int.tryParse(value);
                    if (p == null) {
                      return "Mjesečna cijena mora biti cijeli broj.";
                    }
                    if (p <= 0) {
                      return "Mjesečna cijena mora biti veća od 0.";
                    }

                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "yearPrice",
                  label: "Godišnja cijena (KM)",
                  type: BaseFieldType.number,
                  requiredField: true,
                  readOnly: true,
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Godišnja cijena je obavezna.";

                    final p = int.tryParse(value);
                    if (p == null) {
                      return "Godišnja cijena mora biti cijeli broj.";
                    }
                    if (p <= 0) {
                      return "Godišnja cijena mora biti veća od 0.";
                    }

                    return null;
                  },
                ),
              ],
              onFieldChanged: (name, values, setValue) {
                if (name == "monthlyPrice") {
                  final yearly = _calculateYearPriceFromMonthly(
                    values["monthlyPrice"]?.toString(),
                  );
                  setValue("yearPrice", yearly);
                }
              },
              onSubmit: (payload) async {
                try {
                  await context.read<MembershipProvider>().update(m.id!, {
                    "name": (payload["name"] ?? "").toString().trim(),
                    "monthlyPrice": _parseIntPrice(
                      payload["monthlyPrice"]?.toString(),
                    ),
                    "yearPrice": _parseIntPrice(
                      payload["yearPrice"]?.toString(),
                    ),
                  });

                  await paging.loadPage();
                  SnackbarHelper.showUpdate(
                    context,
                    "Članarina uspješno ažurirana.",
                  );
                } catch (e) {
                  SnackbarHelper.showError(context, e.toString());
                  rethrow;
                }
              },
            );
          },

          onDelete: (m) async {
            final ok = await ConfirmDialogs.badGoodConfirmation(
              context,
              title: "Brisanje članarine",
              question:
                  "Da li ste sigurni da želite obrisati članarinu:\n\n'${m.name ?? ""}' ?",
              badText: "Odustani",
              goodText: "Obriši",
            );

            if (!ok) return;

            try {
              await context.read<MembershipProvider>().delete(m.id!);
              await paging.loadPage();
              SnackbarHelper.showDelete(context, "Članarina obrisana.");
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

Widget _pagingControls<T>(UniversalPagingProvider<T> paging) {
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
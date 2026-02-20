import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/base_form_dialogs_for_actions.dart';
import 'package:gymify_desktop/dialogs/confirmation_dialogs.dart';
import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/models/membership.dart';
import 'package:gymify_desktop/providers/membership_provider.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_widget.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';

double _parsePrice(String? s) {
  final normalized = (s ?? "").trim().replaceAll(',', '.');
  return double.tryParse(normalized) ?? 0;
}

String _priceToUi(num? v) {
  final value = (v ?? 0).toDouble();
  // za input vrati "12.50" (tačka je OK, ti opet parsiraš i zarez/tačku)
  return value.toStringAsFixed(2);
}

Widget MembershipWidget() {
  return ChangeNotifierProvider<UniversalPagingProvider<Membership>>(
    create: (context) {
      final paging = UniversalPagingProvider<Membership>(
        pageSize: 5,
        fetcher:
            ({
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

          // ---------------- ADD ----------------
          onAdd: () async {
            await showBaseFormDialog(
              context: context,
              title: "Dodaj članarinu",
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
                    final p = _parsePrice(value);
                    if (p <= 0) return "Mjesečna cijena mora biti veća od 0.";
                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "yearPrice",
                  label: "Godišnja cijena (KM)",
                  type: BaseFieldType.number,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Godišnja cijena je obavezna.";
                    final p = _parsePrice(value);
                    if (p <= 0) return "Godišnja cijena mora biti veća od 0.";
                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "createdAt",
                  label: "Datum nastanka",
                  type: BaseFieldType.date,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Datum nastanka je obavezan.";
                    try {
                      DateHelper.toIsoFromUi(value);
                      return null;
                    } catch (_) {
                      return "Neispravan format datuma (dd.MM.yyyy).";
                    }
                  },
                ),
              ],
              onSubmit: (payload) async {
                try {
                  await context.read<MembershipProvider>().insert({
                    "name": (payload["name"] ?? "").toString().trim(),
                    "monthlyPrice": _parsePrice(
                      payload["monthlyPrice"]?.toString(),
                    ),
                    "yearPrice": _parsePrice(payload["yearPrice"]?.toString()),
                    "createdAt": DateHelper.toIsoFromUi(
                      (payload["createdAt"] ?? "").toString(),
                    ),
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
              cell: (m) =>
                  Text("${(m.monthlyPrice ?? 0).toStringAsFixed(2)} KM"),
            ),
            BaseColumn<Membership>(
              title: "Godišnja cijena",
              flex: 2,
              cell: (m) => Text("${(m.yearPrice ?? 0).toStringAsFixed(2)} KM"),
            ),
            BaseColumn<Membership>(
              title: "Datum nastanka",
              flex: 2,
              cell: (m) => Text(
                m.createdAt == null ? "" : DateHelper.format(m.createdAt!),
              ),
            ),
          ],

          // ---------------- EDIT ----------------
          onEdit: (m) async {
            await showBaseFormDialog(
              context: context,
              title: "Uredi članarinu",
              initialValues: {
                "name": m.name ?? "",
                "monthlyPrice": _priceToUi(m.monthlyPrice),
                "yearPrice": _priceToUi(m.yearPrice),
                "createdAt": DateHelper.formatNullable(m.createdAt) ?? "",
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
                    final p = _parsePrice(value);
                    if (p <= 0) return "Mjesečna cijena mora biti veća od 0.";
                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "yearPrice",
                  label: "Godišnja cijena (KM)",
                  type: BaseFieldType.number,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Godišnja cijena je obavezna.";
                    final p = _parsePrice(value);
                    if (p <= 0) return "Godišnja cijena mora biti veća od 0.";
                    return null;
                  },
                ),
                BaseFormFieldDef(
                  name: "createdAt",
                  label: "Datum nastanka",
                  type: BaseFieldType.date,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Datum nastanka je obavezan.";
                    try {
                      DateHelper.toIsoFromUi(value);
                      return null;
                    } catch (_) {
                      return "Neispravan format datuma (dd.MM.yyyy).";
                    }
                  },
                ),
              ],
              onSubmit: (payload) async {
                try {
                  await context.read<MembershipProvider>().update(m.id!, {
                    "name": (payload["name"] ?? "").toString().trim(),
                    "monthlyPrice": _parsePrice(
                      payload["monthlyPrice"]?.toString(),
                    ),
                    "yearPrice": _parsePrice(payload["yearPrice"]?.toString()),
                    "createdAt": DateHelper.toIsoFromUi(
                      (payload["createdAt"] ?? "").toString(),
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

          // ---------------- DELETE ----------------
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
              SnackbarHelper.showSuccess(context, "Članarina obrisana.");
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

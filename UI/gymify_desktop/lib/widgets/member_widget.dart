import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/base_dialogs_frame.dart';
import 'package:gymify_desktop/dialogs/base_form_dialogs_for_actions.dart';
import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/models/member.dart';
import 'package:gymify_desktop/models/user.dart';
import 'package:gymify_desktop/providers/member_provider.dart';
import 'package:gymify_desktop/providers/membership_provider.dart';
import 'package:gymify_desktop/providers/user_provider.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';

Future<bool> _memberExistsForUser({
  required BuildContext context,
  required int userId,
}) async {
  final res = await context.read<MemberProvider>().get(
    filter: {
      "userId": userId,
      "page": 0,
      "pageSize": 1,
      "includeTotalCount": false,
      "IncludeUser": true,
      "IncludeMembership": true,
    },
  );

  return res.items.isNotEmpty;
}

Future<List<DropdownMenuItem<String>>> _loadMembershipItems(
  BuildContext context,
) async {
  final res = await context.read<MembershipProvider>().get(
    filter: {"retrieveAll": true},
  );

  return res.items.map<DropdownMenuItem<String>>((m) {
    return DropdownMenuItem<String>(
      value: m.id.toString(),
      child: Text(m.name ?? ""),
    );
  }).toList();
}

int _requireInt(Map<String, dynamic> payload, String key, String message) {
  final v = int.tryParse((payload[key] ?? "").toString().trim());
  if (v == null) throw Exception(message);
  return v;
}

String _requireString(
  Map<String, dynamic> payload,
  String key,
  String message,
) {
  final v = (payload[key] ?? "").toString().trim();
  if (v.isEmpty) throw Exception(message);
  return v;
}

Future<void> _submitAddMember({
  required BuildContext context,
  required UniversalPagingProvider<Member> paging,
  required Map<String, dynamic> payload,
}) async {
  final userId = _requireInt(payload, "userId", "Nije odabran korisnik.");
  final membershipId = _requireInt(
    payload,
    "membershipId",
    "Nije odabrana članarina.",
  );
  final expiryUi = _requireString(
    payload,
    "expiryDate",
    "Datum isteka je obavezan.",
  );

  final exists = await _memberExistsForUser(context: context, userId: userId);
  if (exists) {
    SnackbarHelper.showError(
      context,
      "Korisnik već ima pretplatu. Molimo uredite postojeću članarinu.",
    );
    return;
  }

  await context.read<MemberProvider>().insert({
    "userId": userId,
    "membershipId": membershipId,
    "paymentDate": DateTime.now().toIso8601String(),
    "expirationDate": DateHelper.toIsoFromUi(expiryUi),
  });

  await paging.loadPage();
  SnackbarHelper.showSuccess(context, "Član uspješno dodan.");
}

/// 4) Submit EDIT
Future<void> _submitEditMember({
  required BuildContext context,
  required UniversalPagingProvider<Member> paging,
  required int memberId,
  required Map<String, dynamic> payload,
}) async {
  final userId = _requireInt(payload, "userId", "Nije odabran korisnik.");
  final membershipId = _requireInt(
    payload,
    "membershipId",
    "Nije odabrana članarina.",
  );
  final expiryUi = _requireString(
    payload,
    "expiryDate",
    "Datum isteka je obavezan.",
  );

  await context.read<MemberProvider>().update(memberId, {
    "userId": userId, // ✅ možeš i promijeniti usera
    "membershipId": membershipId,
    "paymentDate": DateTime.now().toIso8601String(),
    "expirationDate": DateHelper.toIsoFromUi(expiryUi),
  });

  await paging.loadPage();
  SnackbarHelper.showUpdate(context, "Član uspješno ažuriran.");
}

/// 5) Jedna funkcija koja vraća fields listu za ADD/EDIT
List<BaseFormFieldDef> _memberFields({
  required List<DropdownMenuItem<String>> membershipItems,
  bool allowUserPick = true,
}) {
  return [
    BaseFormFieldDef(
      name: "userDisplay",
      label: "Korisnik",
      type: BaseFieldType.userSearch,
      requiredField: true,
      readOnly: true,
      validator: (v) {
        final value = (v ?? "").trim();
        if (value.isEmpty) return "Korisnik je obavezan.";
        return null;
      },
    ),

    BaseFormFieldDef(
      name: "membershipId",
      label: "Članarina",
      type: BaseFieldType.dropdown,
      requiredField: true,
      items: membershipItems,
      validator: (v) =>
          (v ?? "").trim().isEmpty ? "Članarina je obavezna." : null,
    ),

    BaseFormFieldDef(
      name: "expiryDate",
      label: "Datum isteka",
      type: BaseFieldType.date,
      requiredField: true,
      validator: (v) {
        final value = (v ?? "").trim();

        if (value.isEmpty) {
          return "Datum isteka je obavezan.";
        }

        try {
          final iso = DateHelper.toIsoFromUi(value);
          final exp = DateTime.parse(iso);

          final today = DateTime.now();
          final todayOnly = DateTime(today.year, today.month, today.day);
          final expOnly = DateTime(exp.year, exp.month, exp.day);

          if (expOnly.isBefore(todayOnly)) {
            return "Datum isteka ne može biti u prošlosti.";
          }

          return null;
        } catch (_) {
          return "Neispravan format datuma (dd.MM.yyyy).";
        }
      },
    ),
  ];
}

Widget MemberWidget() {
  return ChangeNotifierProvider<UniversalPagingProvider<Member>>(
    create: (context) {
      final paging = UniversalPagingProvider<Member>(
        pageSize: 5,
        fetcher:
            ({
              required int page,
              required int pageSize,
              String? filter,
              bool includeTotalCount = true,
            }) {
              return context.read<MemberProvider>().get(
                filter: {
                  "page": page,
                  "pageSize": pageSize,
                  "includeTotalCount": includeTotalCount,
                  if (filter != null && filter.trim().isNotEmpty)
                    "FTS": filter.trim(),
                  "IncludeUser": true,
                  "IncludeMembership": true,
                },
              );
            },
      );

      Future.microtask(() => paging.loadPage());
      return paging;
    },
    child: Consumer<UniversalPagingProvider<Member>>(
      builder: (context, paging, _) {
        return BaseSearchAndTable<Member>(
          title: "Članovi",
          addButtonText: "Dodaj člana",

          onAdd: () async {
            final membershipItems = await _loadMembershipItems(context);

            await showBaseFormDialog(
              context: context,
              title: "Dodaj člana",
              initialValues: {
                "userDisplay": "",
                "userId": "",
                "membershipId": "",
                "expiryDate": "",
              },
              fieldsDef: _memberFields(membershipItems: membershipItems),
              onSubmit: (payload) async {
                try {
                  await _submitAddMember(
                    context: context,
                    paging: paging,
                    payload: payload,
                  );
                } catch (e) {
                  SnackbarHelper.showError(context, e.toString());
                  rethrow;
                }
              },
            );
          },

          // ---------------- SEARCH ----------------
          onSearchChanged: (value) => paging.search(value),
          onClearSearch: () => paging.search(""),

          isLoading: paging.isLoading,
          items: paging.items,

          columns: [
            BaseColumn<Member>(
              title: "Ime i prezime",
              flex: 3,
              cell: (m) => Text(
                "${m.user?.firstName ?? ""} ${m.user?.lastName ?? ""}".trim(),
              ),
            ),
            BaseColumn<Member>(
              title: "Članarina",
              flex: 2,
              cell: (m) => Text(m.membership?.name ?? ""),
            ),
            BaseColumn<Member>(
              title: "Datum uplate",
              flex: 2,
              cell: (m) => Text(DateHelper.format(m.paymentDate)),
            ),
            BaseColumn<Member>(
              title: "Datum isteka",
              flex: 2,
              cell: (m) {
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);

                final exp = DateTime(
                  m.expirationDate.year,
                  m.expirationDate.month,
                  m.expirationDate.day,
                );

                final isExpired = exp.isBefore(today);

                return Row(
                  children: [
                    Text(
                      DateHelper.format(m.expirationDate),
                      style: TextStyle(
                        color: isExpired ? Colors.red : null,
                        fontWeight: isExpired ? FontWeight.w600 : null,
                      ),
                    ),
                    if (isExpired) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "ISTEKLO",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],

          onEdit: (m) async {
            final membershipItems = await _loadMembershipItems(context);

            final userDisplay =
                "${m.user?.firstName ?? ""} ${m.user?.lastName ?? ""}".trim();

            await showBaseFormDialog(
              context: context,
              title: "Uredi člana",
              initialValues: {
                "userDisplay": userDisplay,
                "userId": m.userId.toString(),
                "membershipId": m.membershipId.toString(),
                "expiryDate": DateHelper.format(m.expirationDate),
              },
              fieldsDef: _memberFields(membershipItems: membershipItems),
              onSubmit: (payload) async {
                try {
                  await _submitEditMember(
                    context: context,
                    paging: paging,
                    memberId: m.id,
                    payload: payload,
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
            final fullName =
                "${m.user?.firstName ?? ""} ${m.user?.lastName ?? ""}".trim();

            final ok = await showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text("Brisanje člana"),
                content: Text("Jesi li siguran da želiš obrisati $fullName?"),
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

            try {
              await context.read<MemberProvider>().delete(m.id);
              await paging.loadPage();
              SnackbarHelper.showInfo(context, "Član obrisan.");
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

import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/base_form_dialogs_for_actions.dart';
import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/models/member.dart';
import 'package:gymify_desktop/models/membership.dart';
import 'package:gymify_desktop/models/user.dart';
import 'package:gymify_desktop/providers/member_provider.dart';
import 'package:gymify_desktop/providers/membership_provider.dart';
import 'package:gymify_desktop/providers/user_provider.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_widget.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';

/// Popup dialog za pretragu i odabir USER-a (samo "isUser": true)
Future<User?> showUserPickDialog({
  required BuildContext context,
}) async {
  final ctrl = TextEditingController();
  List<User> results = [];
  bool loading = false;

  return showDialog<User>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) {
        Future<void> runSearch(String q) async {
          final query = q.trim();
          if (query.isEmpty) {
            setState(() => results = []);
            return;
          }

          setState(() => loading = true);
          try {
            final res = await context.read<UserProvider>().get(
              filter: {
                "isUser": true,
                "fullNameSearch": query,
                "page": 0,
                "pageSize": 20,
                "includeTotalCount": false,
              },
            );
            results = res.items;
          } finally {
            setState(() => loading = false);
          }
        }

        return AlertDialog(
          title: const Text("Odaberi korisnika"),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: ctrl,
                  decoration: const InputDecoration(
                    hintText: "Kucaj ime ili prezime...",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => runSearch(v),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 320,
                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : results.isEmpty
                          ? const Center(child: Text("Nema rezultata."))
                          : ListView.builder(
                              itemCount: results.length,
                              itemBuilder: (_, i) {
                                final u = results[i];
                                final name =
                                    "${u.firstName ?? ""} ${u.lastName ?? ""}"
                                        .trim();
                                return ListTile(
                                  title: Text(name),
                                  subtitle: Text(u.email ?? ""),
                                  onTap: () => Navigator.pop(c, u),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text("Zatvori"),
            ),
          ],
        );
      },
    ),
  );
}

Widget MemberWidget() {
  return ChangeNotifierProvider<UniversalPagingProvider<Member>>(
    create: (context) {
      final paging = UniversalPagingProvider<Member>(
        pageSize: 5,
        fetcher: ({
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
              if (filter != null && filter.trim().isNotEmpty) "FTS": filter.trim(),
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

          // ---------------- ADD ----------------
          onAdd: () async {
            // ✅ Napuni membership dropdown
            final memRes = await context.read<MembershipProvider>().get(
              filter: {
                "page": 0,
                "pageSize": 1000,
                "includeTotalCount": false,
              },
            );
            final membershipItems =
                memRes.items.map<DropdownMenuItem<String>>((mm) {
              return DropdownMenuItem(
                value: mm.id.toString(),
                child: Text(mm.name ?? ""),
              );
            }).toList();

            await showBaseFormDialog(
              context: context,
              title: "Dodaj člana",
              initialValues: {
                "userDisplay": "",
                "userId": "",
                "membershipId": "",
                "expiryDate": "",
              },
              fieldsDef: [
                BaseFormFieldDef(
                  name: "userDisplay",
                  label: "Korisnik",
                  type: BaseFieldType.text, 
                  requiredField: true,
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
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Članarina je obavezna.";
                    return null;
                  },
                ),

                BaseFormFieldDef(
                  name: "expiryDate",
                  label: "Datum isteka",
                  type: BaseFieldType.date,
                  requiredField: true,
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Datum isteka je obavezan.";
                    try {
                      final iso = DateHelper.toIsoFromUi(value);
                      final exp = DateTime.tryParse(iso);
                      if (exp != null) {
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        final expDay = DateTime(exp.year, exp.month, exp.day);
                        if (expDay.isBefore(today)) {
                          return "Datum isteka ne može biti u prošlosti.";
                        }
                      }
                      return null;
                    } catch (_) {
                      return "Neispravan format datuma (dd.MM.yyyy).";
                    }
                  },
                ),
              ],

              onFieldChanged: (name, values, setValue) async {
              },

              onSubmit: (payload) async {
                try {
                
                  final currentUserId = (payload["userId"] ?? "").toString().trim();
                  if (currentUserId.isEmpty) {
                    final picked = await showUserPickDialog(context: context);
                    if (picked == null) {
                      throw Exception("Nije odabran korisnik.");
                    }
                    final display =
                        "${picked.firstName ?? ""} ${picked.lastName ?? ""}"
                            .trim();

                    await context.read<MemberProvider>().insert({
                      "userId": picked.id,
                      "membershipId": int.parse(payload["membershipId"]),
                      "paymentDate": DateTime.now().toIso8601String(),
                      "expirationDate":
                          DateHelper.toIsoFromUi(payload["expiryDate"]),
                    });

                    await paging.loadPage();
                    SnackbarHelper.showSuccess(
                      context,
                      "Član '$display' uspješno dodan.",
                    );
                    return;
                  }

                  final userId = int.tryParse(currentUserId);
                  final membershipId =
                      int.tryParse((payload["membershipId"] ?? "").toString());

                  if (userId == null) throw Exception("Neispravan userId.");
                  if (membershipId == null) {
                    throw Exception("Nije odabrana članarina.");
                  }

                  await context.read<MemberProvider>().insert({
                    "userId": userId,
                    "membershipId": membershipId,
                    "paymentDate": DateTime.now().toIso8601String(),
                    "expirationDate":
                        DateHelper.toIsoFromUi(payload["expiryDate"]),
                  });

                  await paging.loadPage();
                  SnackbarHelper.showSuccess(context, "Član uspješno dodan.");
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
            BaseColumn<Member>(
              title: "Ime i prezime",
              flex: 3,
              cell: (m) =>
                  Text("${m.user?.firstName ?? ""} ${m.user?.lastName ?? ""}"
                      .trim()),
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
              cell: (m) => Text(DateHelper.format(m.expirationDate)),
            ),
          ],

          // ---------------- EDIT ----------------
          onEdit: (m) async {
            final memRes = await context.read<MembershipProvider>().get(
              filter: {
                "page": 0,
                "pageSize": 1000,
                "includeTotalCount": false,
              },
            );
            final membershipItems =
                memRes.items.map<DropdownMenuItem<String>>((mm) {
              return DropdownMenuItem(
                value: mm.id.toString(),
                child: Text(mm.name ?? ""),
              );
            }).toList();

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
              fieldsDef: [
                BaseFormFieldDef(
                  name: "userDisplay",
                  label: "Korisnik",
                  requiredField: true,
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
                    if (value.isEmpty) return "Datum isteka je obavezan.";
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
                  final membershipId =
                      int.tryParse((payload["membershipId"] ?? "").toString());
                  if (membershipId == null) {
                    throw Exception("Nije odabrana članarina.");
                  }

                  await context.read<MemberProvider>().update(m.id, {
                    "userId": m.userId, // user ne mijenjamo ovdje
                    "membershipId": membershipId,
                    "paymentDate": DateTime.now().toIso8601String(),
                    "expirationDate":
                        DateHelper.toIsoFromUi(payload["expiryDate"]),
                  });

                  await paging.loadPage();
                  SnackbarHelper.showUpdate(context, "Član uspješno ažuriran.");
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
  final totalPages = (paging.totalCount + paging.pageSize - 1) ~/ paging.pageSize;

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

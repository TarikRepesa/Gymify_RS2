import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/base_form_dialogs_for_actions.dart';
import 'package:gymify_desktop/dialogs/confirmation_dialogs.dart';
import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';
import 'package:gymify_desktop/models/reward.dart';
import 'package:gymify_desktop/providers/reward_provider.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_with_actions_widget.dart';
import 'package:provider/provider.dart';

Widget RewardWidget() {
  return ChangeNotifierProvider<UniversalPagingProvider<Reward>>(
    create: (context) {
      final paging = UniversalPagingProvider<Reward>(
        pageSize: 5,
        fetcher: ({
          required int page,
          required int pageSize,
          String? filter,
          bool includeTotalCount = true,
        }) {
          return context.read<RewardProvider>().get(
            filter: {
              "page": page,
              "pageSize": pageSize,
              "includeTotalCount": includeTotalCount,
              if (filter != null && filter.trim().isNotEmpty)
                "name": filter.trim(),
            },
          );
        },
      );

      Future.microtask(() => paging.loadPage());
      return paging;
    },
    child: Consumer<UniversalPagingProvider<Reward>>(
      builder: (context, paging, _) {
        return BaseSearchAndActionsTable<Reward>(
          title: "Nagrade",
          addButtonText: "Dodaj nagradu",
          onAdd: () async => _openAddRewardDialog(context, paging),
          onSearchChanged: (value) => paging.search(value),
          onClearSearch: () => paging.search(""),
          isLoading: paging.isLoading,
          items: paging.items,
          columns: [
            CustomTableColumn<Reward>(
              title: "Naziv",
              flex: 2,
              cell: (r) => Text(
                r.name,
                style: _rowTextStyle(isSoftDeleted: _isSoftDeleted(r)),
              ),
            ),
            CustomTableColumn<Reward>(
              title: "Opis",
              flex: 3,
              cell: (r) => Text(
                (r.description ?? "").trim().isEmpty ? "-" : r.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _rowTextStyle(isSoftDeleted: _isSoftDeleted(r)),
              ),
            ),
            CustomTableColumn<Reward>(
              title: "Poeni",
              flex: 1,
              cell: (r) => Text(
                "${r.requiredPoints}",
                style: _rowTextStyle(isSoftDeleted: _isSoftDeleted(r)),
              ),
            ),
            CustomTableColumn<Reward>(
              title: "Vrijedi od",
              flex: 1,
              cell: (r) => Text(
                DateHelper.format(r.validFrom),
                style: _rowTextStyle(isSoftDeleted: _isSoftDeleted(r)),
              ),
            ),
            CustomTableColumn<Reward>(
              title: "Vrijedi do",
              flex: 1,
              cell: (r) => Text(
                DateHelper.format(r.validTo),
                style: _rowTextStyle(isSoftDeleted: _isSoftDeleted(r)),
              ),
            ),
            CustomTableColumn<Reward>(
              title: "Status",
              flex: 1,
              cell: (r) => _RewardStatusChip(reward: r),
            ),
          ],
          actionsBuilder: (reward) {
            if (_isSoftDeleted(reward)) {
              return [
                TableActionItem<Reward>(
                  label: "Trajno obriši",
                  icon: Icons.delete_forever_outlined,
                  color: Colors.red,
                  onTap: () async {
                    await _handlePermanentDelete(context, paging, reward);
                  },
                ),
                TableActionItem<Reward>(
                  label: "Vrati",
                  icon: Icons.restore_outlined,
                  color: Colors.green,
                  onTap: () async {
                    await _handleRestore(context, paging, reward);
                  },
                ),
              ];
            }

            if (_isActive(reward)) {
              return [
                TableActionItem<Reward>(
                  label: "Zaključano",
                  icon: Icons.lock_outline,
                  color: Colors.grey,
                  onTap: () {
                    SnackbarHelper.showError(
                      context,
                      "Aktivna nagrada se ne može uređivati niti brisati do isteka.",
                    );
                  },
                ),
              ];
            }

            return [
              TableActionItem<Reward>(
                label: "Uredi",
                icon: Icons.edit_outlined,
                color: const Color(0xFF387EFF),
                onTap: () async {
                  await _openEditRewardDialog(context, paging, reward);
                },
              ),
              TableActionItem<Reward>(
                label: "Izbriši",
                icon: Icons.delete_outline,
                color: Colors.red,
                onTap: () async {
                  await _handleTemporaryDelete(context, paging, reward);
                },
              ),
            ];
          },
          footer: _pagingControls(paging),
        );
      },
    ),
  );
}

Future<void> _openAddRewardDialog(
  BuildContext context,
  UniversalPagingProvider<Reward> paging,
) async {
  await showBaseFormDialog(
    context: context,
    title: "Dodaj nagradu",
    fieldsDef: [
      BaseFormFieldDef(
        name: "name",
        label: "Naziv nagrade",
        requiredField: true,
        validator: (v) {
          final value = (v ?? "").trim();
          if (value.isEmpty) return "Naziv je obavezan.";
          if (value.length < 2) return "Naziv je prekratak.";
          return null;
        },
      ),
      const BaseFormFieldDef(
        name: "description",
        label: "Opis",
        requiredField: false,
      ),
      BaseFormFieldDef(
        name: "requiredPoints",
        label: "Potrebni poeni",
        type: BaseFieldType.number,
        requiredField: true,
        validator: (v) {
          final value = (v ?? "").trim();
          if (value.isEmpty) return "Broj poena je obavezan.";
          final parsed = int.tryParse(value);
          if (parsed == null || parsed <= 0) {
            return "Poeni moraju biti veći od 0.";
          }
          return null;
        },
      ),
      BaseFormFieldDef(
        name: "validFrom",
        label: "Vrijedi od",
        type: BaseFieldType.date,
        requiredField: true,
        validator: (v) {
          final value = (v ?? "").trim();
          if (value.isEmpty) return "Datum početka je obavezan.";
          try {
            DateHelper.toIsoFromUi(value);
            return null;
          } catch (_) {
            return "Neispravan format datuma (dd.MM.yyyy).";
          }
        },
        crossValidator: (v, values) {
          final value = (v ?? "").trim();
          if (value.isEmpty) return null;

          try {
            final fromDate = DateTime.parse(DateHelper.toIsoFromUi(value));
            final today = DateTime.now();
            final todayOnly = DateTime(today.year, today.month, today.day);

            if (!fromDate.isAfter(todayOnly)) {
              return "Datum mora biti u budućnosti.";
            }

            final validToRaw = (values["validTo"] ?? "").toString().trim();
            if (validToRaw.isNotEmpty) {
              final toDate = DateTime.parse(DateHelper.toIsoFromUi(validToRaw));
              if (!fromDate.isBefore(toDate)) {
                return "'Vrijedi od' mora biti prije 'Vrijedi do'.";
              }
            }

            return null;
          } catch (_) {
            return null;
          }
        },
      ),
      BaseFormFieldDef(
        name: "validTo",
        label: "Vrijedi do",
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
        crossValidator: (v, values) {
          final value = (v ?? "").trim();
          if (value.isEmpty) return null;

          try {
            final toDate = DateTime.parse(DateHelper.toIsoFromUi(value));
            final today = DateTime.now();
            final todayOnly = DateTime(today.year, today.month, today.day);

            if (!toDate.isAfter(todayOnly)) {
              return "Datum mora biti u budućnosti.";
            }

            final validFromRaw = (values["validFrom"] ?? "").toString().trim();
            if (validFromRaw.isNotEmpty) {
              final fromDate = DateTime.parse(
                DateHelper.toIsoFromUi(validFromRaw),
              );
              if (!toDate.isAfter(fromDate)) {
                return "'Vrijedi do' mora biti poslije 'Vrijedi od'.";
              }
            }

            return null;
          } catch (_) {
            return null;
          }
        },
      ),
    ],
    onFieldChanged: (_, values, setValue) {
      if ((values["validFrom"] ?? "").toString().trim().isNotEmpty) {
        setValue("validFrom", values["validFrom"]);
      }
      if ((values["validTo"] ?? "").toString().trim().isNotEmpty) {
        setValue("validTo", values["validTo"]);
      }
    },
    onSubmit: (payload) async {
      final validFrom = DateHelper.toIsoFromUi(
        (payload["validFrom"] ?? "").toString(),
      );
      final validTo = DateHelper.toIsoFromUi(
        (payload["validTo"] ?? "").toString(),
      );

      await context.read<RewardProvider>().insert({
        "name": (payload["name"] ?? "").toString().trim(),
        "description": (payload["description"] ?? "").toString().trim(),
        "requiredPoints": int.parse(
          (payload["requiredPoints"] ?? "0").toString(),
        ),
        "status": "Planned",
        "validFrom": validFrom,
        "validTo": validTo,
      });

      await paging.loadPage();
      SnackbarHelper.showSuccess(context, "Nagrada uspješno dodana.");
    },
  );
}

Future<void> _openEditRewardDialog(
  BuildContext context,
  UniversalPagingProvider<Reward> paging,
  Reward reward,
) async {
  if (_isSoftDeleted(reward)) {
    SnackbarHelper.showError(
      context,
      "Soft deleted nagrada se ne može uređivati dok je ne vratiš.",
    );
    return;
  }

  if (_isActive(reward)) {
    SnackbarHelper.showError(
      context,
      "Aktivna nagrada se ne može uređivati do isteka.",
    );
    return;
  }

  await showBaseFormDialog(
    context: context,
    title: "Uredi nagradu",
    initialValues: {
      "name": reward.name,
      "description": reward.description ?? "",
      "requiredPoints": reward.requiredPoints.toString(),
      "validFrom": DateHelper.format(reward.validFrom),
      "validTo": DateHelper.format(reward.validTo),
    },
    fieldsDef: [
      BaseFormFieldDef(
        name: "name",
        label: "Naziv nagrade",
        requiredField: true,
        validator: (v) {
          final value = (v ?? "").trim();
          if (value.isEmpty) return "Naziv je obavezan.";
          if (value.length < 2) return "Naziv je prekratak.";
          return null;
        },
      ),
      const BaseFormFieldDef(
        name: "description",
        label: "Opis",
        requiredField: false,
      ),
      BaseFormFieldDef(
        name: "requiredPoints",
        label: "Potrebni poeni",
        type: BaseFieldType.number,
        requiredField: true,
        validator: (v) {
          final value = (v ?? "").trim();
          if (value.isEmpty) return "Broj poena je obavezan.";
          final parsed = int.tryParse(value);
          if (parsed == null || parsed <= 0) {
            return "Poeni moraju biti veći od 0.";
          }
          return null;
        },
      ),
      BaseFormFieldDef(
        name: "validFrom",
        label: "Vrijedi od",
        type: BaseFieldType.date,
        requiredField: true,
        validator: (v) {
          final value = (v ?? "").trim();
          if (value.isEmpty) return "Datum početka je obavezan.";
          try {
            DateHelper.toIsoFromUi(value);
            return null;
          } catch (_) {
            return "Neispravan format datuma (dd.MM.yyyy).";
          }
        },
        crossValidator: (v, values) {
          final value = (v ?? "").trim();
          if (value.isEmpty) return null;

          try {
            final fromDate = DateTime.parse(DateHelper.toIsoFromUi(value));
            final originalFrom = DateTime(
              reward.validFrom.year,
              reward.validFrom.month,
              reward.validFrom.day,
            );
            final candidateFrom = DateTime(
              fromDate.year,
              fromDate.month,
              fromDate.day,
            );

            final changed = candidateFrom != originalFrom;

            if (changed) {
              final today = DateTime.now();
              final todayOnly = DateTime(today.year, today.month, today.day);
              if (!candidateFrom.isAfter(todayOnly)) {
                return "Ako mijenjaš datum, mora biti u budućnosti.";
              }
            }

            final validToRaw = (values["validTo"] ?? "").toString().trim();
            if (validToRaw.isNotEmpty) {
              final toDate = DateTime.parse(DateHelper.toIsoFromUi(validToRaw));
              if (!fromDate.isBefore(toDate)) {
                return "'Vrijedi od' mora biti prije 'Vrijedi do'.";
              }
            }

            return null;
          } catch (_) {
            return null;
          }
        },
      ),
      BaseFormFieldDef(
        name: "validTo",
        label: "Vrijedi do",
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
        crossValidator: (v, values) {
          final value = (v ?? "").trim();
          if (value.isEmpty) return null;

          try {
            final toDate = DateTime.parse(DateHelper.toIsoFromUi(value));
            final originalTo = DateTime(
              reward.validTo.year,
              reward.validTo.month,
              reward.validTo.day,
            );
            final candidateTo = DateTime(
              toDate.year,
              toDate.month,
              toDate.day,
            );

            final changed = candidateTo != originalTo;

            if (changed) {
              final today = DateTime.now();
              final todayOnly = DateTime(today.year, today.month, today.day);
              if (!candidateTo.isAfter(todayOnly)) {
                return "Ako mijenjaš datum, mora biti u budućnosti.";
              }
            }

            final validFromRaw = (values["validFrom"] ?? "").toString().trim();
            if (validFromRaw.isNotEmpty) {
              final fromDate = DateTime.parse(
                DateHelper.toIsoFromUi(validFromRaw),
              );
              if (!toDate.isAfter(fromDate)) {
                return "'Vrijedi do' mora biti poslije 'Vrijedi od'.";
              }
            }

            return null;
          } catch (_) {
            return null;
          }
        },
      ),
    ],
    onFieldChanged: (_, values, setValue) {
      if ((values["validFrom"] ?? "").toString().trim().isNotEmpty) {
        setValue("validFrom", values["validFrom"]);
      }
      if ((values["validTo"] ?? "").toString().trim().isNotEmpty) {
        setValue("validTo", values["validTo"]);
      }
    },
    onSubmit: (payload) async {
      final validFromText = (payload["validFrom"] ?? "").toString();
      final validToText = (payload["validTo"] ?? "").toString();

      final validFrom = DateHelper.toIsoFromUi(validFromText);
      final validTo = DateHelper.toIsoFromUi(validToText);

      final fromDate = DateTime.parse(validFrom);
      final toDate = DateTime.parse(validTo);

      String nextStatus = reward.status;

      if (_isExpired(reward) && _isFutureDate(fromDate)) {
        final confirm = await ConfirmDialogs.yesNoConfirmation(
          context,
          title: "Promjena statusa",
          question:
              "Novi datum početka je u budućnosti.\n\n"
              "Ako sačuvaš ovu promjenu, status nagrade će biti vraćen na 'Planirana'.\n\n"
              "Da li želiš nastaviti?",
          yesText: "Sačuvaj",
          noText: "Odustani",
        );

        if (!confirm) return;

        nextStatus = "Planned";
      } else {
        nextStatus = _resolveStatusFromDates(
          validFrom: fromDate,
          validTo: toDate,
        );
      }

      await context.read<RewardProvider>().update(reward.id, {
        "name": (payload["name"] ?? "").toString().trim(),
        "description": (payload["description"] ?? "").toString().trim(),
        "requiredPoints": int.parse(
          (payload["requiredPoints"] ?? "0").toString(),
        ),
        "status": nextStatus,
        "validFrom": validFrom,
        "validTo": validTo,
      });

      await paging.loadPage();
      SnackbarHelper.showUpdate(context, "Nagrada uspješno ažurirana.");
    },
  );
}

Future<void> _handleTemporaryDelete(
  BuildContext context,
  UniversalPagingProvider<Reward> paging,
  Reward reward,
) async {
  if (_isActive(reward)) {
    SnackbarHelper.showError(
      context,
      "Aktivna nagrada se ne može brisati do isteka.",
    );
    return;
  }

  final ok = await ConfirmDialogs.badGoodConfirmation(
    context,
    title: "Privremeno brisanje nagrade",
    question:
        "Da li ste sigurni da želite privremeno ukloniti nagradu iz ponude?\n\n"
        "'${reward.name}'\n\n"
        "Nagrada će ostati vidljiva u listi i kasnije je možete vratiti ili trajno obrisati.",
    badText: "Odustani",
    goodText: "Privremeno obriši",
  );

  if (!ok) return;

  try {
    await context.read<RewardProvider>().update(reward.id, {
      "name": reward.name,
      "description": reward.description ?? "",
      "requiredPoints": reward.requiredPoints,
      "status": "SoftDeleted",
      "validFrom": reward.validFrom.toIso8601String(),
      "validTo": reward.validTo.toIso8601String(),
    });

    await paging.loadPage();
    SnackbarHelper.showSuccess(
      context,
      "Izvršeno je privremeno brisanje nagrade.",
    );
  } catch (e) {
    SnackbarHelper.showError(context, e.toString());
  }
}

Future<void> _handleRestore(
  BuildContext context,
  UniversalPagingProvider<Reward> paging,
  Reward reward,
) async {
  final ok = await ConfirmDialogs.yesNoConfirmation(
    context,
    title: "Vraćanje nagrade",
    question:
        "Da li ste sigurni da želite vratiti nagradu '${reward.name}' u ponudu?",
    yesText: "Vrati",
    noText: "Odustani",
  );

  if (!ok) return;

  try {
    final restoredStatus = _resolveStatusFromDates(
      validFrom: reward.validFrom,
      validTo: reward.validTo,
    );

    await context.read<RewardProvider>().update(reward.id, {
      "name": reward.name,
      "description": reward.description ?? "",
      "requiredPoints": reward.requiredPoints,
      "status": restoredStatus,
      "validFrom": reward.validFrom.toIso8601String(),
      "validTo": reward.validTo.toIso8601String(),
    });

    await paging.loadPage();
    SnackbarHelper.showSuccess(
      context,
      "Nagrada je uspješno vraćena u ponudu.",
    );
  } catch (e) {
    SnackbarHelper.showError(context, e.toString());
  }
}

Future<void> _handlePermanentDelete(
  BuildContext context,
  UniversalPagingProvider<Reward> paging,
  Reward reward,
) async {
  if (_isActive(reward)) {
    SnackbarHelper.showError(
      context,
      "Aktivna nagrada se ne može trajno brisati do isteka.",
    );
    return;
  }

  final ok = await ConfirmDialogs.badGoodConfirmation(
    context,
    title: "Trajno brisanje nagrade",
    question:
        "Da li ste sigurni da želite trajno obrisati nagradu?\n\n"
        "'${reward.name}'\n\n"
        "Ako postoje korisnici koji još nisu iskoristili nagradu ili im pravo korištenja nije isteklo, backend treba zabraniti ovu radnju.",
    badText: "Odustani",
    goodText: "Trajno obriši",
  );

  if (!ok) return;

  try {
    await context.read<RewardProvider>().delete(reward.id);
    await paging.loadPage();
    SnackbarHelper.showDelete(context, "Nagrada je trajno obrisana.");
  } catch (e) {
    SnackbarHelper.showError(context, e.toString());
  }
}

bool _isFutureDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final candidate = DateTime(date.year, date.month, date.day);
  return candidate.isAfter(today);
}

String _resolveStatusFromDates({
  required DateTime validFrom,
  required DateTime validTo,
}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final from = DateTime(validFrom.year, validFrom.month, validFrom.day);
  final to = DateTime(validTo.year, validTo.month, validTo.day);

  if (to.isBefore(today)) {
    return "Expired";
  }

  if (from.isAfter(today)) {
    return "Planned";
  }

  return "Active";
}

bool _isSoftDeleted(Reward reward) => reward.status == "SoftDeleted";
bool _isActive(Reward reward) => reward.status == "Active";
bool _isExpired(Reward reward) => reward.status == "Expired";

TextStyle _rowTextStyle({required bool isSoftDeleted}) {
  return TextStyle(
    decoration: isSoftDeleted ? TextDecoration.lineThrough : null,
    color: isSoftDeleted ? Colors.grey.shade600 : null,
    fontWeight: FontWeight.w500,
  );
}

String _statusLabel(String status) {
  switch (status) {
    case "Active":
      return "Aktivna";
    case "Planned":
      return "Planirana";
    case "Expired":
      return "Istekla";
    case "SoftDeleted":
      return "Privremeno obrisana";
    default:
      return status;
  }
}

Color _statusColor(String status) {
  switch (status) {
    case "Active":
      return Colors.green;
    case "Planned":
      return Colors.blue;
    case "Expired":
      return Colors.grey;
    case "SoftDeleted":
      return Colors.redAccent;
    default:
      return Colors.black54;
  }
}

class _RewardStatusChip extends StatelessWidget {
  final Reward reward;

  const _RewardStatusChip({required this.reward});

  @override
  Widget build(BuildContext context) {
    final text = _statusLabel(reward.status);
    final color = _statusColor(reward.status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
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
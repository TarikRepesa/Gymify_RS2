import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/confirmation_dialogs.dart';
import 'package:gymify_desktop/models/worker_task.dart';
import 'package:gymify_desktop/providers/work_task_provider.dart';
import 'package:gymify_desktop/utils/session.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_widget.dart';

Widget WorkerTaskWidget() {
  return ChangeNotifierProvider<UniversalPagingProvider<WorkerTask>>(
    create: (context) {
      final paging = UniversalPagingProvider<WorkerTask>(
        pageSize: 5,
        fetcher:
            ({
              required int page,
              required int pageSize,
              String? filter,
              bool includeTotalCount = true,
            }) {
              return context.read<WorkerTaskProvider>().get(
                filter: {
                  "page": page,
                  "pageSize": pageSize,
                  "includeTotalCount": includeTotalCount,
                  if (filter != null && filter.trim().isNotEmpty)
                    "FTS": filter.trim(),
                  "IncludeUser": true,
                  "UserId": Session.userId,
                },
              );
            },
      );

      Future.microtask(() => paging.loadPage());
      return paging;
    },
    child: Consumer<UniversalPagingProvider<WorkerTask>>(
      builder: (context, paging, _) {
        return BaseSearchAndTable<WorkerTask>(
          title: "Zadaci radnika",
          isStatusMode: true,
          addButtonText:
              null, // ovdje admin može imati add u posebnom widgetu ako želiš
          // SEARCH
          onSearchChanged: (value) => paging.search(value),
          onClearSearch: () => paging.search(""),

          isLoading: paging.isLoading,
          items: paging.items,

          columns: [
            BaseColumn<WorkerTask>(
              title: "Naziv",
              flex: 3,
              cell: (t) => Text(t.name ?? ""),
            ),
            BaseColumn<WorkerTask>(
              title: "Detalji",
              flex: 4,
              cell: (t) => Text(
                t.details ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            BaseColumn<WorkerTask>(
              title: "Kreiran",
              flex: 2,
              cell: (t) => Text(DateHelper.format(t.createdTaskDate)),
            ),
            BaseColumn<WorkerTask>(
              title: "Rok",
              flex: 2,
              cell: (t) {
                final now = DateTime.now();
                final exp = t.exparationTaskDate;
                final isLate = !t.isFinished && exp.isBefore(now);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateHelper.format(exp),
                      style: TextStyle(
                        color: isLate ? Colors.red : null,
                        fontWeight: isLate ? FontWeight.w700 : null,
                      ),
                    ),
                    if (isLate) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "ISTEKLO",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            BaseColumn<WorkerTask>(
              title: "Status",
              flex: 2,
              cell: (t) => _statusChip(t.isFinished),
            ),
          ],

          onEdit: (task) async {
            final from = task.isFinished ? "Završeno" : "Aktivno";
            final to = task.isFinished ? "Aktivno" : "Završeno";

            final ok = await ConfirmDialogs.yesNoConfirmation(
              context,
              title: "Promjena statusa",
              question:
                  "Da li želite promijeniti status zadatka:\n\n"
                  "${task.name}\n\n"
                  "Iz: $from\nU: $to",
              yesText: "Promijeni",
              noText: "Odustani",
            );

            if (!ok) return;

            try {
              await context.read<WorkerTaskProvider>().update(task.id, {
                "name": task.name,
                "details": task.details,
                "createdTaskDate": task.createdTaskDate.toIso8601String(),
                "exparationTaskDate": task.exparationTaskDate.toIso8601String(),
                "isFinished": !task.isFinished,
                "userId": task.userId,
              });

              await paging.loadPage();

              SnackbarHelper.showSuccess(
                context,
                "Status uspješno promijenjen.",
              );
            } catch (e) {
              SnackbarHelper.showError(context, e.toString());
            }
          },

          onDelete: (task) async {
            if (task.isFinished != true) {
              SnackbarHelper.showInfo(
                context,
                "Možete obrisati samo završene zadatke.",
              );
              return;
            }

            try {
              await context.read<WorkerTaskProvider>().delete(task.id);
              await paging.loadPage();
              SnackbarHelper.showInfo(context, "Zadatak obrisan.");
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

Widget _statusChip(bool isFinished) {
  final bg = isFinished
      ? Colors.green.withOpacity(0.15)
      : Colors.orange.withOpacity(0.18);
  final fg = isFinished ? Colors.green.shade800 : Colors.orange.shade900;
  final text = isFinished ? "Završeno" : "Aktivno";

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    child: Text(
      text,
      style: TextStyle(
        color: fg, // zelena ili narandžasta
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
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

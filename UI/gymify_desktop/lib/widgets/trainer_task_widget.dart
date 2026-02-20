import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/utils/session.dart';
import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_widget.dart';
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';

import 'package:gymify_desktop/models/training.dart';
import 'package:gymify_desktop/providers/training_provider.dart';

Widget TrainerTaskWidget() {
  return ChangeNotifierProvider<UniversalPagingProvider<Training>>(
    create: (context) {
      final paging = UniversalPagingProvider<Training>(
        pageSize: 5,
        fetcher: ({
          required int page,
          required int pageSize,
          String? filter,
          bool includeTotalCount = true,
        }) {
          return context.read<TrainingProvider>().get(
            filter: {
              "page": page,
              "pageSize": pageSize,
              "includeTotalCount": includeTotalCount,

              "userId": Session.userId,

              if (filter != null && filter.trim().isNotEmpty) "FTS": filter.trim(),

              "IncludeUser": true,
            },
          );
        },
      );

      Future.microtask(() => paging.loadPage());
      return paging;
    },
    child: Consumer<UniversalPagingProvider<Training>>(
      builder: (context, paging, _) {
        return BaseSearchAndTable<Training>(
          title: "Moji treninzi",
          addButtonText: null, 

          // SEARCH
          onSearchChanged: (value) => paging.search(value),
          onClearSearch: () => paging.search(""),

          isLoading: paging.isLoading,
          items: paging.items,

          columns: [
            BaseColumn<Training>(
              title: "Naziv treninga",
              flex: 3,
              cell: (t) => Text(t.name ?? ""),
            ),
            BaseColumn<Training>(
              title: "Datum",
              flex: 2,
              cell: (t) => Text(DateHelper.format(t.startDate)),
            ),
            BaseColumn<Training>(
              title: "Max učesnika",
              flex: 2,
              cell: (t) => Text("${t.maxAmountOfParticipants}"),
            ),
            BaseColumn<Training>(
              title: "Prijavljenih učesnika",
              flex: 2,
              cell: (t) => Text("${t.currentParticipants}"),
            ),
          ],

          // ✅ Trener nema edit/delete ovdje
          onEdit: null,
          onDelete: null,

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
import 'package:flutter/material.dart';
import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/models/membership.dart';
import 'package:gymify_desktop/providers/membership_provider.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_widget.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';

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
              if (filter != null && filter.trim().isNotEmpty) "FTS": filter.trim(),
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
          onAdd: () {},

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
              cell: (m) => Text("${(m.monthlyPrice ?? 0).toStringAsFixed(2)} KM"),
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
                m.createdAt == null ? "" : DateHelper.format(m.createdAt),
              ),
            ),
          ],

          onEdit: (m) {},
          onDelete: (m) {},

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

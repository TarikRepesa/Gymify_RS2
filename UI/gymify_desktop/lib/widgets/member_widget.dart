import 'package:flutter/material.dart';
import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/models/member.dart';
import 'package:gymify_desktop/providers/member_provider.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_widget.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';

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
              "IncludeMembership": true
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
          onAdd: () {},

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
              title: "Datum rođenja",
              flex: 2,
              cell: (m) => Text(
                m.user?.dateOfBirth == null
                    ? ""
                    : DateHelper.formatNullable(m.user?.dateOfBirth!)!,
              ),
            ),

            BaseColumn<Member>(
              title: "Vrsta članarine",
              flex: 2,
              cell: (m) => Text(
                // prilagodi polje kako ti je u modelu
                m.membership?.name ?? "",
              ),
            ),

            BaseColumn<Member>(
              title: "Datum isteka",
              flex: 2,
              cell: (m) => Text(
                // prilagodi polje kako ti je u modelu
                m.expirationDate == null ? "" : DateHelper.format(m.expirationDate),
              ),
            ),

            BaseColumn<Member>(
              title: "Kontakt",
              flex: 2,
              cell: (m) => Text(
                m.user?.email ?? "neki email", 
                style: const TextStyle(decoration: TextDecoration.underline),
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



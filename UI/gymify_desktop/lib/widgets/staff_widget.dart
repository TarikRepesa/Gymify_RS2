import 'package:flutter/material.dart';
import 'package:gymify_desktop/models/user.dart';
import 'package:gymify_desktop/providers/user_provider.dart';
import 'package:gymify_desktop/widgets/base_search_and_list_widget.dart';
import 'package:provider/provider.dart';

// koristi tvoj UniversalPagingProvider iz starog projekta
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';

Widget StaffWidget() {
  return ChangeNotifierProvider<UniversalPagingProvider<User>>(
    create: (context) {
      final provider = UniversalPagingProvider<User>(
        pageSize: 5,
        fetcher: ({
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

      // auto-load prvu stranicu
      Future.microtask(() => provider.loadPage());
      return provider;
    },
    child: Consumer<UniversalPagingProvider<User>>(
      builder: (context, paging, _) {
        return BaseSearchAndTable<User>(
          title: "Osoblje",
          addButtonText: "Dodaj osoblje",
          onAdd: () {},

          // search koristi paging.search
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
          ],

          onEdit: (u) {},
          onDelete: (u) {},

          footer: _pagingControls(paging),
        );
      },
    ),
  );
}

Widget _pagingControls(UniversalPagingProvider<User> paging) {
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

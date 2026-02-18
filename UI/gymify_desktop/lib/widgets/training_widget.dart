import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/models/training.dart';
import 'package:gymify_desktop/providers/training_provider.dart';
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';

Widget TrainingWidget() {
  InputDecoration _searchDecoration() {
    return InputDecoration(
      hintText: "Pretraga po nazivu",
      hintStyle: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF8A8A8A),
      ),
      prefixIcon: const Icon(Icons.search_rounded, size: 18),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Color(0xFF387EFF), width: 1.6),
      ),
    );
  }

  Widget _card(Training t) {
    final title = (t.name).toString();
    final trainer = ("${t.user?.firstName} ${t.user?.lastName}").toString();
    final members = 25;

    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 160,
              color: const Color(0xFFD0D6DD),
              child: const Icon(Icons.image_outlined, size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),
          Container(height: 1, color: Colors.black.withOpacity(0.12)),
          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.person, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  trainer,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.people_alt_rounded, size: 20),
              const SizedBox(width: 8),
              Text(
                "$members",
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 34,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF387EFF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text(
                "PRIKAŽI DETALJE",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pagingControls(UniversalPagingProvider<Training> paging) {
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
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        IconButton(
          onPressed: paging.hasNextPage ? () => paging.nextPage() : null,
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  return ChangeNotifierProvider<UniversalPagingProvider<Training>>(
    create: (context) {
      final paging = UniversalPagingProvider<Training>(
        pageSize: 6, // grid ljepše izgleda sa 6/9/12
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
              if (filter != null && filter.trim().isNotEmpty) "FTS": filter.trim(),
              "IncludeUser": true
            },
          );
        },
      );

      Future.microtask(() => paging.loadPage());
      return paging;
    },
    child: Consumer<UniversalPagingProvider<Training>>(
      builder: (context, paging, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          child: Column(
            children: [
              const Text(
                "Grupni treninzi",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 22),

              // search + add button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: _searchDecoration(),
                      onChanged: (v) => paging.search(v),
                    ),
                  ),
                  const SizedBox(width: 18),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF387EFF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text(
                        "DODAJ NOVI TRENING",
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // content
              Expanded(
                child: paging.isLoading && paging.items.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : paging.items.isEmpty
                        ? const Center(
                            child: Text(
                              "Nema podataka.",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 18),
                                child: Wrap(
                                  spacing: 60,
                                  runSpacing: 30,
                                  children: paging.items.map(_card).toList(),
                                ),
                              ),
                            ),
                          ),
              ),

              const SizedBox(height: 10),

              // paging footer
              _pagingControls(paging),
            ],
          ),
        );
      },
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:gymify_desktop/dialogs/confirmation_dialogs.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';

import 'package:gymify_desktop/models/review.dart';
import 'package:gymify_desktop/providers/review_provider.dart';

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({super.key});

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  final TextEditingController _searchCtrl = TextEditingController();

  int? _selectedStars; // dropdown filter (1-5)
  // ako želiš: debounce za search, ali za sad je ok bez toga

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  InputDecoration _searchDecoration({
    required TextEditingController controller,
    required String hint,
    VoidCallback? onClear,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF8A8A8A),
      ),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18) : null,
      suffixIcon: (onClear == null || controller.text.trim().isEmpty)
          ? null
          : IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: onClear,
              tooltip: "Očisti",
            ),
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

  String _reviewerName(Review r) {
    final fn = r.user?.firstName?.trim() ?? "";
    final ln = r.user?.lastName?.trim() ?? "";
    final full = "$fn $ln".trim();
    return full.isEmpty ? "Nepoznato" : full;
  }

  Widget _starRow(int count) {
    final c = count.clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < c ? Icons.star_rounded : Icons.star_border_rounded,
          size: 18,
          color: const Color(0xFFFFC107),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Review r) async {
    final ok = await ConfirmDialogs.badGoodConfirmation(
      context,
      title: "Brisanje recenzije",
      question:
          "Da li ste sigurni da želite obrisati recenziju:\n\n"
          "Autor: ${_reviewerName(r)}\n"
          "Ocjena: ${r.starNumber} zvjezdica\n\n"
          "Poruka:\n„${r.message ?? ""}“",
      badText: "Odustani",
      goodText: "Obriši",
    );

    return ok;
  }

  Future<void> _deleteReview({
    required BuildContext context,
    required UniversalPagingProvider<Review> paging,
    required Review r,
  }) async {
    final id = r.id;
    if (id == null) {
      SnackbarHelper.showError(context, "Ne mogu obrisati – ID nedostaje.");
      return;
    }

    final ok = await _confirmDelete(context, r);
    if (!ok) return;

    try {
      await context.read<ReviewProvider>().delete(id);

      // refresh: zadrži trenutni search + stars filter
      await paging.search(_searchCtrl.text.trim());

      if (mounted) {
        SnackbarHelper.showUpdate(context, "Recenzija obrisana.");
      }
    } catch (e) {
      if (mounted) SnackbarHelper.showError(context, e.toString());
    }
  }

  Widget _reviewCard({
    required BuildContext context,
    required UniversalPagingProvider<Review> paging,
    required Review r,
  }) {
    final name = _reviewerName(r);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.person, size: 22, color: Colors.black87),
          const SizedBox(width: 10),

          // ime
          SizedBox(
            width: 170,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2F2F2F),
              ),
            ),
          ),

          // divider
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            width: 1,
            height: 28,
            color: Colors.black.withOpacity(0.18),
          ),

          // komentar
          const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 18,
            color: Colors.black87,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              r.message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3A3A),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // zvjezdice
          _starRow(r.starNumber),

          const SizedBox(width: 16),

          // delete
          IconButton(
            onPressed: paging.isLoading
                ? null
                : () => _deleteReview(context: context, paging: paging, r: r),
            icon: Icon(
              Icons.delete_outline_rounded,
              color: Colors.red.withOpacity(0.85),
            ),
            iconSize: 20,
            splashRadius: 18,
            tooltip: "Obriši",
          ),
        ],
      ),
    );
  }

  Widget _pagingControls(UniversalPagingProvider<Review> paging) {
    final totalPages =
        (paging.totalCount + paging.pageSize - 1) ~/ paging.pageSize;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: paging.hasPreviousPage
              ? () => paging.previousPage()
              : null,
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UniversalPagingProvider<Review>>(
      create: (context) {
        final paging = UniversalPagingProvider<Review>(
          pageSize: 5,
          fetcher:
              ({
                required int page,
                required int pageSize,
                String? filter,
                bool includeTotalCount = true,
              }) {
                return context.read<ReviewProvider>().get(
                  filter: {
                    "page": page,
                    "pageSize": pageSize,
                    "includeTotalCount": includeTotalCount,

                    if (filter != null && filter.trim().isNotEmpty)
                      "FTS": filter.trim(),

                    if (_selectedStars != null) "StarNumber": _selectedStars,

                    "IncludeUser": true,
                  },
                );
              },
        );

        Future.microtask(() => paging.loadPage());
        return paging;
      },
      child: Consumer<UniversalPagingProvider<Review>>(
        builder: (context, paging, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
            child: Column(
              children: [
                const Text(
                  "Recenzije",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 22),

                // SEARCH + STARS FILTER
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: _searchDecoration(
                          controller: _searchCtrl,
                          hint: "Pretraga recenzija po članovima",
                          prefixIcon: Icons.search_rounded,
                          onClear: () {
                            _searchCtrl.clear();
                            setState(() {});
                            paging.search("");
                          },
                        ),
                        onChanged: (v) {
                          setState(() {}); // da suffix reaguje
                          paging.search(v);
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<int>(
                        value: _selectedStars,
                        decoration: _searchDecoration(
                          controller: TextEditingController(text: ""),
                          hint: "Pretraga po broju zvjezdica",
                          prefixIcon: Icons.star_rounded,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 5,
                            child: Text("5 zvjezdica"),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text("4 zvjezdice"),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text("3 zvjezdice"),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text("2 zvjezdice"),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text("1 zvjezdica"),
                          ),
                        ],
                        onChanged: (v) async {
                          setState(() => _selectedStars = v);
                          // zadrži trenutni search tekst
                          await paging.search(_searchCtrl.text.trim());
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        isExpanded: true,
                      ),
                    ),

                    // opcionalno dugme za "reset star filter"
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 42,
                      child: OutlinedButton(
                        onPressed: () async {
                          setState(() => _selectedStars = null);
                          await paging.search(_searchCtrl.text.trim());
                        },
                        child: const Text("Reset"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                Expanded(
                  child: (paging.isLoading && paging.items.isEmpty)
                      ? const Center(child: CircularProgressIndicator())
                      : paging.items.isEmpty
                      ? const Center(
                          child: Text(
                            "Nema podataka.",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        )
                      : ListView.builder(
                          itemCount: paging.items.length,
                          itemBuilder: (context, i) => _reviewCard(
                            context: context,
                            paging: paging,
                            r: paging.items[i],
                          ),
                        ),
                ),

                const SizedBox(height: 10),
                _pagingControls(paging),
              ],
            ),
          );
        },
      ),
    );
  }
}

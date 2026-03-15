import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/config/api_config.dart';
import 'package:gymify_desktop/dialogs/confirmation_dialogs.dart';
import 'package:gymify_desktop/helper/date_helper.dart';
import 'package:gymify_desktop/helper/image_helper.dart';
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';

import 'package:gymify_desktop/models/reservation.dart';
import 'package:gymify_desktop/providers/reservation_provider.dart';

Widget CancelledReservationsWidget() {
  InputDecoration _searchDecoration() {
    return InputDecoration(
      hintText: "Pretraga po treningu ili treneru",
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

  String? _trainingImageToUrl(String? trainingImage) {
    if (!ImageHelper.hasValidImage(trainingImage)) return null;

    if (ImageHelper.isHttp(trainingImage!)) {
      return trainingImage;
    }

    return "${ApiConfig.apiBase}/images/training/$trainingImage";
  }

  String _userFullName(dynamic user) {
    if (user == null) return "—";

    final first = (user.firstName ?? "").toString().trim();
    final last = (user.lastName ?? "").toString().trim();
    final full = "$first $last".trim();

    if (full.isNotEmpty) return full;

    return (user.username ?? "—").toString();
  }

  String _trainerFullName(dynamic training) {
    final trainer = training?.user;
    if (trainer == null) return "—";

    final first = (trainer.firstName ?? "").toString().trim();
    final last = (trainer.lastName ?? "").toString().trim();
    final full = "$first $last".trim();

    if (full.isNotEmpty) return full;

    return (trainer.username ?? "—").toString();
  }

  Future<void> _deleteReservationPermanently(
    BuildContext context,
    UniversalPagingProvider<Reservation> paging,
    Reservation r,
  ) async {
    final confirmed = await ConfirmDialogs.badGoodConfirmation(
      context,
      title: "Permanentno brisanje",
      question:
          "Da li ste sigurni da želite permanentno obrisati ovu otkazanu rezervaciju?\n\nOva radnja se ne može vratiti.",
      goodText: "Da, obriši",
      badText: "Odustani",
    );

    if (!confirmed) return;

    try {
      await context.read<ReservationProvider>().delete(r.id);

      await paging.refresh();

      if (context.mounted) {
        await ConfirmDialogs.okConfirmation(
          context,
          title: "Uspješno",
          message: "Rezervacija je permanentno obrisana.",
          okText: "U redu",
        );
      }
    } catch (e) {
      if (context.mounted) {
        await ConfirmDialogs.okConfirmation(
          context,
          title: "Greška",
          message: "Nije moguće obrisati rezervaciju.\n\n$e",
          okText: "OK",
        );
      }
    }
  }

  Widget _card({
    required BuildContext context,
    required UniversalPagingProvider<Reservation> paging,
    required Reservation r,
  }) {
    final training = r.training;
    final title = training?.name ?? "Trening";
    final trainerName = _trainerFullName(training);
    final customerName = _userFullName(r.user);

    final imgUrl = _trainingImageToUrl(training?.trainingImage);

    final reservedAt = r.createdAt;
    final cancelledAt = r.cancelledAt;
    final cancelReason = (r.cancelReason ?? "").trim();
    final trainingDate = training?.startDate;

    return Container(
      width: 320,
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
              child: imgUrl != null
                  ? Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 46,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title.toString(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.red.withOpacity(0.22)),
              ),
              child: const Text(
                "OTKAZANA",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
          Container(height: 1, color: Colors.black.withOpacity(0.12)),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.person_outline, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Korisnik: $customerName",
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.fitness_center_outlined, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Trener: $trainerName",
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.calendar_month_outlined, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Datum treninga: ${trainingDate != null ? DateHelper.format(trainingDate) : "—"}",
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.event_available_outlined, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Rezervisano: ${DateHelper.format(reservedAt)}",
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.cancel_outlined, size: 20, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Otkazano: ${cancelledAt != null ? DateHelper.format(cancelledAt) : "—"}",
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.notes_outlined, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Razlog: ${cancelReason.isNotEmpty ? cancelReason : "—"}",
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 36,
            child: ElevatedButton.icon(
              onPressed: () => _deleteReservationPermanently(context, paging, r),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.delete_forever_outlined, size: 18),
              label: const Text(
                "Obriši",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pagingControls(UniversalPagingProvider<Reservation> paging) {
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
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        IconButton(
          onPressed: paging.hasNextPage ? () => paging.nextPage() : null,
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  return ChangeNotifierProvider<UniversalPagingProvider<Reservation>>(
    create: (context) {
      final paging = UniversalPagingProvider<Reservation>(
        pageSize: 6,
        fetcher: ({
          required int page,
          required int pageSize,
          String? filter,
          bool includeTotalCount = true,
        }) {
          return context.read<ReservationProvider>().get(
            filter: {
              "page": page,
              "pageSize": pageSize,
              "includeTotalCount": includeTotalCount,
              "IncludeTraining": true,
              "IncludeUser": true,
              "Status": "Cancelled",
              if (filter != null && filter.trim().isNotEmpty)
                "FTS": filter.trim(),
            },
          );
        },
      );

      Future.microtask(() => paging.loadPage());
      return paging;
    },
    child: Consumer<UniversalPagingProvider<Reservation>>(
      builder: (context, paging, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          child: Column(
            children: [
              const Text(
                "Otkazane rezervacije",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 22),
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
                    child: ElevatedButton.icon(
                      onPressed: () => paging.refresh(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF387EFF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text(
                        "OSVJEŽI",
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
              Expanded(
                child: paging.isLoading && paging.items.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : paging.items.isEmpty
                        ? const Center(
                            child: Text(
                              "Nema otkazanih rezervacija.",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 18,
                                ),
                                child: Wrap(
                                  spacing: 40,
                                  runSpacing: 28,
                                  children: paging.items
                                      .map(
                                        (r) => _card(
                                          context: context,
                                          paging: paging,
                                          r: r,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
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
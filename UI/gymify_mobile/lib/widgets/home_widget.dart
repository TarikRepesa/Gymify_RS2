import 'package:flutter/material.dart';
import 'package:gymify_mobile/widgets/swipe_widget.dart';
import 'package:provider/provider.dart';

import 'package:gymify_mobile/helper/univerzal_pagging_helper.dart';
import 'package:gymify_mobile/models/notification.dart';
import 'package:gymify_mobile/models/review.dart';
import 'package:gymify_mobile/providers/notification_provider.dart';
import 'package:gymify_mobile/providers/review_provider.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color lightGrey = Color(0xFFF2F2F2);

  late final UniversalPagingProvider<NotificationModel> _notifPaging;
  late final UniversalPagingProvider<Review> _reviewPaging;

  @override
  void initState() {
    super.initState();

    _notifPaging = UniversalPagingProvider<NotificationModel>(
      pageSize: 5,
      fetcher: ({
        required int page,
        required int pageSize,
        String? filter,
        Map<String, dynamic>? extra,
        bool includeTotalCount = true,
      }) async {
        final provider = context.read<NotificationProvider>();

        final query = <String, dynamic>{
          // 🔁 Ako API koristi druga imena, promijeni ovdje:
          "page": page,
          "pageSize": pageSize,
          if (filter != null && filter.isNotEmpty) "filter": filter,
          // dodatni filteri (npr userId, sort...) preko applyExtra
          ...?extra,
          if (includeTotalCount) "includeTotalCount": true,
        };

        return provider.get(filter: query);
      },
    );

    _reviewPaging = UniversalPagingProvider<Review>(
      pageSize: 3,
      fetcher: ({
        required int page,
        required int pageSize,
        String? filter,
        Map<String, dynamic>? extra,
        bool includeTotalCount = true,
      }) async {
        final provider = context.read<ReviewProvider>();

        final query = <String, dynamic>{
          // 🔁 Ako API koristi druga imena, promijeni ovdje:
          "page": page,
          "pageSize": pageSize,
          "IncludeUser": true,
          if (filter != null && filter.isNotEmpty) "filter": filter,
          ...?extra,
          if (includeTotalCount) "includeTotalCount": true,
        };

        return provider.get(filter: query);
      },
    );

    // prvi load
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        _notifPaging.loadPage(pageNumber: 0),
        _reviewPaging.loadPage(pageNumber: 0),
      ]);
    });
  }

  @override
  void dispose() {
    _notifPaging.dispose();
    _reviewPaging.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.wait([_notifPaging.refresh(), _reviewPaging.refresh()]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// LOGO
              SizedBox(
                height: 90,
                child: Image.asset(
                  'assets/images/gymify_logo.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "GYMIFY",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: gymBlueDark,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Dobrodošli!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              /// ===========================
              /// OBAVIJESTI (paging + swipe)
              /// ===========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedBuilder(
                  animation: _notifPaging,
                  builder: (context, _) {
                    final count = _notifPaging.totalCount == 0
                        ? _notifPaging.items.length
                        : _notifPaging.totalCount;

                    return Row(
                      children: [
                        const Icon(Icons.notifications, color: Colors.black87),
                        const SizedBox(width: 8),
                        Text(
                          "OBAVIJESTI ($count)",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        if (_notifPaging.isLoading &&
                            _notifPaging.items.isNotEmpty)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SwipePagedList<NotificationModel>(
                  provider: _notifPaging,
                  separatorHeight: 14,
                  itemBuilder: (context, n) {
                    final date = _formatDate(n.createdAt);
                    final text = _buildNotificationText(n);
                    final important = _isImportant(n);

                    return _notificationCard(
                      date: date,
                      text: text,
                      isImportant: important,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              /// ===========================
              /// REVIEWS (paging + swipe)
              /// ===========================
              const Text(
                "Drugo o nama",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SwipePagedList<Review>(
                  provider: _reviewPaging,
                  separatorHeight: 12,
                  itemBuilder: (context, r) {
                    final name = _reviewAuthor(r);
                    final message = r.message;
                    final stars = (r.starNumber).clamp(0, 5);

                    return _reviewCard(
                      name: name,
                      message: message,
                      stars: stars,
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              /// FOOTER
              _footer(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================
  // UI (isti dizajn)
  // ===========================

  static Widget _notificationCard({
    required String date,
    required String text,
    required bool isImportant,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isImportant ? Colors.red : Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isImportant ? Colors.red : Colors.grey,
              width: isImportant ? 1.2 : 1,
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _reviewCard({
    required String name,
    required String message,
    required int stars,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.person, size: 18),
              const SizedBox(width: 6),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(
                index < stars ? Icons.star : Icons.star_border,
                color: Colors.orange,
                size: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget _footer() {
    return Column(
      children: const [
        Text(
          "gymifyinfo.com",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email_outlined, size: 22),
            SizedBox(width: 18),
            Icon(Icons.camera_alt_outlined, size: 22),
            SizedBox(width: 18),
            Icon(Icons.facebook, size: 22),
          ],
        ),
      ],
    );
  }

  // ===========================
  // Data helpers
  // ===========================

  String _formatDate(DateTime? dt) {
    if (dt == null) return "";
    final d = dt.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return "$dd.$mm.$yyyy";
  }

  String _buildNotificationText(NotificationModel n) {
    // prilagodi polja ako su drugačija u tvom modelu
    final title = (n.title ?? "").trim();
    final content = (n.content ?? "").trim();

    if (title.isEmpty) return content;
    if (content.isEmpty) return title;
    return "$title\n$content";
  }

  bool _isImportant(NotificationModel n) {
    // ako nemaš flag, mala heuristika
    final text = "${n.title ?? ""} ${n.content ?? ""}".toLowerCase();
    return text.contains("otkaz") ||
        text.contains("hitno") ||
        text.contains("važno") ||
        text.contains("vazno");
  }

  String _reviewAuthor(Review r) {
    final user = r.user;
    if (user == null) return "Korisnik";

    final fullName = ("${user.firstName} ${user.lastName}" ?? "").trim();
    if (fullName.isNotEmpty) return fullName;

    final username = (user.username ?? "").trim();
    if (username.isNotEmpty) return username;

    return "Korisnik";
  }
}
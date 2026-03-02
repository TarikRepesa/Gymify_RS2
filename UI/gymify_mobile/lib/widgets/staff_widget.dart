import 'package:flutter/material.dart';
import 'package:gymify_mobile/models/user.dart';
import 'package:gymify_mobile/providers/user_provider.dart';
import 'package:gymify_mobile/screens/staff_detail_screen.dart';
import 'package:provider/provider.dart';

import 'package:gymify_mobile/config/api_config.dart';
import 'package:gymify_mobile/helper/image_helper.dart';
import 'package:gymify_mobile/helper/univerzal_pagging_helper.dart';
import 'package:gymify_mobile/widgets/swipe_widget.dart';

class StaffWidget extends StatefulWidget {
  const StaffWidget({super.key});

  @override
  State<StaffWidget> createState() => _StaffWidgetState();
}

class _StaffWidgetState extends State<StaffWidget> {
  static const Color gymBlue = Color(0xFF1976D2);
  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color lightGrey = Color(0xFFF2F2F2);

  final TextEditingController _searchCtrl = TextEditingController();

  late final UniversalPagingProvider<User> _paging;

  @override
  void initState() {
    super.initState();

    _paging = UniversalPagingProvider<User>(
      pageSize: 6,
      fetcher:
          ({
            required int page,
            required int pageSize,
            String? filter,
            Map<String, dynamic>? extra,
            bool includeTotalCount = true,
          }) async {
            final provider = context.read<UserProvider>();

            final query = _buildQuery(
              page: page,
              pageSize: pageSize,
              filter: filter,
              extra: extra,
              includeTotalCount: includeTotalCount,
            );

            return provider.get(filter: query);
          },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _paging.loadPage(pageNumber: 0);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _paging.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildQuery({
    required int page,
    required int pageSize,
    String? filter,
    Map<String, dynamic>? extra,
    required bool includeTotalCount,
  }) {
    return <String, dynamic>{
      "page": page,
      "pageSize": pageSize,

      "isRadnik": true,
      "isTrener": true,
      if (includeTotalCount) "includeTotalCount": true,

      if (filter != null && filter.isNotEmpty) "filter": filter,

      ...?extra,
    };
  }

  Future<void> _onSearchChanged(String value) async {
    final v = value.trim();
    await _paging.applyExtra({"FTS": v});
  }

  Future<void> _resetFilters() async {
    setState(() {
      _searchCtrl.clear();
    });

    await _paging.applyExtra({});
    await _paging.loadPage(pageNumber: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _paging.refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: const Text(
                  "OSOBLJE",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              // Search + Reset
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: _InputLike(
                        hint: "Unesi ime osobe",
                        controller: _searchCtrl,
                        onChanged: _onSearchChanged,
                        leading: const Icon(Icons.search, size: 20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _resetFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Icon(Icons.refresh),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // List + swipe paging
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: SwipePagedList<User>(
                  provider: _paging,
                  separatorHeight: 14,
                  itemBuilder: (context, u) {
                    final fullName = "${u.firstName} ${u.lastName}".trim();
                    final role = _roleText(u);

                    return _StaffCard(
                      fullName: fullName.isEmpty ? u.username : fullName,
                      username: u.username,
                      roleText: role,
                      userImage: u.userImage,
                      isActive: u.isActive,
                      onDetails: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StaffDetailsScreen(user: u),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _roleText(User u) {
    final trener = u.isTrener == true;
    final radnik = u.isRadnik == true;
    final admin = u.isAdmin == true;

    if (admin) return "Admin";
    if (trener && radnik) return "Trener / Radnik";
    if (trener) return "Trener";
    if (radnik) return "Radnik";
    return "Osoblje";
  }
}

// =========================
// UI components
// =========================

class _InputLike extends StatelessWidget {
  const _InputLike({
    required this.hint,
    this.leading,
    this.controller,
    this.onTap,
    this.onChanged,
  });

  final String hint;
  final Widget? leading;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final readOnly = onTap != null && controller == null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 10)],
              Expanded(
                child: controller == null
                    ? Text(
                        hint,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: readOnly ? Colors.black87 : Colors.black54,
                        ),
                      )
                    : TextField(
                        controller: controller,
                        onChanged: onChanged,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black45,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
              ),
              if (controller == null) const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard({
    required this.fullName,
    required this.username,
    required this.roleText,
    required this.userImage,
    required this.isActive,
    required this.onDetails,
  });

  static const Color gymBlueDark = Color(0xFF0D47A1);
  static const Color lightGrey = Color(0xFFF2F2F2);

  final String fullName;
  final String username;
  final String roleText;
  final String? userImage;
  final bool isActive;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 4),
            color: Color(0x11000000),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 64,
                height: 64,
                child: ImageHelper.hasValidImage(userImage)
                    ? (ImageHelper.isHttp(userImage!)
                          ? Image.network(
                              userImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _avatarFallback(),
                            )
                          : Image.network(
                              // ⚠️ prilagodi folder ako je drugačiji
                              "${ApiConfig.apiBase}/images/users/$userImage",
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _avatarFallback(),
                            ))
                    : _avatarFallback(),
              ),
            ),

            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "@$username",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: lightGrey,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Text(
                          roleText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isActive ? "Aktivan" : "Neaktivan",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          color: isActive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Details button
            SizedBox(
              height: 34,
              child: ElevatedButton(
                onPressed: onDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: gymBlueDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "DETALJI",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      color: lightGrey,
      child: const Center(
        child: Icon(Icons.person, size: 34, color: Colors.black26),
      ),
    );
  }
}

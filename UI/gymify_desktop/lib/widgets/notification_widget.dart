import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/helper/snackBar_helper.dart';
import 'package:gymify_desktop/helper/univerzal_pagging_helper.dart';
import 'package:gymify_desktop/helper/date_helper.dart';

import 'package:gymify_desktop/models/notification.dart';
import 'package:gymify_desktop/providers/notification_provider.dart';

import 'package:gymify_desktop/dialogs/base_dialogs_frame.dart';
import 'package:gymify_desktop/utils/session.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  InputDecoration _searchDecoration({
    required TextEditingController controller,
    required VoidCallback onClear,
  }) {
    return InputDecoration(
      hintText: "Pretraga",
      hintStyle: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF8A8A8A),
      ),
      prefixIcon: const Icon(Icons.search_rounded, size: 18),
      suffixIcon: controller.text.trim().isEmpty
          ? null
          : IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: onClear,
              tooltip: "Očisti pretragu",
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

  String _dateKeyFromNotification(NotificationModel n) {
    return DateHelper.format(n.createdAt);
  }

  String _roleLabel(dynamic u) {
    try {
      if (u.isAdmin == true) return "Admin";
      if (u.isRadnik == true) return "Radnik";
      if (u.isTrener == true) return "Trener";
      if (u.isUser == true) return "Korisnik";
    } catch (_) {}
    return "Nepoznato";
  }

  String _authorName(NotificationModel n) {
    final u = n.user;

    final fn = u?.firstName?.trim() ?? "";
    final ln = u?.lastName?.trim() ?? "";
    final full = "$fn $ln".trim();

    if (u == null || full.isEmpty) return "Nepoznato";

    final role = _roleLabel(u);
    return "$full ($role)";
  }

  Future<bool> _confirmDelete(BuildContext context, NotificationModel n) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Brisanje obavijesti"),
        content: Text(
          "Jesi li siguran da želiš obrisati obavijest:\n\n“${n.title}” ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text("Odustani"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text("Obriši"),
          ),
        ],
      ),
    );

    return ok == true;
  }

  Future<void> _deleteNotification({
    required BuildContext context,
    required UniversalPagingProvider<NotificationModel> paging,
    required NotificationModel n,
  }) async {
    final id = n.id;
    if (id == null) {
      SnackbarHelper.showError(context, "Ne mogu obrisati – ID nedostaje.");
      return;
    }

    final ok = await _confirmDelete(context, n);
    if (!ok) return;

    try {
      await context.read<NotificationProvider>().delete(id);

      await paging.search(_searchCtrl.text.trim());

      if (mounted) {
        SnackbarHelper.showUpdate(context, "Obavijest obrisana.");
      }
    } catch (e) {
      if (mounted) SnackbarHelper.showError(context, e.toString());
    }
  }

  Future<void> _openAddNotificationDialog({
    required BuildContext context,
    required UniversalPagingProvider<NotificationModel> paging,
  }) async {
    final titleCtrl = TextEditingController();
    final messageCtrl = TextEditingController();

    bool saving = false;

    String? errTitle;
    String? errMessage;

    bool validate() {
      errTitle = null;
      errMessage = null;

      final t = titleCtrl.text.trim();
      final m = messageCtrl.text.trim();

      if (t.isEmpty) errTitle = "Naslov je obavezan.";
      else if (t.length < 3) errTitle = "Naslov mora imati bar 3 znaka.";
      else if (t.length > 60) errTitle = "Naslov može imati max 60 znakova.";

      if (m.isEmpty) errMessage = "Poruka je obavezna.";
      else if (m.length < 5) errMessage = "Poruka mora imati bar 5 znakova.";
      else if (m.length > 400) errMessage = "Poruka može imati max 400 znakova.";

      return errTitle == null && errMessage == null;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setStateDialog) {
          Future<void> save() async {
            if (saving) return;

            final ok = validate();
            setStateDialog(() {});
            if (!ok) return;

            setStateDialog(() => saving = true);
            try {
              final int? userId = Session.userId;

              if (userId == null) {
                SnackbarHelper.showError(
                  dialogCtx,
                  "UserId nije pronađen u sesiji.",
                );
                setStateDialog(() => saving = false);
                return;
              }

              final payload = {
                "userId": userId,
                "title": titleCtrl.text.trim(),
                "content": messageCtrl.text.trim(),
              };

              await dialogCtx.read<NotificationProvider>().insert(payload);

              await paging.search(_searchCtrl.text.trim());

              if (dialogCtx.mounted) {
                SnackbarHelper.showSuccess(
                  dialogCtx,
                  "Obavijest uspješno dodana.",
                );
                Navigator.pop(dialogCtx);
              }
            } catch (e) {
              if (dialogCtx.mounted) {
                SnackbarHelper.showError(dialogCtx, e.toString());
              }
            } finally {
              if (dialogCtx.mounted) {
                setStateDialog(() => saving = false);
              }
            }
          }

          final scrollCtrl = ScrollController();

          return BaseDialog(
            title: "Nova obavijest",
            width: 640,
            height: 520,
            onClose: () => Navigator.pop(dialogCtx),
            child: SizedBox(
              height: 520,
              child: Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      controller: scrollCtrl,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: scrollCtrl,
                        padding: const EdgeInsets.only(right: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Unesi naslov i poruku obavijesti.",
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF5A5A5A),
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: titleCtrl,
                              decoration: InputDecoration(
                                labelText: "Naslov",
                                filled: true,
                                fillColor: const Color(0xFFF7F7F7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorText: errTitle,
                              ),
                              onChanged: (_) => setStateDialog(() {}),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: messageCtrl,
                              maxLines: 6,
                              decoration: InputDecoration(
                                labelText: "Poruka",
                                alignLabelWithHint: true,
                                filled: true,
                                fillColor: const Color(0xFFF7F7F7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorText: errMessage,
                              ),
                              onChanged: (_) => setStateDialog(() {}),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed:
                              saving ? null : () => Navigator.pop(dialogCtx),
                          child: const Text("Odustani"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: saving ? null : save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF387EFF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: saving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Sačuvaj",
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _notificationRow({
    required BuildContext context,
    required UniversalPagingProvider<NotificationModel> paging,
    required NotificationModel n,
  }) {
    final author = _authorName(n);

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
          SizedBox(
            width: 170,
            child: Text(
              n.title.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2F2F2F),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            width: 1,
            height: 28,
            color: Colors.black.withOpacity(0.18),
          ),
          Expanded(
            child: Text(
              n.content.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3A3A),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ✅ autor + uloga
          SizedBox(
            width: 190, // malo veće da stane "Ime Prezime (Admin)"
            child: Text(
              author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Colors.black.withOpacity(0.65),
              ),
            ),
          ),

          const SizedBox(width: 10),
          IconButton(
            tooltip: "Obriši",
            onPressed: paging.isLoading
                ? null
                : () => _deleteNotification(
                      context: context,
                      paging: paging,
                      n: n,
                    ),
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 22,
              color: Colors.red.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pagingControls(UniversalPagingProvider<NotificationModel> paging) {
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UniversalPagingProvider<NotificationModel>>(
      create: (context) {
        final paging = UniversalPagingProvider<NotificationModel>(
          pageSize: 5,
          fetcher: ({
            required int page,
            required int pageSize,
            String? filter,
            bool includeTotalCount = true,
          }) {
            return context.read<NotificationProvider>().get(
              filter: {
                "page": page,
                "pageSize": pageSize,
                "includeTotalCount": includeTotalCount,
                if (filter != null && filter.trim().isNotEmpty)
                  "FTS": filter.trim(),
                "IncludeUser": true,
              },
            );
          },
        );

        Future.microtask(() => paging.loadPage());
        return paging;
      },
      child: Consumer<UniversalPagingProvider<NotificationModel>>(
        builder: (context, paging, _) {
          final Map<String, List<NotificationModel>> grouped = {};
          for (final n in paging.items) {
            final key = _dateKeyFromNotification(n);
            grouped.putIfAbsent(key, () => []);
            grouped[key]!.add(n);
          }

          final dates = grouped.keys.toList()
            ..sort((a, b) {
              DateTime parse(String s) {
                try {
                  final parts = s.split('.');
                  final d = int.parse(parts[0]);
                  final m = int.parse(parts[1]);
                  final y = int.parse(parts[2]);
                  return DateTime(y, m, d);
                } catch (_) {
                  return DateTime(1900);
                }
              }

              return parse(b).compareTo(parse(a));
            });

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
            child: Column(
              children: [
                const Text(
                  "Obavijesti",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: _searchDecoration(
                          controller: _searchCtrl,
                          onClear: () {
                            _searchCtrl.clear();
                            setState(() {});
                            paging.search("");
                          },
                        ),
                        onChanged: (v) {
                          setState(() {});
                          paging.search(v);
                        },
                      ),
                    ),
                    const SizedBox(width: 18),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () => _openAddNotificationDialog(
                          context: context,
                          paging: paging,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF387EFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          elevation: 0,
                        ),
                        child: const Text(
                          "NOVA OBAVIJEST",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
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
                              itemCount: dates.length,
                              itemBuilder: (context, i) {
                                final date = dates[i];
                                final list = grouped[date]!;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        bottom: 8,
                                        top: 8,
                                      ),
                                      child: Text(
                                        date,
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF6B6B6B),
                                        ),
                                      ),
                                    ),
                                    ...list.map((n) => _notificationRow(
                                          context: context,
                                          paging: paging,
                                          n: n,
                                        )),
                                  ],
                                );
                              },
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

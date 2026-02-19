import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gymify_desktop/dialogs/base_dialogs_frame.dart';
import 'package:gymify_desktop/models/user.dart';
import 'package:gymify_desktop/providers/user_provider.dart';

enum PickMode { user, trainer, admin, radnik }

Future<User?> showUserPickDialog({
  required BuildContext context,
  PickMode mode = PickMode.user,
  int pageSize = 5,
  double width = 560,
  double height = 520,
}) async {
  final ctrl = TextEditingController();

  int page = 0;
  int totalCount = 0;
  List<User> results = [];
  bool loading = false;

  String _titleByMode() {
    switch (mode) {
      case PickMode.user:
        return "Odaberi korisnika";
      case PickMode.trainer:
        return "Odaberi trenera";
      case PickMode.admin:
        return "Odaberi admina";
      case PickMode.radnik:
        return "Odaberi radnika";
    }
  }

  String _hintByMode() {
    switch (mode) {
      case PickMode.user:
        return "Kucaj ime ili prezime korisnika...";
      case PickMode.trainer:
        return "Kucaj ime ili prezime trenera...";
      case PickMode.admin:
        return "Kucaj ime ili prezime admina...";
      case PickMode.radnik:
        return "Kucaj ime ili prezime radnika...";
    }
  }

  Future<void> loadPage(
    BuildContext dialogCtx,
    StateSetter setState, {
    required int newPage,
  }) async {
    if (!dialogCtx.mounted) return;

    setState(() => loading = true);

    try {
      final q = ctrl.text.trim();

      final filter = <String, dynamic>{
        "page": newPage,
        "pageSize": pageSize,
        "includeTotalCount": true,
        if (q.isNotEmpty) "fullNameSearch": q,

        // ✅ filteri po ulozi
        if (mode == PickMode.user) "isUser": true,
        if (mode == PickMode.trainer) "isTrener": true,
        if (mode == PickMode.admin) "isAdmin": true,
        if (mode == PickMode.radnik) "isRadnik": true,
      };

      final res = await context.read<UserProvider>().get(filter: filter);

      if (!dialogCtx.mounted) return;

      setState(() {
        results = res.items;
        totalCount = res.totalCount;
        page = newPage;
        loading = false;
      });
    } catch (_) {
      if (!dialogCtx.mounted) return;
      setState(() => loading = false);
      rethrow;
    }
  }

  final picked = await showDialog<User>(
    context: context,
    barrierDismissible: false,
    builder: (dialogCtx) => StatefulBuilder(
      builder: (dialogCtx, setState) {
        Future.microtask(() {
          if (results.isEmpty && !loading) {
            loadPage(dialogCtx, setState, newPage: 0);
          }
        });

        final totalPages = (totalCount + pageSize - 1) ~/ pageSize;
        final hasPrev = page > 0;
        final hasNext = (page + 1) * pageSize < totalCount;

        return BaseDialog(
          title: _titleByMode(),
          width: width,
          height: height,
          onClose: () => Navigator.pop(dialogCtx),
          child: Column(
            children: [
              TextField(
                controller: ctrl,
                decoration: InputDecoration(
                  hintText: _hintByMode(),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (_) => loadPage(dialogCtx, setState, newPage: 0),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : results.isEmpty
                        ? const Center(child: Text("Nema rezultata."))
                        : ListView.separated(
                            itemCount: results.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (_, i) {
                              final u = results[i];
                              final name =
                                  "${u.firstName ?? ""} ${u.lastName ?? ""}"
                                      .trim();

                              return ListTile(
                                title: Text(name),
                                subtitle: Text(u.email ?? ""),
                                trailing: ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogCtx, u),
                                  child: const Text("Odaberi"),
                                ),
                              );
                            },
                          ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: (!loading && hasPrev)
                        ? () => loadPage(
                              dialogCtx,
                              setState,
                              newPage: page - 1,
                            )
                        : null,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    totalPages == 0 ? "0 / 0" : "${page + 1} / $totalPages",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    onPressed: (!loading && hasNext)
                        ? () => loadPage(
                              dialogCtx,
                              setState,
                              newPage: page + 1,
                            )
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );

  return picked;
}

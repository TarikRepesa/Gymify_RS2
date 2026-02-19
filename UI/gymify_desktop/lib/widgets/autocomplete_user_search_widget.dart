import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gymify_desktop/models/user.dart';

class UserAutocompleteField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  /// async poziv koji vraća listu usera
  final Future<List<User>> Function(String q) searcher;

  final void Function(User picked) onPicked;

  const UserAutocompleteField({
    super.key,
    required this.label,
    required this.controller,
    required this.searcher,
    required this.onPicked,
  });

  @override
  State<UserAutocompleteField> createState() => _UserAutocompleteFieldState();
}

class _UserAutocompleteFieldState extends State<UserAutocompleteField> {
  final FocusNode _focusNode = FocusNode();

  Timer? _debounce;
  bool _loading = false;

  List<User> _options = [];
  int _version = 0; // forsira rebuild Autocomplete kad options dođu

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final q = widget.controller.text.trim();

    // Ako nije fokusirano, nemoj prikazivati overlay
    if (!_focusNode.hasFocus) return;

    // min 2 slova
    if (q.length < 2) {
      setState(() {
        _options = [];
        _loading = false;
        _version++;
      });
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      setState(() => _loading = true);

      try {
        final res = await widget.searcher(q);
        if (!mounted) return;

        setState(() {
          _options = res;
          _loading = false;
          _version++;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _options = [];
          _loading = false;
          _version++;
        });
      }
    });
  }

  String _display(User u) =>
      "${u.firstName ?? ""} ${u.lastName ?? ""}".trim();

  @override
  Widget build(BuildContext context) {
    // _version se mijenja kad stignu opcije -> Autocomplete se rebuilda i overlay se osvježi
    return AnimatedBuilder(
      animation: Listenable.merge([widget.controller, _focusNode]),
      builder: (_, __) {
        return Autocomplete<User>(
          displayStringForOption: _display,
          optionsBuilder: (TextEditingValue value) {
            // MUST be sync
            final q = value.text.trim();
            if (q.length < 2) return const Iterable<User>.empty();
            return _options;
          },
          onSelected: (u) {
            widget.controller.text = _display(u);
            widget.onPicked(u);
          },
          fieldViewBuilder: (context, textCtrl, focusNode, onSubmit) {
            // koristimo naš focusNode (stabilan)
            return TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                labelText: widget.label,
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: _loading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const Icon(Icons.search),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            final list = options.toList();
            if (list.isEmpty) {
              return const SizedBox.shrink();
            }

            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240, maxWidth: 520),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final u = list[i];
                      return ListTile(
                        dense: true,
                        title: Text(_display(u)),
                        subtitle: Text(u.email ?? ""),
                        onTap: () => onSelected(u),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

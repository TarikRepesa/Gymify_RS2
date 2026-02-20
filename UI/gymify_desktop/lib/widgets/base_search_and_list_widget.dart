import 'package:flutter/material.dart';

class BaseColumn<T> {
  final String title;
  final int flex;
  final Widget Function(T item) cell;

  const BaseColumn({required this.title, required this.cell, this.flex = 1});
}

class BaseSearchAndTable<T> extends StatelessWidget {
  final String title;

  /// Top bar
  final String searchHint;
  final void Function(String value)? onSearchChanged;
  final VoidCallback? onClearSearch;

  final String? addButtonText;
  final VoidCallback? onAdd;

  /// Table
  final List<BaseColumn<T>> columns;
  final List<T> items;

  final void Function(T item)? onEdit;
  final void Function(T item)? onDelete;

  final EdgeInsets padding;

  final Widget? footer;

  final bool? isStatusMode;
  final String? editLabel;

  const BaseSearchAndTable({
    super.key,
    required this.title,
    required this.addButtonText,
    this.onAdd,
    required this.columns,
    required this.items,
    this.searchHint = "Pretraga",
    this.onSearchChanged,
    this.onClearSearch,
    this.onEdit,
    this.onDelete,
    this.footer,
    this.padding = const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
    bool? isLoading,
    this.isStatusMode,
    this.editLabel,
  });

  bool get _hasActions => onEdit != null || onDelete != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // TITLE
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 30),

          // SEARCH + BUTTON
          Row(
            children: [
              Expanded(
                child: _SearchBar(
                  hint: searchHint,
                  onChanged: onSearchChanged,
                  onClear: onClearSearch,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF387EFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    elevation: 0,
                  ),
                  child: Text(
                    addButtonText?.toUpperCase() ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // TABLE HEADER
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black26)),
            ),
            child: Row(
              children: [
                ...columns.map(
                  (c) => Expanded(
                    flex: c.flex,
                    child: Text(
                      c.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                if (_hasActions) ...[
                  Expanded(
                    flex: 1,
                    child: Text(
                      isStatusMode == true ? "Završiti" : "Uredi",
                    ),
                  ),
                  const Expanded(flex: 1, child: Text("Obriši")),
                ],
              ],
            ),
          ),

          // TABLE BODY
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      "Nema podataka.",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return _HoverRow(
                        child: Row(
                          children: [
                            ...columns.map(
                              (c) =>
                                  Expanded(flex: c.flex, child: c.cell(item)),
                            ),
                            if (_hasActions) ...[
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: onEdit == null
                                      ? null
                                      : () => onEdit!(item),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      isStatusMode == true
                                          ? Icons.sync_alt
                                          : Icons.edit_outlined,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: onDelete == null
                                      ? null
                                      : () => onDelete!(item),
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(Icons.delete_outline, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (footer != null) ...[const SizedBox(height: 16), footer!],
        ],
      ),
    );
  }
}

class _HoverRow extends StatefulWidget {
  final Widget child;
  const _HoverRow({required this.child});

  @override
  State<_HoverRow> createState() => _HoverRowState();
}

class _HoverRowState extends State<_HoverRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _hover ? Colors.black.withOpacity(0.03) : Colors.transparent,
          border: const Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: widget.child,
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final String hint;
  final void Function(String value)? onChanged;
  final VoidCallback? onClear;

  const _SearchBar({required this.hint, this.onChanged, this.onClear});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _ctrl,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hint,
                border: InputBorder.none,
              ),
            ),
          ),

          InkWell(
            onTap: () {
              _ctrl.clear();
              widget.onChanged?.call("");
              widget.onClear?.call();
              setState(() {});
            },
            child: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
    );
  }
}

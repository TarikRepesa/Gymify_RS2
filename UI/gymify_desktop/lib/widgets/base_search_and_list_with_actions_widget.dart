import 'package:flutter/material.dart';

class CustomTableColumn<T> {
  final String title;
  final int flex;
  final Widget Function(T item) cell;

  const CustomTableColumn({
    required this.title,
    required this.cell,
    this.flex = 1,
  });
}

class TableActionItem<T> {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;
  final bool isVisible;

  const TableActionItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
    this.isVisible = true,
  });
}

class BaseSearchAndActionsTable<T> extends StatelessWidget {
  final String title;

  /// Top bar
  final String searchHint;
  final void Function(String value)? onSearchChanged;
  final VoidCallback? onClearSearch;

  final String? addButtonText;
  final VoidCallback? onAdd;

  /// Table
  final List<CustomTableColumn<T>> columns;
  final List<T> items;

  /// Actions per row
  final List<TableActionItem<T>> Function(T item)? actionsBuilder;

  final EdgeInsets padding;
  final Widget? footer;
  final bool isLoading;
  final String emptyText;
  final int actionsFlex;

  const BaseSearchAndActionsTable({
    super.key,
    required this.title,
    required this.columns,
    required this.items,
    this.actionsBuilder,
    this.searchHint = "Pretraga",
    this.onSearchChanged,
    this.onClearSearch,
    this.addButtonText,
    this.onAdd,
    this.padding = const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
    this.footer,
    this.isLoading = false,
    this.emptyText = "Nema podataka.",
    this.actionsFlex = 3,
  });

  bool get _hasActions => actionsBuilder != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: _SearchBar(
                  hint: searchHint,
                  onChanged: onSearchChanged,
                  onClear: onClearSearch,
                ),
              ),
              if (addButtonText != null && addButtonText!.trim().isNotEmpty) ...[
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
                      addButtonText!.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 30),

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
                if (_hasActions)
                  Expanded(
                    flex: actionsFlex,
                    child: const Text(
                      "Akcije",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                    ? Center(
                        child: Text(
                          emptyText,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];

                          final actions = actionsBuilder == null
                              ? <TableActionItem<T>>[]
                              : actionsBuilder!(item)
                                    .where((a) => a.isVisible)
                                    .toList();

                          return _HoverRow(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ...columns.map(
                                  (c) => Expanded(
                                    flex: c.flex,
                                    child: c.cell(item),
                                  ),
                                ),
                                if (_hasActions)
                                  Expanded(
                                    flex: actionsFlex,
                                    child: Wrap(
                                      spacing: 10,
                                      runSpacing: 8,
                                      children: actions
                                          .map(
                                            (action) => _ActionButton(
                                              label: action.label,
                                              icon: action.icon,
                                              color: action.color,
                                              onTap: action.onTap,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
          ),

          if (footer != null) ...[
            const SizedBox(height: 16),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? const Color(0xFF374151);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(color: resolvedColor.withOpacity(0.25)),
          borderRadius: BorderRadius.circular(8),
          color: resolvedColor.withOpacity(0.06),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: resolvedColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: resolvedColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
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

  const _SearchBar({
    required this.hint,
    this.onChanged,
    this.onClear,
  });

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
// utils/widgets/dropdowns/searchable_dropdown.dart
import 'package:flutter/material.dart';

class CustomSearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String Function(T item) displayString;
  final String? hintText;
  final String? searchHint;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final bool isExpanded;

  const CustomSearchableDropdown({
    super.key,
    required this.items,
    required this.displayString,
    this.value,
    this.hintText,
    this.searchHint,
    this.onChanged,
    this.validator,
    this.isExpanded = true,
  });

  @override
  _CustomSearchableDropdownState<T> createState() => _CustomSearchableDropdownState<T>();
}

class _CustomSearchableDropdownState<T> extends State<CustomSearchableDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: widget.searchHint ?? 'Search...',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterList('');
                          },
                        ),
                      ),
                      onChanged: _filterList,
                    ),
                  ),
                  Expanded(
                    child: _filteredItems.isEmpty
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No results found'),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return ListTile(
                          title: Text(widget.displayString(item)),
                          onTap: () {
                            widget.onChanged?.call(item);
                            _searchController.clear();
                            _focusNode.unfocus();
                            _removeOverlay();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchController.clear();
    _filteredItems = widget.items;
  }

  void _filterList(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          final display = widget.displayString(item).toLowerCase();
          return display.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _clearSelection() {
    widget.onChanged?.call(null);
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: FormField<T>(
        validator: widget.validator,
        builder: (FormFieldState<T> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (!_focusNode.hasFocus) {
                    _focusNode.requestFocus();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: field.hasError ? Colors.red : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Row(
                    children: [
                      if (widget.isExpanded)
                        Expanded(
                          child: Text(
                            widget.value != null
                                ? widget.displayString(widget.value!)
                                : widget.hintText ?? 'Select an option',
                            style: TextStyle(
                              color: widget.value != null ? Colors.black : Colors.grey,
                            ),
                          ),
                        )
                      else
                        Text(
                          widget.value != null
                              ? widget.displayString(widget.value!)
                              : widget.hintText ?? 'Select an option',
                          style: TextStyle(
                            color: widget.value != null ? Colors.black : Colors.grey,
                          ),
                        ),
                      if (widget.value != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: _clearSelection,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8),
                  child: Text(
                    field.errorText!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
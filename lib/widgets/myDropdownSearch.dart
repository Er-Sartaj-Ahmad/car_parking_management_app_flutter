import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class MyDropdownSearch extends StatelessWidget {
  final bool showSelectedItems;
  final Function(String?) onChanged;
  final List<String> items;
  final String? errorText;
  final String? labelText;
  final String? hintText;
  final String? selectedItem;
  final double? width;
  MyDropdownSearch({
    this.showSelectedItems = true,
    required this.onChanged,
    required this.items,
    required this.errorText,
    required this.selectedItem,
    required this.labelText,
    required this.hintText,
    this.width = double.infinity
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        width: width,
        child: DropdownSearch<String>(
            mode: Mode.MENU,
            showSelectedItems: showSelectedItems,
            items: items,
            showSearchBox: true,
            dropdownSearchDecoration: InputDecoration(
              errorText: errorText,
              border: OutlineInputBorder(),
              labelText: labelText,
              hintText: hintText,
            ),
            // popupItemDisabled: (String s) => s.startsWith('I'),
            onChanged: onChanged,
            selectedItem: selectedItem),
      ),
    );
  }
}
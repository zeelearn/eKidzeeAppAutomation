import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  DropdownWidget({
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

import 'package:ekidzee/widget/dropdown_widget.dart';
import 'package:flutter/material.dart';

Widget homwworkDropDown<T>(
  selectedValue,
  Function(T?) onChanged,
  List<T> options,
  String? Function(T) getLabel, {
  String? hint,
  required TextEditingController textEditingController,
}) {
  //debugPrint('Data type is - ${options.isNotEmpty ? options[0].runtimeType : options.runtimeType}  and data lenght is - ${options.length}');
  return DropDownWidget<T>(
    title: hint ?? 'Select ',
    textController: textEditingController,
    readOnly: true,
    hintText: hint ?? 'Select ',
    // enable: false,
    items: options,
    // readOnly: true,
    displayFunction: (value) => getLabel(value) ?? '',
    onChanged: (p0) => onChanged(p0),
  );
  /* return DropdownSearch<T>(
    items: (filter, loadProps) => options,
    selectedItem: selectedValue,
    // dropdownDecoratorProps: DropDownDecoratorProps(
    //   dropdownSearchDecoration: InputDecoration(
    //     isDense: true,
    //     contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    //     border: const OutlineInputBorder(
    //       borderRadius: BorderRadius.zero,
    //     ),
    //     focusedBorder:  OutlineInputBorder(
    //       borderRadius: BorderRadius.zero,
    //       borderSide: BorderSide(color: kPrimaryLightColor),
    //     ),
    //     hintText: hint ?? 'Select value',
    //     hintStyle: LightColors.hintTextStyle,
    //   ),
    // ),
    popupProps: PopupProps.menu(
      showSearchBox: true,
      searchFieldProps: TextFieldProps(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: LightColors.hintTextStyle,
          border: OutlineInputBorder(),
        ),
      ),
      itemBuilder: (context, t, item, isSelected) => ListTile(
        title: Text(getLabel(t), style: LightColors.hintTextStyle),
      ),
    ),
    onChanged: onChanged,
    dropdownBuilder: (context, selectedItem) => Text(
      selectedItem != null ? getLabel(selectedItem) : '',
      style: LightColors.hintTextStyle,
    ),
  ); */
  /* return DropdownButtonFormField<T>(
    value: selectedValue,
    icon: Icon(
      Icons.arrow_drop_down,
      color: Colors.black,
    ),
    decoration: InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero, // Square border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero, // Square border when focused
        borderSide: BorderSide(color: kPrimaryLightColor),
      ),
    ),
    elevation: 16,
    borderRadius: BorderRadius.circular(10),
    style: TextStyle(color: Colors.black),
    /* underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ), */
    onChanged: onChanged,
    hint: Text(
      hint ?? 'Select value',
      style: LightColors.smallTextStyle,
    ),
    items: options.map<DropdownMenuItem<T>>((value) {
      return DropdownMenuItem<T>(
        value: value,
        child: Text(
          getLabel(value),
          style: LightColors.smallTextStyle,
        ),
      );
    }).toList(),
  ); */
}

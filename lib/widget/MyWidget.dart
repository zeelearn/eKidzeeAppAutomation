import 'package:ekidzee/constants.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../helper/LightColor.dart';
import '../helper/utils.dart';
import '../utils/theme/colors/light_colors.dart';

class MyWidget {
  static InputDecoration getInputDecoratino(String value) {
    return InputDecoration(
      fillColor: Colors.white,
      border: InputBorder.none,
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.blue)),
      filled: true,
      contentPadding:
          const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      labelText: value,
    );
  }

  Widget emailTextField(Size size, TextEditingController controller) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 11,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: const Color(0xFFEFEFEF),
        ),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'Email/ Phone number',
            labelStyle: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF969AA8),
            ),
            border: InputBorder.none),
      ),
    );
  }

  EdgeInsets getTextPadding() {
    return const EdgeInsets.only(left: 15, right: 15);
  }

  Widget richText(String value, TextStyle style) {
    return Text(
      value,
      style: style,
    );
    /*return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.left,
    );*/
  }

  Widget getButton(String label, onClickListener listener) {
    return ElevatedButton(
        onPressed: () {
          listener.onClick(Utility.ACTION_OK, 'submit');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryLightColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4.0,
        ),
        child: Text(label,
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              height: 1,
            )));
  }

  Widget normalTextField(
      BuildContext context, String label, TextEditingController controller) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 10,
      padding: getTextPadding(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: LightColors.kLightGrayM,
        border: Border.all(
          width: 1.0,
          color: LightColors.kLightGrayM,
        ),
      ),
      child: TextField(
        controller: controller,
        style: LightColors.textStyle,
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            hintText: label,
            fillColor: LightColors.kLightGrayM,
            border: InputBorder.none),
      ),
    );
  }

  Widget normalText(
      BuildContext context, String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: LightColors.textStyle,
      maxLines: 1,
      cursorColor: const Color(0xFF15224F),
      decoration: InputDecoration(
          hintText: label,
          //fillColor: LightColors.kLightGrayM,
          border: InputBorder.none),
    );
  }

  Widget normalTextAreaField(
      BuildContext context, String label, TextEditingController controller,
      {int? maxLength}) {
    return TextField(
      controller: controller,
      style: LightColors.textStyle,
      maxLines: 4,
      cursorColor: kPrimaryLightColor,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: LightColor.lightGrey,
            width: 1.0,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: LightColor.lightGrey,
            width: 1.0,
          ),
        ),

        // counterText: "", // Optional: hides maxLength counter if needed
      ),
    );
  }

  SizedBox getDateTime(BuildContext context, String label,
      TextEditingController controller, DateTime minDate, DateTime maxDate,
      {Color? prefixIconColor, Function()? onDateSelected, bool? enable}) {
    return SizedBox(
        height: 50,
        child: TextField(
            style: LightColors.textSmallStyle,
            controller: controller,
            //editing controller of this TextField
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: SizedBox(
                    height: 14.0,
                    width: 14.0,
                    child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      color: LightColors.kLightBlueMaterial,
                      icon: Icon(
                        Icons.calendar_today,
                        size: 18.0,
                        color: prefixIconColor ?? kPrimaryLightColor,
                      ),
                      onPressed: () {},
                    )),
                label: Text(label),
                contentPadding: EdgeInsets.zero,
                fillColor: LightColors.kLightGray1,
                hintText: label //label text of field
                ),
            readOnly: true,
            enabled: enable ?? true,
            //set it true, so that user will not able to edit text
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate:
                      onDateSelected != null ? minDate : DateTime.now(),
                  firstDate: minDate,
                  //DateTime.now() - not to allow to choose before today.
                  lastDate: maxDate);

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('dd-MMM-yyyy').format(pickedDate);
                controller.text = formattedDate;
                if (onDateSelected != null) {
                  onDateSelected();
                }
              }
            }));
  }

  SizedBox getDateTimePicker(BuildContext context, String label,
      TextEditingController controller, DateTime minDate, DateTime maxDate,
      {Color? prefixIconColor, bool? isFloating, bool? isEnable}) {
    return SizedBox(
        height: 40,
        child: TextField(
            enabled: isEnable ?? true,
            style: LightColors.textSmallStyle,
            controller: controller,
            //editing controller of this TextField
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: SizedBox(
                    height: 14.0,
                    width: 14.0,
                    child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      color: prefixIconColor ?? LightColors.kLightBlueMaterial,
                      icon: const Icon(Icons.calendar_today, size: 18.0),
                      onPressed: () {},
                    )),
                label: isFloating != null ? Text(label) : null,
                contentPadding: EdgeInsets.zero,
                fillColor: isEnable != null && isEnable
                    ? LightColors.kLightGray
                    : LightColors.kLightGray1,
                hintText: label //label text of field
                ),
            readOnly: true,
            //set it true, so that user will not able to edit text
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: minDate,
                  //DateTime.now() - not to allow to choose before today.
                  lastDate: maxDate);

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                controller.text = formattedDate;
              }
            }));
  }

  TextField getTime(BuildContext context, String label,
      TextEditingController controller, DateTime minDate, DateTime maxDate) {
    return TextField(
        style: const TextStyle(color: Colors.black),
        controller: controller,
        //editing controller of this TextField
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: LightColors.kLavender)),
            icon: const Icon(Icons.timer), //icon of text field
            labelText: label //label text of field
            ),
        readOnly: true,
        //set it true, so that user will not able to edit text
        onTap: () async {});
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      controller.text = '${timeOfDay.hour}:${timeOfDay.minute}';
    }
  }

  EdgeInsets MyButtonPadding() {
    return const EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10);
  }

  InputDecoration getInputDecoration(String hint) {
    return InputDecoration(
      labelText: hint,
      floatingLabelStyle: TextStyle(color: kPrimaryLightColor),
      counterText: "",
      helperStyle: TextStyle(color: kPrimaryLightColor),
      hoverColor: Colors.grey.shade300,
      // focusColor: kPrimaryLightColor,
      border: InputBorder.none,
      filled: true,
      suffixIcon: hint.contains('search') ? const Icon(Icons.search) : null,
      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kPrimaryLightColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2.0),
        borderSide: const BorderSide(
          color: LightColors.kLightGray,
          width: 1.0,
        ),
      ),
    );
  }

  Widget getDropdown(String title, String chosenValue, List<String> options,
      int action, onClickListener listener) {
    //debugPrint('chosse val $chosenValue');
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200, // background color
        hoverColor: Colors.grey.shade300,
        suffixIconColor: kPrimaryLightColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),

      icon: const Icon(Icons.keyboard_arrow_down),
      focusColor: Colors.grey.shade300,
      dropdownColor: Colors.grey.shade50,
      autofocus: false,
      elevation: 15,
      //underline: null,
      initialValue: chosenValue,
      //elevation: 5,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Center(
            child: Text(
              value,
              style: LightColors.textHeaderStyle13,
            ),
          ),
        );
      }).toList(),
      hint: Text(
        title,
        style: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onChanged: (value) {
        chosenValue = value!;
        listener.onClick(action, value);
      },
    );
  }
  // Widget getDropdown(String title, String chosenValue, List<String> options,
  //     int action, onClickListener listener) {
  //   return Container(
  //       height: 40,
  //       margin: const EdgeInsets.all(2),
  //       padding: const EdgeInsets.all(2),
  //       decoration: const BoxDecoration(
  //         color: LightColors.kLightGray,
  //         borderRadius: BorderRadius.all(Radius.circular(10)),
  //       ),
  //       //color: LightColors.kLightGray,
  //       /*child: InputDecorator(
  //     decoration: InputDecoration(
  //       fillColor: Colors.white60,
  //       labelText: title,
  //       labelStyle: LightColors.textSmallStyle,
  //       border: const OutlineInputBorder(),
  //     ),*/
  //       child: Center(
  //           child: DropdownButtonHideUnderline(
  //         child: DropdownButton(
  //           style: LightColors.textSmallStyle,
  //           isExpanded: true,
  //           isDense: true,
  //           alignment: Alignment.center,
  //           // Reduces the dropdowns height by +/- 50%
  //           //icon: Icon(Icons.keyboard_arrow_down),
  //           value: chosenValue,
  //           items: options.map((item) {
  //             return DropdownMenuItem(
  //               alignment: Alignment.center,
  //               value: item,
  //               child: Text(item),
  //             );
  //           }).toList(),
  //           onChanged: (value) {
  //             chosenValue = value as String;
  //             listener.onClick(action, value);
  //           },
  //         ),
  //         //),
  //       )));
  // }

  Widget getFilter(String title, String chosenValue, List<String> options,
      int action, onClickListener listener) {
    return Container(
        height: 40,
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: LightColors.kLightGray,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
            child: DropdownButtonHideUnderline(
          child: DropdownButton(
            style: LightColors.textSmallStyle,
            isExpanded: true,
            isDense: true,
            alignment: Alignment.center,
            // Reduces the dropdowns height by +/- 50%
            //icon: Icon(Icons.keyboard_arrow_down),
            value: chosenValue,
            items: options.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) {
              chosenValue = value as String;
              listener.onClick(action, value);
            },
          ),
          //),
        )));
  }

  Widget getDropdownButton(String title, String chosenValue,
      List<String> options, int action, onClickListener listener) {
    //debugPrint('chosse val $chosenValue');
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200, // background color
        hoverColor: Colors.grey.shade300,
        suffixIconColor: kPrimaryLightColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),

      icon: const Icon(Icons.keyboard_arrow_down),
      focusColor: Colors.grey.shade300,
      dropdownColor: Colors.grey.shade50,
      autofocus: false,
      elevation: 15,
      //underline: null,
      initialValue: chosenValue,
      //elevation: 5,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Center(
            child: Text(
              value,
              style: LightColors.textHeaderStyle13,
            ),
          ),
        );
      }).toList(),
      hint: Text(
        title,
        style: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onChanged: (value) {
        chosenValue = value!;
        listener.onClick(action, value);
      },
    );
  }

  static Widget textRow(String textOne, String textTwo) {
    return Wrap(
      children: [
        Text(
          "$textOne:",
          style: const TextStyle(
            color: Color.fromRGBO(74, 77, 84, 0.7),
            fontSize: 14.0,
          ),
        ),
        const SizedBox(
          width: 4.0,
        ),
        Text(
          textTwo,
          style: const TextStyle(
            color: Color.fromRGBO(19, 22, 33, 1),
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  static Widget textWidget(String title, Widget widget) {
    return Wrap(
      children: [
        Text(
          "$title:",
          style: const TextStyle(
            color: Color.fromRGBO(74, 77, 84, 0.7),
            fontSize: 14.0,
          ),
        ),
        const SizedBox(
          width: 4.0,
        ),
        widget
      ],
    );
  }
}

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../iface/onClick.dart';
import '../utils/theme/colors/light_colors.dart';
import '../widget/image_viewer.dart';

/// This dialog will basically show up right on top of the webview.
///
/// AlertDialog is a widget, so it needs to be wrapped in `WebViewAware`, in order
/// to be able to interact (on web) with it.
///
/// Read the `Readme.md` for more info.
void showAlertDialog(String content, BuildContext context) {
  /*showDialog(
    context: context,
    builder: (_) => WebViewAware(
      child: AlertDialog(
        content: Text(content),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Close'),
          ),
        ],
      ),
    ),
  );*/
}

void makePhoneCall(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
Future<String> getUniqueDeviceId() async {
  String uniqueDeviceId = '';

  var deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    uniqueDeviceId = '${iosDeviceInfo.identifierForVendor}'; // unique ID on iOS
  } else if(Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    uniqueDeviceId = '${androidDeviceInfo.id}' ; // unique ID on Android
  }
  return uniqueDeviceId;
}


void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(seconds: 1),
      ),
    );
}

Widget createButton({
  VoidCallback? onTap,
  required String text,
}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    ),
    child: Text(text),
  );
}

Widget buildTextField(
    GlobalKey<FormState> key,
    TextEditingController controller,
    String hintText,
    IconData icon,
    size,
    double width,
    bool isDarkMode,

    ) {
  return Padding(
    padding: EdgeInsets.only(top: size.height * 0.025),
    child: Container(
      width: width,
      height: size.height * 0.06,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : const Color(0xffF7F8F8),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Form(
        key: key,
        child: TextFormField(
          controller: controller,
          inputFormatters: [
            FilteringTextInputFormatter.deny(
                RegExp(r'\s')),
          ],
          style: LightColors.textHeaderStyle13,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            errorStyle: const TextStyle(height: 0),
            hintStyle: const TextStyle(
              color: Color(0xffADA4A5),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(
              top: 10,
            ),
            hintText: hintText,
            prefixIcon: SizedBox(width: 14,height: 14,
            child: Icon(
              icon,
              color: const Color(0xff7B6F72),
            )),
          ),
        ),
      ),
    ),
  );
}

Widget buildTextAreaField(
    GlobalKey<FormState> key,
    TextEditingController controller,
    String hintText,
    IconData icon,
    size,
    double width,
    bool isDarkMode,

    ) {
  return Padding(
    padding: EdgeInsets.only(top: size.height * 0.025,bottom: 15),
    child: Container(
      width: width,
      height: size.height * 0.1,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : const Color(0xffF7F8F8),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Form(
        key: key,
        child: TextFormField(
          maxLines: 4,
          controller: controller,
          inputFormatters: [
            FilteringTextInputFormatter.deny(
                RegExp(r'\s')),
          ],
          style: LightColors.textHeaderStyle13,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            fillColor: const Color(0xffF7F8F8),
            errorStyle: const TextStyle(height: 0),
            hintStyle: const TextStyle(
              color: Color(0xffADA4A5),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(
              top: 10,
            ),
            hintText: hintText,
            prefixIcon: SizedBox(width: 14,height: 14,
            child: Icon(
              icon,
              color: const Color(0xff7B6F72),
            )),
          ),
        ),
      ),
    ),
  );
}

DateTime minDate = DateTime(DateTime.now().year, DateTime.now().month - 3, 1);
DateTime maxDate = DateTime(DateTime.now().year, DateTime.now().month + 3, 1);

Widget buildDateTimeTextField(
    BuildContext context,
    GlobalKey<FormState> key,
    TextEditingController controller,
    String hintText,
    IconData icon,
    size,
    double width,
    bool isDarkMode,
    onClickListener listener,

    ) {
  return Padding(
    padding: EdgeInsets.only(top: size.height * 0.025),
    child: Container(
      width: width,
      height: size.height * 0.06,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : const Color(0xffF9F9F9),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Form(
        key: key,
        child: TextFormField(

          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: minDate,
                //DateTime.now() - not to allow to choose before today.
                lastDate: maxDate);

            if (pickedDate != null) {
              String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
              controller.text = formattedDate;
            }

          },
          controller: controller,
          inputFormatters: [
            FilteringTextInputFormatter.deny(
                RegExp(r'\s')),
          ],
          style: LightColors.textHeaderStyle13,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            errorStyle: const TextStyle(height: 0),
            hintStyle: const TextStyle(
              color: Color(0xffADA4A5),
            ),
            border: InputBorder.none,
            fillColor: const Color(0xffF7F8F8),
            contentPadding: EdgeInsets.only(
              top: 10,
            ),
            hintText: hintText,
            prefixIcon: SizedBox(width: 14,height: 14,
            child: Icon(
              icon,
              color: const Color(0xff7B6F72),
            )),
          ),
        ),
      ),
    ),
  );
}

Widget getTextField(GlobalKey<FormState> key,TextEditingController controller,String hint,IconData icon,Size size,double width){
  return Form(
    child: buildTextField(
        key,
        controller,
        hint,
        icon,
        size,
        width,
        false,
    ),
  );
}

Widget getTextAreaField(GlobalKey<FormState> key,TextEditingController controller,String hint,IconData icon,Size size,double width){
  return Form(
    child: buildTextAreaField(
        key,
        controller,
        hint,
        icon,
        size,
        width,
        false,
    ),
  );
}

Widget getDateTimeTextField(BuildContext context,GlobalKey<FormState> key,TextEditingController controller,String hint,IconData icon,Size size,double width,onClickListener listener){
  return Form(
    child: buildDateTimeTextField(
      context,
        key,
        controller,
        hint,
        icon,
        size,
        width,
        false,
        listener
    ),
  );
}

Widget getDropdownField(GlobalKey<FormState> key,String title,String hint,List<String> options,onClickListener listener,Size size,double width, int action){
  return Form(
    child: buildDropdownField(
        key,
        title,
        hint,
      options,
      listener,
        size,
        width,
        false,action
    ),
  );
}

Widget buildDropdownField(
    GlobalKey<FormState> key,
    String title,
    String label,
    List<String> options,
    onClickListener listener,
    Size size,
    double width,
    bool isDark,int action
    ) {
  return Padding(
    padding: EdgeInsets.only(top: size.height * 0.025),
    child: Container(
      width: width,
      height: size.height * 0.06,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : const Color(0xffF9F9F9),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Form(
        key: key,
        child: getDropdownButton(title,label, options, action, listener),
      ),
    ),
  );
}

Widget getDropdownButton(String title, String _chosenValue,
    List<String> options, int action, onClickListener listener) {
  return Padding(padding: EdgeInsets.only(left: 5,right: 5),
  child: DropdownButton<String>(
    isExpanded: true,
    icon: Icon(Icons.keyboard_arrow_down),
    focusColor: Colors.white,
    value: _chosenValue,
    underline: Container(),
    style: TextStyle(color: Colors.white),
    iconEnabledColor: Colors.black,
    items: options.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: LightColors.textHeaderStyle13,
        ),
      );
    }).toList(),
    hint: Text(
      title,
      style: TextStyle(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
    ),
    onChanged: (value) {
      _chosenValue = value!;
      listener.onClick(action, value);
    },
  ),);

  viewImage(BuildContext context,String url) async{
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageViewer(imageUrl: url);
    }));
  }
}
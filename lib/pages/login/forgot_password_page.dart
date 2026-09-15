import 'package:ekidzee/api/request/forgotpassword_request.dart';
import 'package:ekidzee/api/response/pentemind/GenericResponse.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api/APIService.dart';
import '../../widget/button_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    implements onClickListener {
  String userName = '';
  bool isLoader = false;
  final _emailKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: isLoader
            ? Utility.showLoader()
            : Container(
                height: size.height,
                width: size.height,
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xff151f2c) : Colors.white,
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.width * 0.025,
                                  horizontal: size.width * 0.025),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.pop(
                                        context), //go back to authPage
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      size: size.height * 0.03,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.015,
                                    ),
                                    child: Text(
                                      'Back',
                                      style: GoogleFonts.poppins(
                                        color: isDarkMode
                                            ? Colors.white
                                            : const Color(0xff1D1617),
                                        fontSize: size.height * 0.018,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: size.height * 0.05,
                                left: size.width * 0.055,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Recover password',
                                  style: GoogleFonts.poppins(
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(0xff1D1617),
                                    fontSize: size.height * 0.035,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.055),
                              child: Align(
                                child: Text(
                                  "Forgot your password? That's okay, it happens to everyone!\nPlease provide your UserName to recover your password on your registered mobile number.",
                                  style: GoogleFonts.poppins(
                                    color: isDarkMode
                                        ? Colors.white54
                                        : Colors.black54,
                                    fontSize: size.height * 0.02,
                                  ),
                                ),
                              ),
                            ),
                            Form(
                              child: buildTextField(
                                "User Name",
                                Icons.email_outlined,
                                false,
                                size,
                                (valuemail) {
                                  if (valuemail.length < 5) {
                                    buildSnackError(
                                      'Invalid User Name ',
                                      context,
                                      size,
                                    );
                                    return '';
                                  }
                                  if (!RegExp(
                                          "^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]{3,12}")
                                      .hasMatch(valuemail)) {
                                    buildSnackError(
                                      'Invalid User Name',
                                      context,
                                      size,
                                    );
                                    return '';
                                  }
                                  return null;
                                },
                                isDarkMode,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: size.height * 0.025),
                              child: ButtonWidget(
                                  text: 'Send Instruction',
                                  backColor: isDarkMode
                                      ? [
                                          Colors.black,
                                          Colors.black,
                                        ]
                                      : [
                                          kPrimaryLightColor,
                                          kPrimaryLightColor
                                        ],
                                  textColor: const [
                                    Colors.white,
                                    Colors.white,
                                  ],
                                  onPressed: () async {
                                    if (_emailKey.currentState!.validate()) {
                                      recoverPassword();
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void recoverPassword() async {
    if (userName.isNotEmpty) {
      setState(() {
        isLoader = true;
      });
      //Utility.showLoader();
      ForgotPasswordRequest request =
          ForgotPasswordRequest(User_Name: userName);
      APIService apiService = APIService();
      apiService.forgotPassword(request).then((value) {
        if (value != null) {
          GenericResponse response = value as GenericResponse;
          //Navigator.of(context, rootNavigator: true).pop('dialog');
          if (response.response[0].response.toString().contains('Invalid')) {
            Utility.alert(context, 'Alert ',
                response.response[0].response.toString(), this);
          } else {
            Utility.smsSendMessage(context, 'Success ',
                response.response[0].response.toString(), this);
          }
        } else {
          //Navigator.of(context, rootNavigator: true).pop('dialog');
          Utility.showMessages(context, 'Invalid User Name and Password');
        }
        setState(() {
          isLoader = false;
        });
        ////debugPrint('Captured in Listener value is null' );
      });
    } else {
      //Navigator.of(context, rootNavigator: true).pop('dialog');
      userName = '';
      Utility.showMessage(context, "Please Enter Valid User Name");
      setState(() {
        isLoader = false;
      });
    }
  }

  bool pwVisible = false;
  Widget buildTextField(
    String hintText,
    IconData icon,
    bool password,
    size,
    FormFieldValidator validator,
    bool isDarkMode,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.025),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.06,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : const Color(0xffF7F8F8),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Form(
          key: _emailKey,
          child: TextFormField(
            style: TextStyle(
                color: isDarkMode ? const Color(0xffADA4A5) : Colors.black),
            onChanged: (value) {
              setState(() {
                userName = value;
              });
            },
            validator: validator,
            textInputAction: TextInputAction.next,
            obscureText: password ? !pwVisible : false,
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TextStyle(
                color: Color(0xffADA4A5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: size.height * 0.02,
              ),
              hintText: hintText,
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.005,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xff7B6F72),
                ),
              ),
              suffixIcon: password
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.005,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            pwVisible = !pwVisible;
                          });
                        },
                        child: pwVisible
                            ? const Icon(
                                Icons.visibility_off_outlined,
                                color: Color(0xff7B6F72),
                              )
                            : const Icon(
                                Icons.visibility_outlined,
                                color: Color(0xff7B6F72),
                              ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackError(
      String error, context, size) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error),
          ),
        ),
      ),
    );
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_OK) {
      if (value == 'Alert') {
      } else
        Navigator.pop(context);
    }
  }
}

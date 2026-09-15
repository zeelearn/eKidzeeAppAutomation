import 'package:ekidzee/api/request/otp_authrequest.dart';
import 'package:ekidzee/api/request/otp_request.dart';
import 'package:ekidzee/helper/helpers.dart';
import 'package:ekidzee/pages/intro/splash.dart';
import 'package:ekidzee/pages/login/ui2/login.dart';
import 'package:flutter/material.dart';

import '../../api/APIService.dart';
import '../../api/response/opt_auth_response.dart';
import '../../helper/KidzeePref.dart';
import '../../helper/LocalConstant.dart';
import '../../helper/utils.dart';

class Otp extends StatefulWidget {
  String mobileNumber;
  String userName;

  Otp({Key? key, required this.mobileNumber, required this.userName})
      : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  bool isApiCallProcess = false;
  final _otp1 = TextEditingController();
  final _otp2 = TextEditingController();
  final _otp3 = TextEditingController();
  final _otp4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreenV2()));
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/otp_background.png',
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 28,
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _textFieldOTP(
                            first: true, last: false, mycontroller: _otp1),
                        _textFieldOTP(
                            first: false, last: false, mycontroller: _otp2),
                        _textFieldOTP(
                            first: false, last: false, mycontroller: _otp3),
                        _textFieldOTP(
                            first: false, last: true, mycontroller: _otp4),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          verifyOtp();
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.blueAccent),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            'Verify',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 18,
              ),
              GestureDetector(
                onTap: () {
                  sendOtp();
                },
                child: const Text(
                  "Resend New Code",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendOtp() {
    Utility.showLoaderDialog(context);
    OtpRequest request =
        OtpRequest(Mode: 'Request', MobileNo: widget.mobileNumber);
    APIService apiService = APIService();
    apiService.getOtp(request).then((value) {
      if (value != null) {
        setState(() {
          isApiCallProcess = false;
        });
        Navigator.pop(context);
        if (value == 'Status1') {
          showAlertDialog(value, context);
          //KidzeePref().setString(LocalConstant.KEY_IS_OTP_VERIFIED, 'false' as String);
        } else {
          //valid OTP
          showAlertDialog(value, context);
        }
      } else {
        Navigator.pop(context);
        Utility.showMessage(context, "Invalid User Name and Password");
        //debugPrint("null value");
      }
    });
  }

  void verifyOtp() {
    if (isValid()) {
      Utility.showLoaderDialog(context);
      String otp = _otp1.text.toString() +
          _otp2.text.toString() +
          _otp3.text.toString() +
          _otp4.text.toString();
      OtpAuthRequest request =
          OtpAuthRequest(User_Name: widget.mobileNumber, Otp: otp);
      APIService apiService = APIService();
      apiService.validateOTP(request).then((value) {
        if (value != null) {
          setState(() {
            isApiCallProcess = false;
          });
          OTPAuthResponse info = value;
          Navigator.pop(context);
          if (info.Msg == 'Invalid OTP Or OTP has Expired') {
            showAlertDialog(info.Msg, context);
            KidzeePref().setString(LocalConstant.KEY_IS_OTP_VERIFIED, 'false');
          } else {
            //valid OTP
            KidzeePref().setString(LocalConstant.KEY_IS_OTP_VERIFIED, 'true');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SplashScreen()),
            );
          }
        } else {
          KidzeePref().setString(LocalConstant.KEY_IS_OTP_VERIFIED, 'true');
          Navigator.pop(context);
          Utility.showMessage(context, "Invalid User Name and Password");
          //debugPrint("null value");
        }
      });
    }
  }

  bool isValid() {
    bool isValid = true;
    if (_otp1.text.isEmpty) {
      isValid = false;
      showAlertDialog('Please Enter the valid OTP', context);
    } else if (_otp2.text.isEmpty) {
      isValid = false;
      showAlertDialog('Please Enter the valid OTP', context);
    } else if (_otp3.text.isEmpty) {
      isValid = false;
      showAlertDialog('Please Enter the valid OTP', context);
    } else if (_otp4.text.isEmpty) {
      isValid = false;
      showAlertDialog('Please Enter the valid OTP', context);
    }
    return isValid;
  }

  Widget _textFieldOTP(
      {required bool first,
      last,
      required TextEditingController mycontroller}) {
    return Container(
      height: 55,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: mycontroller,
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.redAccent),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}

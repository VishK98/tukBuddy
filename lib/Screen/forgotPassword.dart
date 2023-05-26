// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:tuk_boddy/Screen/resetPassword.dart';
import 'package:tuk_boddy/api_service.dart';

class ForgotPassword {
  String email = '';
  String otp = '';

  String password = '';
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //List<dynamic> otp = [];
  bool otp = false;

  final _formKey = GlobalKey<FormState>();
  final ForgotPassword _data = ForgotPassword();

  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void initState() {
    otp == true;
    super.initState();
  }

  _sendOTP() {
    ApiService.fetchData(context);

    ApiService.sendOTP(
      _data.email,
    ).then((value) {
      print(value);
      Navigator.of(context).pop();
      otp = value['status'];
      print('OTP SUCESS==>$otp');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      setState(() {
        otp == true;
      });
    });
  }

  _verifyOTP() {
    ApiService.verifyOTP(
      _data.email,
      _data.otp,
    ).then((value) {
      print(value);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        // Navigator.pushNamed(context, 'ResetPassword');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPassword(
                      email: _data.email,
                    )));
      } else {}
    });
  }

  Widget userInput(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType,
      {required Null Function(dynamic value) onChanged,
      required String? Function(dynamic value) validator}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        controller: userInput,
        autocorrect: false,
        enableSuggestions: false,
        autofocus: false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(204, 221, 219, 219),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: hintTitle,
          labelStyle: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black54),
          hintStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(otp);
    return Scaffold(
      backgroundColor: const Color(0xff4f4f4f),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // color: Colors.amber,
              height: MediaQuery.of(context).size.height * .3,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 20,
                        color: Colors.white60,
                      )),
                  Center(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        'assets/images/tukBuddy.png',
                        // height: 70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .7,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      otp == false
                          ? userInput(
                              emailController,
                              'Enter your email',
                              TextInputType.emailAddress,
                              onChanged: ((value) {
                                _data.email = value;
                              }),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            )
                          : otp == true
                              ? userInput(
                                  otpController,
                                  'Enter OTP',
                                  TextInputType.number,
                                  onChanged: ((value) {
                                    _data.otp = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                )
                              : Container(),
                      const SizedBox(
                        height: 30,
                      ),
                      otp == false
                          ? Container(
                              height: 60,
                              width: 400,
                              padding: const EdgeInsets.only(
                                  top: 5, left: 70, right: 70),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: const Color(0xff4f4f4f),
                                onPressed: () {
                                  _sendOTP();
                                },
                                child: const Text(
                                  'Send OTP',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xffff86b7),
                                  ),
                                ),
                              ),
                            )
                          : otp == true
                              ? Container(
                                  height: 60,
                                  width: 400,
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 70, right: 70),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: const Color(0xff4f4f4f),
                                    onPressed: () {
                                      _verifyOTP();
                                    },
                                    child: const Text(
                                      'Verify',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xffff86b7),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

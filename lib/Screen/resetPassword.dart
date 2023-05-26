// ignore_for_file: file_names, avoid_print, must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tuk_boddy/Screen/loginScreen.dart';
import 'package:tuk_boddy/api_service.dart';

class Resetpassword {
  String email = '';
  String password = '';
  String confirmpassword = '';
}

class ResetPassword extends StatefulWidget {
  String email = '';

  ResetPassword({Key? key, required this.email}) : super(key: key);
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool passwordVisible = false;
  bool confirmpasswordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confirmpasswordVisible = true;
  }

  final _formKey = GlobalKey<FormState>();
  final Resetpassword _data = Resetpassword();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      print(_data.password);
      debugPrint('Everything looks good!');
      _resetPassword();
    }
  }

  _resetPassword() {
    ApiService.fetchData(context);

    ApiService.resetPassword(
      // _data.email,
      widget.email,
      _data.password,
    ).then((value) {
      Navigator.of(context).pop();

      print(value);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.pushNamed(context, 'LoginScreen');
      } else {}
    });
  }

  Widget userInput(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType,
      {required Null Function(dynamic value) onChanged}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      height: 70,
      child: TextFormField(
        onChanged: onChanged,
        // validator: validator,
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
    print('EMAIL ==> ${widget.email}');
    return Scaffold(
      backgroundColor: const Color(0xff4f4f4f),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .3,
              width: MediaQuery.of(context).size.width,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        // Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen()),
                            (Route<dynamic> route) => false);
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
                      SizedBox(
                        height: 70,
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          obscureText: passwordVisible,
                          autocorrect: false,
                          enableSuggestions: false,
                          autofocus: false,
                          decoration: InputDecoration(
                            // helperText: '',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(204, 221, 219, 219),
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Enter password',
                            labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                            hintStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'This field is required';
                            }
                            if (value.trim().length < 8) {
                              return 'Password must be at least 8 characters in length';
                            }
                            return null;
                          },
                          onChanged: ((value) {
                            _data.password = value;
                          }),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          obscureText: confirmpasswordVisible,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Confirm Password',
                            hintStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                            suffixIcon: IconButton(
                              icon: Icon(confirmpasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    confirmpasswordVisible =
                                        !confirmpasswordVisible;
                                  },
                                );
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }

                            if (value != _data.password) {
                              return 'Confimation password does not match the entered password';
                            }

                            return null;
                          },
                          onChanged: ((value) {
                            _data.confirmpassword = value;
                          }),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        height: 60,
                        width: 400,
                        padding:
                            const EdgeInsets.only(top: 5, left: 70, right: 70),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: const Color(0xff4f4f4f),
                          onPressed: () {
                            _trySubmitForm();
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffff86b7),
                            ),
                          ),
                        ),
                      ),
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

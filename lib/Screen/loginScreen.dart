// ignore_for_file: use_key_in_widget_constructors, file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuk_boddy/Screen/doctorDegree.dart';
import 'package:tuk_boddy/Screen/doctorNavBar.dart';
import 'package:tuk_boddy/Screen/doctorOffice.dart';
import 'package:tuk_boddy/Screen/doctorPraticeFocus.dart';
import 'package:tuk_boddy/Screen/doctorTiming.dart';
import 'package:tuk_boddy/Screen/dodctorContactInfo.dart';
import 'package:tuk_boddy/Screen/membershipScreen.dart';
import 'package:tuk_boddy/Screen/patient.dart';
import 'package:tuk_boddy/Screen/patient2Form.dart';
import 'package:tuk_boddy/Screen/patient3Form.dart';
import 'package:tuk_boddy/Screen/patient4Form.dart';
import 'package:tuk_boddy/Screen/patient5Form.dart';
import 'package:tuk_boddy/Screen/patientNavBar.dart';
import 'package:tuk_boddy/Screen/patientWishlist.dart';
import 'package:tuk_boddy/Screen/signUpScreen.dart';
import 'package:tuk_boddy/Screen/surgicalProcedures.dart';
import 'package:tuk_boddy/api_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginUser {
  String username = '';
  String password = '';
}

class _LoginData {
  String id = '';
  String firstName = '';
  String userEmail = '';
  String photo = '';
  String type = '';
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final LoginUser _data = LoginUser();
  bool isLoading = true;
  bool isInputUsernameValid = false;
  bool stepBack = true;

  int textLength = 0;
  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _login();
    }
  }

  _doctorLoginStep(value) {
    if (value['data'][0]['step'] == 0) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const MembershipScreen()),
          (Route<dynamic> route) => false);
    } else if (value['data'][0]['step'] == 1) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const DoctorDegree(stepBack: true)),
          (Route<dynamic> route) => false);
    } else if (value['data'][0]['step'] == 2) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DoctorPracticeFocus(stepBack: true)),
          (Route<dynamic> route) => false);
    } else if (value['data'][0]['step'] == 3) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                const DoctorOfficeDetails(stepBack: true),
          ),
          (Route<dynamic> route) => false);
    } else if (value['data'][0]['step'] == 4) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const DoctorContactInfo(stepBack: true)),
          (Route<dynamic> route) => false);
    } else if (value['data'][0]['step'] == 5) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const DoctorOfficeTiming(stepBack: true)),
          (Route<dynamic> route) => false);
    } else if (value['data'][0]['step'] == 6) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const SurgicalProcedures(stepBack: true)),
          (Route<dynamic> route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const DoctorBottomNav(0)),
          (Route<dynamic> route) => false);
    }
  }

  _patientLoginStep(value) {
    if (value['data'][0]['step'] == 0) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const PatientInformation(stepBack: true)),
          (Route<dynamic> route) => false);
    } else if (value['data'][0]['step'] == 1) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => PatientSecondForm(
                    stepBack: true,
                    gender: '',
                  )),
          (Route<dynamic> route) => false);
    } else if (value['data'][0]['step'] == 2) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const PatientThirdForm(stepBack: true)),
          (Route<dynamic> route) => false);
    } else if (value['data'][0]['step'] == 3) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const PatientForthForm(stepBack: true)),
          (Route<dynamic> route) => false);
    } else if (value['data'][0]['step'] == 4) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const PatientFifthForm(stepBack: true)),
          (Route<dynamic> route) => false);
    } else if (value['data'][0]['step'] == 5) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const PatientWishListForm(stepBack: true)),
          (Route<dynamic> route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const PatientBottomNav(0)),
          (Route<dynamic> route) => false);
    }
  }

  _login() async {
    ApiService.fetchData(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    ApiService.login(_data.username, _data.password, _udid).then((value) {
      Navigator.of(context).pop();
      print('LOGIN==>$value');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));

      var res = value["data"];
      prefs.setString("user_id", res[0]["id"].toString());
      prefs.setString("user_type", res[0]["user_type"].toString());
      prefs.setString("user_name", res[0]["name"].toString());
      prefs.setString("user_email", res[0]["email"].toString());
      prefs.setString("user_mobile", res[0]["mobile"].toString());
      prefs.setString("user_profile", res[0]["profile_pic"].toString());
      prefs.setString("registration_step", res[0]["step"].toString());

      if (value['data'][0]['user_type'] == 'Patient') {
        _patientLoginStep(value);
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => const PatientInformation()),
        //     (Route<dynamic> route) => false);
      } else {
        _doctorLoginStep(value);
      }
    });
  }

  bool passwordVisible = false;
  String _udid = 'Unknown';

  @override
  void initState() {
    // disableCapture();
    super.initState();
    passwordVisible = true;
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String udid;
    try {
      udid = await FlutterUdid.udid;
    } on PlatformException {
      udid = 'Failed to get UDID.';
    }

    if (!mounted) return;

    setState(() {
      _udid = udid;
    });
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);
  final _LoginData _loginData = _LoginData();

  _saveUserInfo(id, firstName, email, photo, type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loginData.id = id;
      _loginData.firstName = firstName;
      _loginData.userEmail = email;
      _loginData.photo = photo;
      _loginData.type = type;

      ApiService.postLogin(_loginData.id, _loginData.firstName,
              _loginData.userEmail, _loginData.photo, _loginData.type)
          .then((value) {
        print('VALUE==>$value');
        var res = value["data"];
        prefs.setString("user_id", res[0]["id"].toString());
        prefs.setString("user_type", res[0]["user_type"].toString());
        prefs.setString("user_name", res[0]["name"].toString());
        prefs.setString("user_email", res[0]["email"].toString());
        prefs.setString("user_mobile", res[0]["mobile"].toString());
        prefs.setString("user_profile", res[0]["profile_pic"].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Successful")));
      });
    });
  }

  _googleLogin() async {
    print('_googleSignIn Here');
    try {
      await _googleSignIn.signIn();
      setState(() {
        _saveUserInfo(
          _googleSignIn.currentUser?.id,
          _googleSignIn.currentUser?.displayName,
          _googleSignIn.currentUser?.email,
          _googleSignIn.currentUser?.photoUrl,
          "google",
        );
      });
    } catch (err) {
      print("this error$err");
    }
  }

  _facebookLogin() async {
    print("FaceBook");
    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        print(userData);
        setState(() {
          print('ID==>${userData['id']}');

          print('Name==>${userData['name']}');
          print('Email==>${userData["email"]}');
          print('Image==>${userData["picture"]["data"]["url"]}');

          _saveUserInfo(
            userData["id"],
            userData["name"],
            userData["email"],
            userData["picture"]["data"]["url"],
            "facebook",
          );
        });
      }
    } catch (error) {
      print(error);
    }
  }

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  Widget userInput(
    TextEditingController userInput,
    String hintTitle,
    TextInputType keyboardType, {
    required Null Function(dynamic value) onChanged,
    required String? Function(dynamic value) validator,
    required Icon suffixIcon,
    required autovalidate,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      height: 70,
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
          suffixIcon: suffixIcon,
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
    // print('MobileID==>$_udid');
    return Scaffold(
      backgroundColor: const Color(0xff4f4f4f),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // color: Colors.amber,
              height: MediaQuery.of(context).size.height * .3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset(
                      'assets/images/tukBuddy.png',
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
                      userInput(
                          autovalidate: AutovalidateMode.onUserInteraction,
                          emailController,
                          'Username',
                          TextInputType.emailAddress, onChanged: ((value) {
                        _data.username = value;
                        setState(() {
                          validateUsername(value);
                          if (validateUsername(value) != null) {
                            isInputUsernameValid = false;
                          }
                        });
                      }),
                          validator: validateUsername,
                          suffixIcon: Icon(
                            isInputUsernameValid ? Icons.check : null,
                            color: Colors.green,
                          )),
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

                            return null;
                          },
                          onChanged: ((value) {
                            _data.password = value;
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 50,
                        width: 250,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: const Color(0xff4f4f4f),
                          onPressed: () {
                            _trySubmitForm();
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffff86b7),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'ForgotPasssword');
                          },
                          child: const Text(
                            'Forgot password ?',
                            style: TextStyle(
                              color: Color(0xffff86b7),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            height: 1,
                            color: const Color(0xff4f4f4f),
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: const Color(0xff4f4f4f),
                                  width: 1,
                                )),
                            child: const Center(child: Text('OR')),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            height: 1,
                            color: const Color(0xff4f4f4f),
                          ),
                        ],
                      ),
                      const Divider(thickness: 0, color: Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              print('Clicked');
                              _googleLogin();
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //         content: Text(
                              //             'Please wait we are working on it...')));
                            },
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset('assets/images/google.png'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _facebookLogin();

                              print('Clicked');
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //         content: Text(
                              //             'Please wait we are working on it...')));
                            },
                            child: SizedBox(
                              height: 45,
                              width: 45,
                              child: Image.asset('assets/images/facebook.png'),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an Account ? ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    curve: Curves.linear,
                                    duration: const Duration(milliseconds: 400),
                                    type:
                                        PageTransitionType.leftToRightWithFade,
                                    isIos: true,
                                    child: SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ],
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

  String? validateUsername(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    } else if (value.contains(' ')) {
      return 'Enter username without using space';
    }
    setState(() {
      isInputUsernameValid = true;
    });
    return null;
  }

  // Future<void> disableCapture() async {
  //   //disable screenshots and record screen in current screen
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }
}

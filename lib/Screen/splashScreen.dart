// ignore_for_file: library_private_types_in_public_api, file_names, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuk_boddy/Screen/doctorDegree.dart';
import 'package:tuk_boddy/Screen/doctorNavBar.dart';
import 'package:tuk_boddy/Screen/doctorOffice.dart';
import 'package:tuk_boddy/Screen/doctorPraticeFocus.dart';
import 'package:tuk_boddy/Screen/doctorTiming.dart';
import 'package:tuk_boddy/Screen/dodctorContactInfo.dart';
import 'package:tuk_boddy/Screen/loginScreen.dart';
import 'package:tuk_boddy/Screen/membershipScreen.dart';
import 'package:tuk_boddy/Screen/patient.dart';
import 'package:tuk_boddy/Screen/patient2Form.dart';
import 'package:tuk_boddy/Screen/patient3Form.dart';
import 'package:tuk_boddy/Screen/patient4Form.dart';
import 'package:tuk_boddy/Screen/patient5Form.dart';
import 'package:tuk_boddy/Screen/patientNavBar.dart';
import 'package:tuk_boddy/Screen/patientWishlist.dart';
import 'package:tuk_boddy/Screen/surgicalProcedures.dart';
import 'package:tuk_boddy/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Map data = {};
  int? step;
  bool stepBack = true;
  @override
  void initState() {
    _checkAuth();
    _registrationStep();
    super.initState();
  }

  _registrationStep() {
    ApiService.registrationStep().then((value) {
      // print('VALUE==>$value');
      setState(() {
        data = value["data"];
        step = data.values.first;
        // print("RegistrationStep on splashScreen==>$step");
      });
    });
  }

  Future _checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print('USer Id On spalshScreen ==> ${prefs.getString('user_id')}');

    if (prefs.getString('user_id') == null) {
      Timer(
          const Duration(seconds: 2),
          () => {
                Navigator.of(context).popUntil((route) => route.isFirst),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen())),
              });
    } else {
      Timer(
          const Duration(seconds: 2),
          () => {
                Navigator.of(context).popUntil((route) => route.isFirst),
                if (prefs.getString('user_type') == 'Doctor')
                  {
                    if (step == 0)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const MembershipScreen()),
                            (Route<dynamic> route) => false)
                      }
                    else if (step == 1)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const DoctorDegree(stepBack: true)),
                            (Route<dynamic> route) => false)
                      }
                    else if (step == 2)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DoctorPracticeFocus(stepBack: true)),
                            (Route<dynamic> route) => false)
                      }
                    else if (step == 3)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const DoctorOfficeDetails(stepBack: true),
                            ),
                            (Route<dynamic> route) => false)
                      }
                    else if (step == 4)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const DoctorContactInfo(stepBack: true)),
                            (Route<dynamic> route) => false)
                      }
                    else if (step == 5)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const DoctorOfficeTiming(stepBack: true)),
                            (Route<dynamic> route) => false)
                      }
                    else if (step== 6)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const SurgicalProcedures(stepBack: true)),
                            (Route<dynamic> route) => false)
                      }
                    else
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const DoctorBottomNav(0)),
                            (Route<dynamic> route) => false)
                      }
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const DoctorBottomNav(0)),
                    // ),
                  }
                else
                  {
                    if (step == 0)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const PatientInformation(stepBack: true)),
                            (Route<dynamic> route) => false)
                      }
                    else if (step == 1)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PatientSecondForm(
                                      stepBack: true,
                                      gender: '',
                                    )),
                            (Route<dynamic> route) => false)
                      }
                    else if (step == 2)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const PatientThirdForm(
                                      stepBack: true,
                                    )),
                            (Route<dynamic> route) => false)
                      }
                    else if (step == 3)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const PatientForthForm(stepBack: true)),
                            (Route<dynamic> route) => false)
                      }
                    else if (step == 4)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const PatientFifthForm(stepBack: true)),
                            (Route<dynamic> route) => false)
                      }
                    else if (step == 5)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const PatientWishListForm(stepBack: true)),
                            (Route<dynamic> route) => false)
                      }
                    else
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const PatientBottomNav(0)),
                            (Route<dynamic> route) => false)
                      }
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const PatientBottomNav(0)),
                    // ),
                  }
              });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(color: Color(0xff4f4f4f)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset(
                        'assets/images/tukBuddy.png',
                        height: 70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

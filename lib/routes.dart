import 'package:flutter/material.dart';
import 'package:tuk_boddy/Screen/doctorDegree.dart';
import 'package:tuk_boddy/Screen/doctorNavBar.dart';
import 'package:tuk_boddy/Screen/doctorOffice.dart';
import 'package:tuk_boddy/Screen/doctorPraticeFocus.dart';
import 'package:tuk_boddy/Screen/doctorProfile.dart';
import 'package:tuk_boddy/Screen/doctorRegistrationDone.dart';
import 'package:tuk_boddy/Screen/doctorTiming.dart';
import 'package:tuk_boddy/Screen/dodctorContactInfo.dart';
import 'package:tuk_boddy/Screen/forgotPassword.dart';
//import 'package:tuk_boddy/Screen/homeScreen.dart';
import 'package:tuk_boddy/Screen/membershipScreen.dart';
import 'package:tuk_boddy/Screen/loginScreen.dart';
import 'package:tuk_boddy/Screen/patient.dart';
import 'package:tuk_boddy/Screen/patient2Form.dart';
import 'package:tuk_boddy/Screen/patient3Form.dart';
import 'package:tuk_boddy/Screen/patient4Form.dart';
import 'package:tuk_boddy/Screen/patient5Form.dart';
import 'package:tuk_boddy/Screen/patientDetails.dart';
import 'package:tuk_boddy/Screen/patientNavBar.dart';
import 'package:tuk_boddy/Screen/patientRegistrationDone.dart';
import 'package:tuk_boddy/Screen/patientWishlist.dart';
import 'package:tuk_boddy/Screen/resetPassword.dart';
import 'package:tuk_boddy/Screen/signUpScreen.dart';
import 'package:tuk_boddy/Screen/splashScreen.dart';
import 'package:tuk_boddy/Screen/surgicalProcedures.dart';
import 'package:tuk_boddy/Screen/welcomeScreen.dart';

var route = <String, WidgetBuilder>{
  'SplashScreen': (context) => const SplashScreen(),
  // 'WelComeScreen': (context) => const WelcomeScreen(),
    'WelComeScreen': (context) =>  CheckBoxExample(),

  'SignUpScreen': (context) => SignupScreen(),
  'LoginScreen': (context) => LoginScreen(),
  'ForgotPasssword': (context) => const ForgotPasswordScreen(),
  'ResetPassword': (context) => ResetPassword(email: ''),
  'MembershipScreen': (context) => const MembershipScreen(),
  'PatientInfo': (context) => const PatientInformation(stepBack: false),
  'PatientSecondForm': (context) => PatientSecondForm(
      stepBack: false,
        gender: '',
      ),
  'PatientThirdForm': (context) => const PatientThirdForm(stepBack: false),
  'PatientForthForm': (context) => const PatientForthForm(stepBack: false),
  'PatientFifthForm': (context) => const PatientFifthForm(stepBack:false),
  'PatientWishListForm': (context) => const PatientWishListForm(stepBack:false),
  'PatientRegistrationDone': (context) => const PatientRegistrationDone(),
  'DoctorInfo': (context) => const DoctorProfile(),
  'DoctorDegree': (context) => const DoctorDegree(stepBack: false),
  'DoctorPracticeFocus': (context) => DoctorPracticeFocus(stepBack: false),
  'DoctorOfficeDetails': (context) =>
      const DoctorOfficeDetails(stepBack: false),
  'DoctorOfficetiming': (context) => const DoctorOfficeTiming(stepBack: false),
  'DoctorContactInfo': (context) => const DoctorContactInfo(stepBack: false),
  'surgicalProcedures': (context) => const SurgicalProcedures(stepBack: false),
  'DoctorRegistrationDone': (context) => const DoctorRegistrationDone(),
  // ignore: prefer_const_constructors
  'DoctorBottomNav': (context) => DoctorBottomNav(0),
  // 'PatientDetails': (context) => PatientDetails(0),
  'PatientBottomNav': (context) => const PatientBottomNav(0),
};

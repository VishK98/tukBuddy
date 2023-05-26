// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tuk_boddy/Screen/patientNavBar.dart';

class PatientRegistrationDone extends StatefulWidget {
  const PatientRegistrationDone({Key? key}) : super(key: key);

  @override
  State<PatientRegistrationDone> createState() =>
      _PatientRegistrationDoneState();
}

class _PatientRegistrationDoneState extends State<PatientRegistrationDone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        // color: Colors.amber,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 150,
            ),
            Image.asset('assets/images/done.png'),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Success!',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Everthing went well,\nCongratulations',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
            Container(
              height: 60,
              width: 400,
              padding: const EdgeInsets.only(top: 10, left: 70, right: 70),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: const Color(0xff4f4f4f),
                onPressed: () {
                  // print('Clicked');
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const PatientBottomNav(0)),
                      (Route<dynamic> route) => false);
                },
                child: const Text(
                  'GO AHEAD',
                  style: TextStyle(
                    fontSize: 17,
                    // fontWeight: FontWeight.w700,
                    color: Color(0xffff86b7),
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
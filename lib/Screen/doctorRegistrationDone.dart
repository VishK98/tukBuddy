// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:tuk_boddy/Screen/doctorNavBar.dart';

class DoctorRegistrationDone extends StatefulWidget {
  const DoctorRegistrationDone({Key? key}) : super(key: key);

  @override
  State<DoctorRegistrationDone> createState() => _DoctorRegistrationDoneState();
}

class _DoctorRegistrationDoneState extends State<DoctorRegistrationDone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  print('Clicked');
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const DoctorBottomNav(0)),
                      (Route<dynamic> route) => false);
                },
                child: const Text(
                  'GO AHEAD',
                  style: TextStyle(
                    fontSize: 17,
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

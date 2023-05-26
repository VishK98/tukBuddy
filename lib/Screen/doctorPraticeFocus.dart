// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tuk_boddy/api_service.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';

class DoctorPracticeFocus extends StatefulWidget {
  bool stepBack;

  DoctorPracticeFocus({Key? key, required this.stepBack}) : super(key: key);

  @override
  State<DoctorPracticeFocus> createState() => _DoctorPracticeFocusState();
}

class _DoctorPracticeFocusState extends State<DoctorPracticeFocus> {
  List<dynamic> data = [];

  String? _chosenValue;
  var dropdownvalue;
  bool stepBack = false;

  @override
  void initState() {
    _doctorPracticeFocus();
    super.initState();
  }

  _doctorPracticeFocus() {
    ApiService.doctorPratice().then((value) {
      setState(() {
        // print("member==>$value");
        data = value["data"]['PrimaryPractices'];
        print(data);
      });
    });
  }

  _doctorPractice() {
    ApiService.doctorPractice(dropdownvalue, 1).then((value) {
      print(value);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      // print('Free User ==> $value');
      if (value['status']) {
        Navigator.pushNamed(context, 'DoctorOfficeDetails');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 15,
          left: 70,
          right: 70,
        ),
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: const Color(0xff4f4f4f),
          onPressed: () {
            print('Clicked');
            _doctorPractice();
          },
          child: const Text(
            'Continue',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xffff86b7),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xff4f4f4f),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                // color: Colors.amber,
                height: MediaQuery.of(context).size.height * .3,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    widget.stepBack == false
                        ? IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: 20,
                              color: Colors.white60,
                            ))
                        : Container(
                            height: 50,
                          ),
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
                    LinearPercentIndicator(
                      percent: 3 / 7,
                      animation: true,
                      lineHeight: 15.0,
                      barRadius: const Radius.circular(20),
                      progressColor: const Color(0xffff86b7),
                      center: const Text(
                        'Step 3 of 7',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .600,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 10),
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 9,
                          padding: const EdgeInsets.only(left: 15, right: 25),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: DropdownButtonFormField(
                              decoration:
                                  const InputDecoration.collapsed(hintText: ''),
                              hint: const Text(
                                'Select your primary practice',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                              items: data.map((item) {
                                return DropdownMenuItem(
                                  value: item['name'].toString(),
                                  child: Text(
                                    item['name'].toString(),
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  dropdownvalue = newVal;
                                  print(dropdownvalue);
                                });
                              },
                              value: dropdownvalue,
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 9,
                        padding: const EdgeInsets.only(left: 15, right: 25),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            value: _chosenValue,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontStyle: FontStyle.italic),
                            items: <String>[
                              'Yes',
                              'No',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: const Text(
                              "Is your Board Certified   ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                _chosenValue = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

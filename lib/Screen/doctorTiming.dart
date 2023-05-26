// ignore_for_file: avoid_print, must_be_immutable, file_names, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:multiselect/multiselect.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tuk_boddy/api_service.dart';

class DoctorOfficeTiming extends StatefulWidget {
  const DoctorOfficeTiming({Key? key, required this.stepBack})
      : super(key: key);
  final bool stepBack;
  @override
  State<DoctorOfficeTiming> createState() => _DoctorOfficeTimingState();
}

class _DoctorOfficeTimingState extends State<DoctorOfficeTiming> {
  List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  List<String> selectedDays = [];
  List<String> selectedTime = [];

  List selectedDaysData = [];
  bool stepBack = false;

  _officeTiming() async {
    for (var i = 0; i < selectedDaysData.length; i++) {
      selectedTime.add(selectedDaysData[i]["start_time"].format(context) +
          '-' +
          selectedDaysData[i]["close_time"].format(context));
    }
    // print('here==>${selectedTime.join(',')}');

    ApiService.fetchData(context);
    ApiService.doctorOfficeTiming(
            selectedDays.join(','), selectedTime.join(','))
        .then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.pushNamed(context, 'surgicalProcedures');
      }
    });
  }

  _selectStartTime(BuildContext context, i) async {
    print(i);

    final TimeOfDay? newStartTime = await showTimePicker(
        context: context, initialTime: selectedDaysData[i]["start_time"]);
    if (newStartTime != null) {
      setState(() {
        selectedDaysData[i]["start_time"] = newStartTime;
      });
      print(
        selectedDaysData[i]["start_time"].format(context),
      );
    }
  }

  _selectEndTime(BuildContext context, int i) async {
    final TimeOfDay? newEndTime = await showTimePicker(
        context: context, initialTime: selectedDaysData[i]["close_time"]);
    if (newEndTime != null) {
      setState(() {
        selectedDaysData[i]["close_time"] = newEndTime;
      });
      print(
        selectedDaysData[i]["close_time"].format(context),
      );
    }
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
            // print('Clicked');
            _officeTiming();
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
                      percent: 6 / 7,
                      animation: true,
                      lineHeight: 15.0,
                      barRadius: const Radius.circular(20),
                      progressColor: const Color(0xffff86b7),
                      center: const Text(
                        'Step 6 of 7',
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropDownMultiSelect(
                        options: days,
                        selectedValues: selectedDays,
                        onChanged: (value) {
                          setState(() {
                            selectedDays = value;
                            selectedDaysData = [];
                            for (var i = 0; i < selectedDays.length; i++) {
                              selectedDaysData.add({
                                "start_time":
                                    const TimeOfDay(hour: 0, minute: -1),
                                "selectedDays": selectedDays[i],
                                "close_time":
                                    const TimeOfDay(hour: 0, minute: -1)
                              });
                            }
                          });
                          print(selectedDays);
                        },
                        whenEmpty: 'Please select your availability day',
                      ),
                      Table(
                        border:
                            TableBorder.all(color: Colors.black, width: 1.5),
                        children: [
                          selectedDaysData.isEmpty
                              ? const TableRow(children: [
                                  SizedBox(),
                                  SizedBox(),
                                  SizedBox(),
                                ])
                              : const TableRow(children: [
                                  Center(
                                    child: Text(
                                      "Day",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "Open Time",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "Close Time",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                ]),
                          for (var i = 0; i < selectedDaysData.length; i++) ...[
                            TableRow(children: [
                              Center(
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                      selectedDaysData[i]["selectedDays"]
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 15.0, color: Colors.black)),
                                ),
                              ),
                              Center(
                                  child: selectedDaysData[i]["start_time"] ==
                                          const TimeOfDay(hour: 0, minute: -1)
                                      ? TextButton(
                                          onPressed: () {
                                            _selectStartTime(context, i);
                                          },
                                          child: const Text('Select Time',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black)),
                                        )
                                      : TextButton(
                                          onPressed: () {
                                            _selectStartTime(context, i);
                                          },
                                          child: Text(
                                              selectedDaysData[i]["start_time"]
                                                  .format(context),
                                              style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black)))),
                              Center(
                                  child: selectedDaysData[i]["close_time"] ==
                                          const TimeOfDay(hour: 0, minute: -1)
                                      ? TextButton(
                                          onPressed: () {
                                            _selectEndTime(context, i);
                                          },
                                          child: const Text('Select Time',
                                              //_startTime.format(context),
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black)),
                                        )
                                      : TextButton(
                                          onPressed: () {
                                            _selectEndTime(context, i);
                                          },
                                          child: Text(
                                              selectedDaysData[i]["close_time"]
                                                  .format(context),
                                              style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black)))),
                            ]),
                          ]
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

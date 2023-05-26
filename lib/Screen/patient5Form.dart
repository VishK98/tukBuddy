// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tuk_boddy/api_service.dart';

class PatientFifthForm extends StatefulWidget {
  const PatientFifthForm({
    Key? key,
    required this.stepBack,
  }) : super(key: key);
  final bool stepBack;
  @override
  State<PatientFifthForm> createState() => _PatientFifthFormState();
}

class _PatientFifthFormState extends State<PatientFifthForm> {
  final dOBController = TextEditingController();
  List<dynamic> medicalClearance = [
    {'id': '1', 'name': 'Can get medical Clearance Quickly'},
    {'id': '2', 'name': 'Can get medical clearance but for 2-3 weeks'},
    {'id': '3', 'name': 'Already Medically Cleared'}
  ];
  var dropdownvalue;

  String? _chosensurgeryValue;
  String? _chosentravelValue;
  String? _chosenopinionPoolValue;
  String? _chosenweekDayValue;

  final surgeryController = TextEditingController();
  final problemController = TextEditingController();
  final desiredOutcomesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool stepBack = false;

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _dreamSurgeon();
    }
  }

  _dreamSurgeon() {
    ApiService.fetchData(context);

    ApiService.dreamSurgeon(_chosensurgeryValue, _chosentravelValue,
            dropdownvalue['id'], _chosenopinionPoolValue)
        .then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.pushNamed(context, 'PatientWishListForm');
      }
    });
  }

  Widget userInput(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType,
      {required Null Function(dynamic value) onChanged,
      required String? Function(dynamic value) validator}) {
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
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * .1,
        width: MediaQuery.of(context).size.width,
        padding:
            const EdgeInsets.only(top: 15, left: 70, right: 70, bottom: 15),
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: const Color(0xff4f4f4f),
          onPressed: () {
            // _dreamSurgeon();
            _trySubmitForm();
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
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
                        percent: 5 / 6,
                        animation: true,
                        lineHeight: 15.0,
                        barRadius: const Radius.circular(20),
                        progressColor: const Color(0xffff86b7),
                        center: const Text(
                          'Step 5 of 6',
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Lets connect you with your dream surgeon!',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xffff86b7),
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15,
                            top: 15,
                          ),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 9,
                            padding: const EdgeInsets.only(left: 15, right: 25),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration.collapsed(
                                    hintText: ''),
                                value: _chosensurgeryValue,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(179, 64, 64, 64),
                                ),
                                items: <String>[
                                  'ASAP',
                                  'Specific day of the week',
                                  'Between dates',
                                  'On specific date',
                                  'Whenever, no rush'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: const Text(
                                  "I want to have my surgery",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosensurgeryValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        _chosensurgeryValue == 'Specific day of the week'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15,
                                  top: 15,
                                ),
                                child: Container(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width * 9,
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 25),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: DropdownButtonFormField<String>(
                                      decoration:
                                          const InputDecoration.collapsed(
                                              hintText: ''),
                                      value: _chosenweekDayValue,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(179, 64, 64, 64),
                                          fontStyle: FontStyle.italic),
                                      items: <String>[
                                        'Sunday',
                                        'Monday',
                                        'Tuesday',
                                        'Wednesday',
                                        'Thursday',
                                        'Friday',
                                        'Saturday'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      hint: const Text(
                                        "Please select availability day",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (_chosenweekDayValue == null ||
                                            value!.isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      },
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          _chosenweekDayValue = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        _chosensurgeryValue == 'On specific date'
                            ? InkWell(
                                child: Container(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width * 9,
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 25),
                                  margin: EdgeInsets.only(
                                      left: 15, right: 15, top: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextFormField(
                                    controller: dOBController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your date',
                                      border: InputBorder.none,
                                      suffixIcon: InkWell(
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(
                                                        1947), //DateTime.now() - not to allow to choose before today.
                                                    lastDate: DateTime(2101));

                                            if (pickedDate != null) {
                                              String formattedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);

                                              setState(() {
                                                dOBController.text =
                                                    formattedDate; //set output date to TextField value.
                                                print(formattedDate);
                                              });
                                            } else {
                                              print("Date is not selected");
                                            }
                                          },
                                          child: const Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.black54,
                                          )),
                                      hintStyle: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15,
                            top: 15,
                          ),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 9,
                            padding: const EdgeInsets.only(left: 15, right: 25),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration.collapsed(
                                    hintText: ''),
                                value: _chosentravelValue,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(179, 64, 64, 64),
                                    fontStyle: FontStyle.italic),
                                items: <String>[
                                  '25',
                                  '50',
                                  '75',
                                  '100',
                                  '125',
                                  '150',
                                  'any distance'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: const Text(
                                  "I am willing to travel (in miles)",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosentravelValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 9,
                            padding: const EdgeInsets.only(left: 15, right: 25),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration.collapsed(
                                    hintText: ''),
                                hint: const Text(
                                  'Please select your medical clearance type',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                items: medicalClearance.map((item) {
                                  return DropdownMenuItem(
                                    // value: item['id'].toString(),
                                    value: item,
                                    child: Text(
                                      item['name'].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(179, 64, 64, 64),
                                          fontStyle: FontStyle.italic),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (item) {
                                  setState(() {
                                    dropdownvalue = item;
                                    print(dropdownvalue['id']);
                                  });
                                },
                                value: dropdownvalue,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15,
                            top: 15,
                          ),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 9,
                            padding: const EdgeInsets.only(left: 15, right: 25),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration.collapsed(
                                    hintText: ''),
                                value: _chosenopinionPoolValue,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(179, 64, 64, 64),
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
                                  "Have you submitted to the doctor opinion pool",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosenopinionPoolValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

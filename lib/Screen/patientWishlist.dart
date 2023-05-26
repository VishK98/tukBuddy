// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tuk_boddy/Screen/patientRegistrationDone.dart';
import 'package:tuk_boddy/api_service.dart';

class RegisterUser {
  String doctorName = "";
  String doctorEmail = "";
}

class PatientWishListForm extends StatefulWidget {
  const PatientWishListForm({Key? key, required this.stepBack})
      : super(key: key);
  final bool stepBack;
  @override
  State<PatientWishListForm> createState() => _PatientWishListFormState();
}

class _PatientWishListFormState extends State<PatientWishListForm> {
  final doctorNameController = TextEditingController();
  final doctorEmailController = TextEditingController();
  bool isInputEmailValid = false;
  bool isInputdoctorNameValid = false;
  bool stepBack = false;

  List<dynamic> data = [];
  List<dynamic> state = [];
  List<dynamic> city = [];
  List<dynamic> doctorList = [];
  List<dynamic> firstdoctorList = [
    {'id': 0, 'name': 'None'}
  ];

  var dropdownvalue;
  var dropdownvalue1;
  var dropdownvalue2;
  var doctorListValue;
  int? doctorId;
  String? doctorvalue;

  final RegisterUser _data = RegisterUser();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _country();
    _doctorList();
    super.initState();
  }

  _country() {
    ApiService.country().then((value) {
      // print(value);
      setState(() {
        data = value["data"]['Countries'];
        // print(data);
      });
    });
  }

  _doctorList() {
    ApiService.doctorList().then((value) {
      // print(value);
      setState(() {
        doctorList = value["data"];
        // print('DoctorList==>$doctorList');
        firstdoctorList.addAll(doctorList);
        print('First==>$firstdoctorList');
      });
    });
  }

  _state(countryId) {
    ApiService.state(countryId).then((value) {
      // print(value);
      setState(() {
        state = value['data'];
        //  print('HERE==>$state');
      });
    });
  }

  _city(stateId) {
    ApiService.city(stateId).then((value) {
      // print(value);
      setState(() {
        city = value['data'];
        // print(city);
      });
    });
  }

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _patientWishList();
    }
  }

  _patientWishList() {
    ApiService.fetchData(context);

    ApiService.patientWishList(_data.doctorName, doctorvalue, doctorId,
            _data.doctorEmail, dropdownvalue1['state_name'], dropdownvalue2)
        .then((value) {
      print('HERE==>$value');
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        // Navigator.pushNamed(context, 'PatientRegistrationDone');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    const PatientRegistrationDone()),
            (Route<dynamic> route) => false);
      }
    });
  }

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
          suffixIcon: suffixIcon,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(204, 221, 219, 219),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: hintTitle,
          hintStyle: const TextStyle(
            fontSize: 15,
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
                      !widget.stepBack
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
                        percent: 6 / 6,
                        animation: true,
                        lineHeight: 15.0,
                        barRadius: const Radius.circular(20),
                        progressColor: const Color(0xffff86b7),
                        center: const Text(
                          'You are almost done',
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
                  height: MediaQuery.of(context).size.height * .6,
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 10,
                          ),
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
                                  'Select your perferred doctors',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                items: firstdoctorList.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item['name'].toString()),
                                  );
                                }).toList(),
                                onChanged: (item) {
                                  setState(() {
                                    doctorListValue = item;
                                    // print(doctorListValue['name']);
                                    doctorvalue = doctorListValue['name'];
                                    doctorId = doctorListValue['id'];

                                    // _state(dropdownvalue['id']);
                                    print(doctorvalue);
                                    print(doctorId);
                                  });
                                },
                                value: doctorListValue,
                              ),
                            ),
                          ),
                        ),
                        doctorvalue == 'None'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                child: userInput(
                                    autovalidate:
                                        AutovalidateMode.onUserInteraction,
                                    doctorNameController,
                                    'Enter your perferred doctor name',
                                    TextInputType.name, onChanged: ((value) {
                                  _data.doctorName = value;
                                  setState(() {
                                    validateDoctorName(value);
                                    if (validateDoctorName(value) != null) {
                                      isInputdoctorNameValid = false;
                                    }
                                  });
                                }),
                                    validator: validateDoctorName,
                                    suffixIcon: Icon(
                                      isInputdoctorNameValid
                                          ? Icons.check
                                          : null,
                                      color: Colors.green,
                                    )),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 5),
                          child: userInput(
                              autovalidate: AutovalidateMode.onUserInteraction,
                              doctorEmailController,
                              'Enter your perferred doctor email ID',
                              TextInputType.emailAddress, onChanged: ((value) {
                            _data.doctorEmail = value;
                            setState(() {
                              validateEmail(value);
                              if (validateEmail(value) != null) {
                                isInputEmailValid = false;
                              }
                            });
                          }),
                              validator: validateEmail,
                              suffixIcon: Icon(
                                isInputEmailValid ? Icons.check : null,
                                color: Colors.green,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
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
                                  'Select your perferred doctor\'s country',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                items: data.map((item) {
                                  return DropdownMenuItem(
                                    //value: item['id'].toString(),
                                    value: item,
                                    child: Text(item['name'].toString()),
                                  );
                                }).toList(),
                                onChanged: (item) {
                                  setState(() {
                                    dropdownvalue = item;
                                    print(dropdownvalue['name']);
                                    _state(dropdownvalue['id']);
                                    //data.remove(dropdownvalue['id']);
                                  });
                                },
                                value: dropdownvalue,
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
                                  'Select your perferred doctor\'s  state',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                items: state.map((item) {
                                  return DropdownMenuItem(
                                    //value: item['state_name'].toString(),
                                    value: item,
                                    child: Text(item['state_name'].toString()),
                                  );
                                }).toList(),
                                onChanged: (item) {
                                  setState(() {
                                    dropdownvalue1 = item;

                                    print(dropdownvalue1['state_name']);
                                    _city(dropdownvalue1['id']);
                                  });
                                },
                                value: dropdownvalue1,
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
                                  'Select your perferred doctor\'s  city',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                items: city.map((item) {
                                  return DropdownMenuItem(
                                    value: item['city_name'].toString(),
                                    child: Text(item['city_name'].toString()),
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  setState(() {
                                    dropdownvalue2 = newVal;
                                    print(dropdownvalue2);
                                  });
                                },
                                value: dropdownvalue2,
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

  String? validateEmail(value) {
    if (!RegExp("^[a-zA-Z0-9+_.-]+@+.[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
      return 'Please a valid Email';
    }
    setState(() {
      isInputEmailValid = true;
    });
    return null;
  }

  String? validateDoctorName(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputdoctorNameValid = true;
    });
    return null;
  }
}

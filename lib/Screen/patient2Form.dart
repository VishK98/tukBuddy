// ignore_for_file: file_names, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tuk_boddy/api_service.dart';

class RegisterUser {
  String height = "";
  String weight = "";
  String bmi = "";
  String medicalHistory = "";
  String medication = "";
  String children = "";
}

class PatientSecondForm extends StatefulWidget {
  late String gender = '';

  PatientSecondForm({
    Key? key,
    required this.gender,
    required this.stepBack,
  }) : super(key: key);
  final bool stepBack;

  @override
  State<PatientSecondForm> createState() => _PatientSecondFormState();
}

class _PatientSecondFormState extends State<PatientSecondForm> {
  double? _result;

  String? _chosensmokeValue;

  final TextEditingController heightController = TextEditingController();

  final TextEditingController weightController = TextEditingController();

  final bmiController = TextEditingController();
  final medicalHistoryController = TextEditingController();
  final medicationController = TextEditingController();
  final childrenController = TextEditingController();

  final dOBController = TextEditingController();

  final RegisterUser _data = RegisterUser();
  final _formKey = GlobalKey<FormState>();
  bool isInputHeightValid = false;
  bool isInputWeightValid = false;
  bool isInputDiseaseValid = false;
  bool isInputMediactionValid = false;
  bool isInputchildrenValid = false;
  bool isInputBMIValid = false;

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _patientHealthInfo();
    }
  }

  _patientHealthInfo() async {
    ApiService.fetchData(context);

    ApiService.patienthealthInfo(
            _data.height,
            _data.weight,
            //_data.bmi,
            _result!.toStringAsFixed(2),
            _chosensmokeValue,
            _data.medicalHistory,
            _data.medication,
            widget.gender == 'Female' ? _data.children : '0')
        .then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.pushNamed(context, 'PatientThirdForm');
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
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('GENDER==> ${widget.gender}');
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
              children: [
                Container(
                  // color: Colors.amber,
                  height: MediaQuery.of(context).size.height * .300,
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
                        percent: 2 / 6,
                        animation: true,
                        lineHeight: 15.0,
                        barRadius: const Radius.circular(20),
                        progressColor: const Color(0xffff86b7),
                        center: const Text(
                          'Step 2 of 6',
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
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
                          child: userInput(
                            autovalidate: AutovalidateMode.onUserInteraction,
                            heightController,
                            'Please enter your height in cm',
                            TextInputType.number,
                            onChanged: ((value) {
                              _data.height = value;
                              setState(() {
                                validateheight(value);
                                if (validateheight(value) != null) {
                                  isInputHeightValid = false;
                                }
                              });
                            }),
                            validator: validateheight,
                            suffixIcon: Icon(
                              isInputHeightValid ? Icons.check : null,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: userInput(
                            autovalidate: AutovalidateMode.onUserInteraction,
                            weightController,
                            'Please enter your weight in pounds (lbs)',
                            TextInputType.number,
                            onChanged: ((value) {
                              _data.weight = value;
                              validateWeight(value);
                              if (validateWeight(value) != null) {
                                isInputWeightValid = false;
                              }

                              calculateBMI();
                            }),
                            validator: validateWeight,
                            suffixIcon: Icon(
                              isInputWeightValid ? Icons.check : null,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          height: 70,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                _result == null ? null : Icons.check,
                                color: Colors.green,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(204, 221, 219, 219),
                                ),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: _result == null
                                  ? "Body mass index"
                                  : _result!.toStringAsFixed(2),
                              hintStyle: TextStyle(
                                color: _result == null
                                    ? Colors.black54
                                    : Colors.black54,
                              ),
                            ),
                            onChanged: ((value) {}),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 15),
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
                                value: _chosensmokeValue,
                                style: const TextStyle(
                                    fontSize: 18,
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
                                  "Do you smoke",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosensmokeValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: userInput(
                            autovalidate: AutovalidateMode.onUserInteraction,
                            medicalHistoryController,
                            'Do you have any diseases',
                            TextInputType.name,
                            onChanged: ((value) {
                              _data.medicalHistory = value;
                              setState(() {
                                validateDiseases(value);
                                if (validateDiseases(value) != null) {
                                  isInputDiseaseValid = false;
                                }
                              });
                            }),
                            validator: validateDiseases,
                            suffixIcon: Icon(
                              isInputDiseaseValid ? Icons.check : null,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: userInput(
                            autovalidate: AutovalidateMode.onUserInteraction,
                            medicationController,
                            'Please enter Medication usage',
                            TextInputType.name,
                            onChanged: ((value) {
                              _data.medication = value;
                              setState(() {
                                validateMedication(value);
                                if (validateMedication(value) != null) {
                                  isInputMediactionValid = false;
                                }
                              });
                            }),
                            validator: validateMedication,
                            suffixIcon: Icon(
                              isInputMediactionValid ? Icons.check : null,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        widget.gender == 'Female'
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: userInput(
                                  autovalidate:
                                      AutovalidateMode.onUserInteraction,
                                  childrenController,
                                  'Please enter number of children',
                                  TextInputType.number,
                                  onChanged: ((value) {
                                    _data.children = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                  suffixIcon: Icon(
                                    isInputchildrenValid ? Icons.check : null,
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            : Container(),
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

  String? validateheight(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputHeightValid = true;
    });
    return null;
  }

  String? validateWeight(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputWeightValid = true;
    });
    return null;
  }

  String? validateDiseases(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputDiseaseValid = true;
    });
    return null;
  }

  String? validateMedication(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputMediactionValid = true;
    });
    return null;
  }

  void calculateBMI() {
    double height = double.parse(heightController.text) / 100;
    double weight = double.parse(weightController.text);

    double heightSquare = height * height;
    double result = weight / heightSquare;
    _result = result;
    setState(() {});
  }
}

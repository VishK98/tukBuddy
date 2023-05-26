// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tuk_boddy/api_service.dart';

class RegisterUser {
  String bmi = "";
  String tabacco = "";
  String marijuana = "";
  String birthPills = "";
  String facility = "";
  String anesthesia = "";
  String garments = "";
  String massage = "";
}

class SurgicalProcedures extends StatefulWidget {
  const SurgicalProcedures({Key? key, required this.stepBack})
      : super(key: key);
  final bool stepBack;
  @override
  State<SurgicalProcedures> createState() => _SurgicalProceduresState();
}

class _SurgicalProceduresState extends State<SurgicalProcedures> {
  String? _chosenSmokeValue;
  String? _chosenMarijuanaValue;
  String? _chosenbirthPillsValue;
  String? _chosenbreastsurgeryValue;
  String? _chosenmedicalclearanceValue;
  String? _chosenoperationPlaceValue;
  String? _chosenfacilityValue;
  String? _chosenanesthesiaValue;
  String? _chosengarmentsValue;
  String? _chosenmassageValue;

  final bmiController = TextEditingController();
  final tabaccoController = TextEditingController();
  final marijuanaController = TextEditingController();
  final birthPillsController = TextEditingController();
  final facilityController = TextEditingController();
  final anesthesiaController = TextEditingController();
  final garmentsController = TextEditingController();
  final massageController = TextEditingController();

  final RegisterUser _data = RegisterUser();
  final _formKey = GlobalKey<FormState>();

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // var body = {'':12};
      debugPrint('Everything looks good!');
      _surgicalProcedures();
    }
  }

  _surgicalProcedures() {
    ApiService.fetchData(context);

    ApiService.surgicalProcedures(
            _data.bmi,
            _chosenSmokeValue,
            _data.tabacco,
            _chosenMarijuanaValue,
            _data.marijuana,
            _chosenbirthPillsValue,
            _data.birthPills,
            _chosenbreastsurgeryValue,
            _chosenmedicalclearanceValue,
            _chosenoperationPlaceValue,
            _chosenfacilityValue,
            _data.facility,
            _chosenanesthesiaValue,
            _data.anesthesia,
            _chosengarmentsValue,
            _data.garments,
            _chosenmassageValue,
            _data.massage)
        .then((value) {
      print("VALUE==>$value");
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.pushNamed(context, 'DoctorRegistrationDone');
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
        height: MediaQuery.of(context).size.height * 0.060,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: 70,
          right: 70,
        ),
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: const Color(0xff4f4f4f),
          onPressed: () {
            print('Clicked');
            // _docctorInfo();
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
        child: Form(
          key: _formKey,
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
                        percent: 7 / 7,
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
                  height: MediaQuery.of(context).size.height * .640,
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
                              top: 10, left: 15, right: 15),
                          child: userInput(
                            bmiController,
                            'Please enter BMI',
                            TextInputType.number,
                            onChanged: ((value) {
                              _data.bmi = value;
                            }),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 10),
                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            width: MediaQuery.of(context).size.width * 9,
                            padding: const EdgeInsets.only(left: 15, right: 25),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration.collapsed(
                                    hintText: ''),
                                value: _chosenSmokeValue,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(179, 64, 64, 64),
                                    fontStyle: FontStyle.italic),
                                items: <String>[
                                  'Yes',
                                  'No',
                                  'No, but...'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: const Text(
                                  "Do you operate on tabacco patient?",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosenSmokeValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        _chosenSmokeValue == 'No, but...'
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: userInput(
                                  tabaccoController,
                                  'Enter days for tabaco patient to not smoke.',
                                  TextInputType.number,
                                  onChanged: ((value) {
                                    _data.tabacco = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 10),
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
                                value: _chosenMarijuanaValue,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(179, 64, 64, 64),
                                ),
                                items: <String>[
                                  'Yes',
                                  'No',
                                  'No, but...'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: const Text(
                                  "Do you operate on marijuana patient?",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosenMarijuanaValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        _chosenMarijuanaValue == 'No, but...'
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: userInput(
                                  marijuanaController,
                                  'Enter days for marijuana patient to not smoke.',
                                  TextInputType.number,
                                  onChanged: ((value) {
                                    _data.marijuana = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 10),
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
                                value: _chosenbirthPillsValue,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(179, 64, 64, 64),
                                ),
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
                                  "Birth pills ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosenbirthPillsValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        _chosenbirthPillsValue == 'Yes'
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: userInput(
                                  birthPillsController,
                                  'Enter hemoglobin details',
                                  TextInputType.number,
                                  onChanged: ((value) {
                                    _data.birthPills = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 10),
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
                                value: _chosenbreastsurgeryValue,
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
                                  "Do you take ultrasound before breast surgery",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosenbreastsurgeryValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 10),
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
                                value: _chosenmedicalclearanceValue,
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
                                  "Do you have medical clearance",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosenmedicalclearanceValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 10),
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
                                value: _chosenoperationPlaceValue,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(179, 64, 64, 64),
                                ),
                                items: <String>[
                                  'ASC',
                                  'Hospital',
                                  'Office based surgery'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: const Text(
                                  "Where do you operate your patients",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosenoperationPlaceValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 10),
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
                                value: _chosenfacilityValue,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(179, 64, 64, 64),
                                ),
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
                                  "Do you provide other facility to patients",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosenfacilityValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        _chosenfacilityValue == 'Yes'
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: userInput(
                                  facilityController,
                                  'Enter facility fees',
                                  TextInputType.number,
                                  onChanged: ((value) {
                                    _data.facility = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 10),
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
                                value: _chosenanesthesiaValue,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(179, 64, 64, 64),
                                ),
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
                                  "Do you give anesthesia",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosenanesthesiaValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        _chosenanesthesiaValue == 'Yes'
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: userInput(
                                  anesthesiaController,
                                  'Enter anesthesia fees',
                                  TextInputType.number,
                                  onChanged: ((value) {
                                    _data.anesthesia = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 10),
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
                                value: _chosengarmentsValue,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(179, 64, 64, 64),
                                ),
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
                                  "Do you provide garments to patients",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosengarmentsValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        _chosengarmentsValue == 'Yes'
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: userInput(
                                  garmentsController,
                                  'Enter garments fees',
                                  TextInputType.number,
                                  onChanged: ((value) {
                                    _data.garments = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 10),
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
                                value: _chosenmassageValue,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(179, 64, 64, 64),
                                ),
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
                                  "Do you provide massage to patients",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosenmassageValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        _chosenmassageValue == 'Yes'
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: userInput(
                                  massageController,
                                  'Enter massage fees',
                                  TextInputType.number,
                                  onChanged: ((value) {
                                    _data.massage = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                // Container(
                //   color: Colors.white,
                //   height: 60,
                //   width: MediaQuery.of(context).size.width,
                //   padding: const EdgeInsets.only(
                //       top: 5, left: 70, right: 70, bottom: 5),
                //   child: RaisedButton(
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(25)),
                //     color: Colors.indigo.shade800,
                //     onPressed: () {
                //       //_doctorContact();
                //       _trySubmitForm();
                //     },
                //     child: const Text(
                //       'Continue',
                //       style: TextStyle(
                //         fontSize: 20,
                //         fontWeight: FontWeight.w700,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tuk_boddy/api_service.dart';

class RegisterUser {
  String surgery = "";
}

class PatientThirdForm extends StatefulWidget {
  const PatientThirdForm({Key? key, required this.stepBack}) : super(key: key);
  final bool stepBack;
  @override
  State<PatientThirdForm> createState() => _PatientThirdFormState();
}

class _PatientThirdFormState extends State<PatientThirdForm> {
  final surgeryController = TextEditingController();

  final yearController = TextEditingController();

  final RegisterUser _data = RegisterUser();
  final _formKey = GlobalKey<FormState>();
  bool isInpuSurgeryValid = false;
  bool stepBack = false;

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _patientPriorSurgery();
    }
  }

  _patientPriorSurgery() async {
    ApiService.fetchData(context);

    ApiService.patienPriorSurgery(_data.surgery, yearController.text)
        .then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.pushNamed(context, 'PatientForthForm');
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
                        percent: 3 / 6,
                        animation: true,
                        lineHeight: 15.0,
                        barRadius: const Radius.circular(20),
                        progressColor: const Color(0xffff86b7),
                        center: const Text(
                          'Step 3 of 6',
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
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Please enter prior surgery details',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xffff86b7),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        userInput(
                            autovalidate: AutovalidateMode.onUserInteraction,
                            surgeryController,
                            'Please enter your prior surgery',
                            TextInputType.name, onChanged: ((value) {
                          _data.surgery = value;
                          setState(() {
                            validateSurgery(value);
                            if (validateSurgery(value) != null) {
                              isInpuSurgeryValid = false;
                            }
                          });
                        }),
                            suffixIcon: Icon(
                              isInpuSurgeryValid ? Icons.check : null,
                              color: Colors.green,
                            ),
                            validator: validateSurgery),
                        InkWell(
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 9,
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              // controller: dateinput,
                              controller: yearController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Please select year',
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
                                      DatePickerMode.year;

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('yyyy')
                                                .format(pickedDate);

                                        setState(() {
                                          yearController.text =
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
                                    fontSize: 18,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        )
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

  String? validateSurgery(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInpuSurgeryValid = true;
    });
    return null;
  }
}

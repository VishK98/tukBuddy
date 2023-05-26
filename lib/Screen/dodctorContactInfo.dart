// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tuk_boddy/api_service.dart';

class RegisterUser {
  String consultationFee = "";
  String email = "";
}

class DoctorContactInfo extends StatefulWidget {
  const DoctorContactInfo({Key? key, required this.stepBack}) : super(key: key);
  final bool stepBack;
  @override
  State<DoctorContactInfo> createState() => _DoctorContactInfoState();
}

class _DoctorContactInfoState extends State<DoctorContactInfo> {
  final consultationFeeController = TextEditingController();
  final emailController = TextEditingController();

  final RegisterUser _data = RegisterUser();
  final _formKey = GlobalKey<FormState>();
  bool isInputEmailValid = false;
  bool isInputFeeValid = false;
  bool stepBack = false;

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _doctorContact();
    }
  }

  _doctorContact() async {
    //print('LICENSENUMBER==>${_data.licenseNumber}');
    ApiService.fetchData(context);

    ApiService.doctorContactInfo(_data.consultationFee, _data.email)
        .then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.pushNamed(context, 'DoctorOfficetiming');
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
                      percent: 5 / 7,
                      animation: true,
                      lineHeight: 15.0,
                      barRadius: const Radius.circular(20),
                      progressColor: const Color(0xffff86b7),
                      center: const Text(
                        'Step 5 of 7',
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: userInput(
                          autovalidate: AutovalidateMode.onUserInteraction,
                          consultationFeeController,
                          'Enter your consultation fee',
                          TextInputType.number,
                          onChanged: ((value) {
                            _data.consultationFee = value;
                            setState(() {
                              validateFee(value);
                              if (validateFee(value) != null) {
                                isInputFeeValid = false;
                              }
                            });
                          }),
                          validator: validateFee,
                          suffixIcon: Icon(
                            isInputFeeValid ? Icons.check : null,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: userInput(
                          autovalidate: AutovalidateMode.onUserInteraction,
                          emailController,
                          'Enter your official email',
                          TextInputType.emailAddress,
                          onChanged: ((value) {
                            _data.email = value;
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
    );
  }

  String? validateEmail(value) {
    if (!RegExp("^[a-zA-Z0-9+_.-]+@+[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
      return 'Please a valid Email';
    }
    setState(() {
      isInputEmailValid = true;
    });
    return null;
  }

  String? validateFee(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputFeeValid = true;
    });
    return null;
  }
}

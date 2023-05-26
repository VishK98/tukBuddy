// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuk_boddy/Screen/patient2Form.dart';
import 'package:tuk_boddy/api_service.dart';

class RegisterUser {
  String address = "";
}

class PatientInformation extends StatefulWidget {
  const PatientInformation({
    Key? key,
    required this.stepBack,
  }) : super(key: key);
  final bool stepBack;
  @override
  State<PatientInformation> createState() => _PatientInformationState();
}

class _PatientInformationState extends State<PatientInformation> {
  String userName = '';
  String userID = '';
  String? _chosengenderValue;
  bool isInputAddressValid = false;
  bool stepBack = false;

  final addressController = TextEditingController();

  final dOBController = TextEditingController();

  final RegisterUser _data = RegisterUser();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name')!;
    });
  }

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _patientInfo();
    }
  }

  _patientInfo() async {
    ApiService.fetchData(context);

    ApiService.patientInfo(
            _data.address, _chosengenderValue, dOBController.text)
        .then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        // Navigator.pushNamed(context, 'PatientSecondForm');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientSecondForm(
                      stepBack: false,
                      gender: '$_chosengenderValue',
                    )));
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
            // _patientInfo();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        percent: 1 / 6,
                        animation: true,
                        lineHeight: 15.0,
                        barRadius: const Radius.circular(20),
                        progressColor: const Color(0xffff86b7),
                        center: const Text(
                          'Step 1 of 6',
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
                  height: MediaQuery.of(context).size.height * 0.600,
                  // height: MediaQuery.of(context).size.height * 0.700,
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
                        Text(
                          'Hey! $userName, Lets get to know you!',
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xffff86b7),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        userInput(
                            autovalidate: AutovalidateMode.onUserInteraction,
                            addressController,
                            'Please enter your address',
                            TextInputType.name, onChanged: ((value) {
                          _data.address = value;
                          setState(() {
                            validateAddress(value);
                            if (validateAddress(value) != null) {
                              isInputAddressValid = false;
                            }
                          });
                        }),
                            validator: validateAddress,
                            suffixIcon: Icon(
                              isInputAddressValid ? Icons.check : null,
                              color: Colors.green,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
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
                                value: _chosengenderValue,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(179, 64, 64, 64),
                                    fontStyle: FontStyle.italic),
                                items: <String>[
                                  'Male',
                                  'Female',
                                  'Other'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: const Text(
                                  "Please select your gender",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _chosengenderValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 9,
                          padding: const EdgeInsets.only(left: 15, right: 25),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: TextFormField(
                              controller: dOBController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Enter your date of birth',
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

  String? validateAddress(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputAddressValid = true;
    });
    return null;
  }
}

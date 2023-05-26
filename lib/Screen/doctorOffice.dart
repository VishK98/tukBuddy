// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tuk_boddy/api_service.dart';

class RegisterUser {
  String address = "";
}

class DoctorOfficeDetails extends StatefulWidget {
  const DoctorOfficeDetails({Key? key, required this.stepBack})
      : super(key: key);
  final bool stepBack;
  @override
  State<DoctorOfficeDetails> createState() => _DoctorOfficeDetailsState();
}

class _DoctorOfficeDetailsState extends State<DoctorOfficeDetails> {
  final addressController = TextEditingController();
  final bool _isChangingCountry = false;
  final bool _isChangingState = false;
  bool isInputAddressValid = false;
  bool stepBack = false;
  int addressLength = 0;

  final RegisterUser _data = RegisterUser();
  final _formKey = GlobalKey<FormState>();

  List<dynamic> data = [];
  List<dynamic> state = [];
  List<dynamic> city = [];

  var dropdownvalue;
  var dropdownvalue1;
  var dropdownvalue2;

  @override
  void initState() {
    _country();
    super.initState();
  }

  _country() {
    ApiService.country().then((value) {
      print(value);
      setState(() {
        data = value["data"]['Countries'];
        // print(data);
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
      _doctorOffice();
    }
  }

  _doctorOffice() {
    ApiService.fetchData(context);

    ApiService.doctorOffice(_data.address, dropdownvalue['name'],
            dropdownvalue1['state_name'], dropdownvalue2)
        .then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      // print('Free User ==> $value');
      if (value['status']) {
        // Navigator.pushNamed(context, 'DoctorOfficetiming');
        Navigator.pushNamed(context, 'DoctorContactInfo');
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
            // _doctorOffice();
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
                      percent: 4 / 7,
                      animation: true,
                      lineHeight: 15.0,
                      barRadius: const Radius.circular(20),
                      progressColor: const Color(0xffff86b7),
                      center: const Text(
                        'Step 4 of 7',
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: userInput(
                            autovalidate: AutovalidateMode.onUserInteraction,
                            addressController,
                            'Enter your office address',
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
                              decoration:
                                  const InputDecoration.collapsed(hintText: ''),
                              hint: const Text(
                                'Select your country',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                              isExpanded: true,
                              items: data.map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item['name'].toString()),
                                );
                              }).toList(),
                              onChanged: (item) {
                                setState(() {
                                  dropdownvalue1 = null;
                                  dropdownvalue = item;
                                  state = [];

                                  _state(dropdownvalue['id']);
                                  // print(dropdownvalue['name']);
                                });
                              },
                              value: dropdownvalue,
                            ),
                          ),
                        ),
                      ),
                      _isChangingCountry
                          ? const CircularProgressIndicator()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10),
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 9,
                                padding:
                                    const EdgeInsets.only(left: 15, right: 25),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration.collapsed(
                                        hintText: ''),
                                    hint: const Text(
                                      'Select your state',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    isExpanded: true,
                                    items: state.map((item) {
                                      return DropdownMenuItem(
                                        //value: item['state_name'].toString(),
                                        value: item,
                                        child:
                                            Text(item['state_name'].toString()),
                                      );
                                    }).toList(),
                                    onChanged: (item) {
                                      setState(() {
                                        dropdownvalue2 = null;

                                        dropdownvalue1 = item;
                                        city = [];

                                        // print(dropdownvalue1['state_name']);
                                        _city(dropdownvalue1['id']);
                                      });
                                    },
                                    value: dropdownvalue1,
                                  ),
                                ),
                              ),
                            ),
                      _isChangingState
                          ? const CircularProgressIndicator()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10),
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 9,
                                padding:
                                    const EdgeInsets.only(left: 15, right: 25),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration.collapsed(
                                        hintText: ''),
                                    hint: const Text(
                                      'Select your city',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    isExpanded: true,
                                    items: city.map((item) {
                                      return DropdownMenuItem(
                                        value: item['city_name'].toString(),
                                        child:
                                            Text(item['city_name'].toString()),
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
    );
  }

  String? validateAddress(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    } else if (addressLength > 3) {
      return 'Please enter valid input name';
    }
    setState(() {
      isInputAddressValid = true;
    });
    return null;
  }
}

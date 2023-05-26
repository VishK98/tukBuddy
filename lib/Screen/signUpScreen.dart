// ignore_for_file: use_key_in_widget_constructors, file_names, avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables, deprecated_member_use, use_build_context_synchronously

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuk_boddy/Screen/loginScreen.dart';
import 'package:tuk_boddy/api_service.dart';

class RegisterUser {
  String name = "";
  String username = '';
  String password = '';
  String namePratice = '';
  String email = '';
  String mobile = '';
  String licenseType = '';
  String licenseNumber = '';
  String country = '';
  String state = '';
}

bool isLoading = true;

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  List<dynamic> country = [];
  List<dynamic> state = [];

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final practicenameController = TextEditingController();
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  final licenseTypeController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final expirationDateController = TextEditingController();
  // final dateinput = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final RegisterUser _data = RegisterUser();
  bool _isChangingCountry = false;
  bool isInputValid = false;
  bool isInputNameValid = false;
  bool isInputUsernameValid = false;
  bool isInputmobileValid = false;
  bool isInputpraticeValid = false;
  bool isInputLTValid = false;
  bool isInputLNValid = false;

  String recivedID = '';
  String recivedIDpath = '';
  String profilePictureRecived = '';
  String recivedProfilePicturePath = '';
  String medicalLicenseRecived = '';
  String recivedMediaclLicensePath = '';
  String recivedDrivingLicensePath = '';

  String profileImage = '';

  var dropdownvalue;
  var dropdownvalue1;

  _getFromGallery() async {
    ImageSource.gallery;
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    print("pickedFilepickedFile_$pickedFile");

    // final ImagePicker picker = ImagePicker();

    // final XFile? pickedFile =
    //     await picker.pickImage(source: ImageSource.gallery);
    //     print("pickedFilepickedFile_${pickedFile}");
    if (pickedFile != null) {
      print('IMAGEPATH==> ${pickedFile.path}');

      return pickedFile.path.toString();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please try again!')));
    }
  }

  _country() async {
    ApiService.country().then((value) {
      setState(() {
        country = value["data"]['Countries'];
        // print(data);
      });
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isPermission") == null) {
      prefs.setBool("isPermission", true);
      await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
    }
  }

  _state(id) {
    setState(() {
      _isChangingCountry = true;
    });
    ApiService.state(id).then((value) {
      setState(() {
        state = value['data'];
        _isChangingCountry = false;
        //  print('HERE==>$state');
      });
    });
  }

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _signUp();
    }
  }

  _signUp() async {
    ApiService.fetchData(context);
    ApiService.register(
            _chosenValue,
            _data.name,
            _data.username,
            _data.namePratice,
            _data.password,
            _data.email,
            _data.mobile,
            _data.licenseType,
            _data.licenseNumber,
            _chosenValue == 'Doctor' ? dropdownvalue['name'] : '',
            _chosenValue == 'Doctor' ? dropdownvalue1 : '',
            profileImage,
            recivedIDpath,
            recivedMediaclLicensePath,
            recivedDrivingLicensePath,
            expirationDateController.text)
        .then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.pushNamed(context, 'LoginScreen');
      }
    });
  }

  bool passwordVisible = false;

  @override
  void initState() {
    //_getFromGallery();
    _country();
    passwordVisible = true;
    super.initState();
  }

  String? _chosenValue;

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
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(204, 221, 219, 219),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: hintTitle,
          suffixIcon: suffixIcon,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              width: 250,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: const Color(0xff4f4f4f),
                onPressed: () {
                  _trySubmitForm();
                },
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffff86b7),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an Account ?   ',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        curve: Curves.linear,
                        duration: const Duration(milliseconds: 400),
                        type: PageTransitionType.rightToLeftWithFade,
                        isIos: true,
                        child: LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox()
          ],
        ),
      ),
      backgroundColor: const Color(0xff4f4f4f),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset(
                      'assets/images/tukBuddy.png',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .650,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
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
                                value: _chosenValue,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                                items: <String>[
                                  'Doctor',
                                  'Patient',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                isExpanded: true,
                                hint: const Text(
                                  "You are signing up as ?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _chosenValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              userInput(
                                  autovalidate:
                                      AutovalidateMode.onUserInteraction,
                                  nameController,
                                  'Name',
                                  TextInputType.name, onChanged: ((value) {
                                _data.name = value;
                                setState(() {
                                  validateName(value);
                                  if (validateName(value) != null) {
                                    isInputNameValid = false;
                                  }
                                });
                              }),
                                  validator: validateName,
                                  suffixIcon: Icon(
                                    isInputNameValid ? Icons.check : null,
                                    color: Colors.green,
                                  )),
                              userInput(
                                autovalidate:
                                    AutovalidateMode.onUserInteraction,
                                usernameController,
                                'Username',
                                TextInputType.name,
                                onChanged: ((value) {
                                  _data.username = value;
                                  setState(() {
                                    validateUsername(value);
                                    if (validateUsername(value) != null) {
                                      isInputUsernameValid = false;
                                    }
                                  });
                                }),
                                validator: validateUsername,
                                suffixIcon: Icon(
                                  isInputUsernameValid ? Icons.check : null,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                width: MediaQuery.of(context).size.width * .9,
                                child: TextFormField(
                                  obscureText: passwordVisible,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    // helperText: '',
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(204, 221, 219, 219),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    hintText: 'Enter password',
                                    labelStyle: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                    hintStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    if (value.trim().length < 8) {
                                      return 'Password must be at least 8 characters in length';
                                    }
                                    return null;
                                  },
                                  onChanged: ((value) {
                                    _data.password = value;
                                  }),
                                ),
                              ),
                              userInput(
                                  numberController,
                                  'Mobile Number',
                                  autovalidate:
                                      AutovalidateMode.onUserInteraction,
                                  TextInputType.number, onChanged: ((value) {
                                _data.mobile = value;
                                setState(() {
                                  validateMobile(value);
                                  if (validateMobile(value) != null) {
                                    isInputmobileValid = false;
                                  }
                                });
                              }),
                                  validator: validateMobile,
                                  suffixIcon: Icon(
                                    isInputmobileValid ? Icons.check : null,
                                    color: Colors.green,
                                  )),
                              userInput(
                                autovalidate:
                                    AutovalidateMode.onUserInteraction,
                                emailController,
                                'Email',
                                TextInputType.emailAddress,
                                onChanged: ((value) {
                                  _data.email = value;
                                  setState(() {
                                    validateEmail(value);
                                    if (validateEmail(value) != null) {
                                      isInputValid = false;
                                    }
                                  });
                                }),
                                validator: validateEmail,
                                suffixIcon: Icon(
                                  isInputValid ? Icons.check : null,
                                  color: Colors.green,
                                ),
                              ),
                              _chosenValue == 'Patient'
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: InkWell(
                                        onTap: () async {
                                          recivedIDpath =
                                              await _getFromGallery();
                                          setState(() {
                                            recivedIDpath = recivedIDpath;
                                          });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          height: 60,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              9,
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 25),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              recivedIDpath == ''
                                                  ? const Text(
                                                      "Upload your ID ",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black54,
                                                      ),
                                                    )
                                                  : const Text(
                                                      'Your ID is uploaded',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                              const Icon(
                                                Icons.file_copy_outlined,
                                                color: Colors.black54,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: InkWell(
                                  onTap: () async {
                                    profileImage = await _getFromGallery();
                                    setState(() {
                                      profileImage = profileImage;
                                    });
                                  },
                                  child: Container(
                                    height: 60,
                                    width:
                                        MediaQuery.of(context).size.width * 9,
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 25),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        profileImage == ''
                                            ? const Text(
                                                "Upload your profile picture ",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black54,
                                                ),
                                              )
                                            : const Text(
                                                'Your profile picture is uploaded',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                        const Icon(
                                          Icons.file_copy_outlined,
                                          color: Colors.black54,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _chosenValue == 'Doctor'
                                  ? userInput(
                                      autovalidate:
                                          AutovalidateMode.onUserInteraction,
                                      practicenameController,
                                      'Name of Practice',
                                      TextInputType.name, onChanged: ((value) {
                                      _data.namePratice = value;
                                      setState(() {
                                        validateNamepractice(value);
                                        if (validateNamepractice(value) !=
                                            null) {
                                          isInputpraticeValid = false;
                                        }
                                      });
                                    }),
                                      validator: validateNamepractice,
                                      suffixIcon: Icon(
                                        isInputpraticeValid
                                            ? Icons.check
                                            : null,
                                        color: Colors.green,
                                      ))
                                  : Container(),
                              _chosenValue == 'Doctor'
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: InkWell(
                                        onTap: () async {
                                          recivedMediaclLicensePath =
                                              await _getFromGallery();
                                          setState(() {
                                            recivedMediaclLicensePath =
                                                recivedMediaclLicensePath;
                                          });
                                        },
                                        child: Container(
                                          height: 60,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              9,
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 25),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              recivedMediaclLicensePath == ''
                                                  ? const Text(
                                                      "Upload your Medical license ",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black54,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    )
                                                  : const Text(
                                                      // recivedMediaclLicensePath,
                                                      'Your medical license is uploaded',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                              const Icon(
                                                Icons.file_copy_outlined,
                                                color: Colors.black54,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              _chosenValue == 'Doctor'
                                  ? userInput(
                                      autovalidate:
                                          AutovalidateMode.onUserInteraction,
                                      licenseTypeController,
                                      'License type',
                                      TextInputType.name, onChanged: ((value) {
                                      _data.licenseType = value;
                                      setState(() {
                                        validateLicenseType(value);
                                        if (validateLicenseType(value) !=
                                            null) {
                                          isInputLTValid = false;
                                        }
                                      });
                                    }),
                                      validator: validateLicenseType,
                                      suffixIcon: Icon(
                                        isInputLTValid ? Icons.check : null,
                                        color: Colors.green,
                                      ))
                                  : Container(),
                              _chosenValue == 'Doctor'
                                  ? userInput(
                                      autovalidate:
                                          AutovalidateMode.onUserInteraction,
                                      licenseNumberController,
                                      'License number',
                                      TextInputType.name, onChanged: ((value) {
                                      _data.licenseNumber = value;
                                      setState(() {
                                        validateLicenseNumber(value);
                                        if (validateLicenseNumber(value) !=
                                            null) {
                                          isInputLNValid = false;
                                        }
                                      });
                                    }),
                                      validator: validateLicenseNumber,
                                      suffixIcon: Icon(
                                        isInputLNValid ? Icons.check : null,
                                        color: Colors.green,
                                      ))
                                  : Container(),
                              _chosenValue == 'Doctor'
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Container(
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                9,
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 25),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: DropdownButtonFormField(
                                            decoration:
                                                const InputDecoration.collapsed(
                                                    hintText: ''),
                                            hint: const Text(
                                              'Select your country',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            isExpanded: true,
                                            items: country.map((item) {
                                              return DropdownMenuItem(
                                                value: item,
                                                child: Text(
                                                    item['name'].toString()),
                                              );
                                            }).toList(),
                                            onChanged: (item) {
                                              setState(() {
                                                dropdownvalue1 = null;
                                                dropdownvalue = item;
                                                state = [];
                                                _state(dropdownvalue['id']);
                                              });
                                            },
                                            value: dropdownvalue,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              _chosenValue == 'Doctor'
                                  ? _isChangingCountry
                                      ? const CircularProgressIndicator()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Container(
                                            height: 60,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                9,
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 25),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: DropdownButtonFormField(
                                                decoration:
                                                    const InputDecoration
                                                            .collapsed(
                                                        hintText: ''),
                                                hint: const Text(
                                                  'Select your state',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                isExpanded: true,
                                                items: state.map((item) {
                                                  return DropdownMenuItem(
                                                    value: item['state_name']
                                                        .toString(),
                                                    child: Text(
                                                        item['state_name']
                                                            .toString()),
                                                  );
                                                }).toList(),
                                                onChanged: (newVal) {
                                                  setState(() {
                                                    dropdownvalue1 = newVal;
                                                    print(dropdownvalue1);
                                                  });
                                                },
                                                value: dropdownvalue1,
                                              ),
                                            ),
                                          ),
                                        )
                                  : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              _chosenValue == 'Doctor'
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: InkWell(
                                        child: Container(
                                          height: 60,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              9,
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 25),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: TextFormField(
                                              controller:
                                                  expirationDateController,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Select Medical license expiry date',
                                                border: InputBorder.none,
                                                suffixIcon: InkWell(
                                                    onTap: () async {
                                                      DateTime? pickedDate =
                                                          await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate: DateTime(
                                                                  1947), //DateTime.now() - not to allow to choose before today.
                                                              lastDate:
                                                                  DateTime(
                                                                      2101));

                                                      if (pickedDate != null) {
                                                        String formattedDate =
                                                            DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(
                                                                    pickedDate);

                                                        setState(() {
                                                          expirationDateController
                                                                  .text =
                                                              formattedDate; //set output date to TextField value.
                                                        });
                                                      } else {
                                                        print(
                                                            "Date is not selected");
                                                      }
                                                    },
                                                    child: const Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      color: Colors.black54,
                                                    )),
                                                hintStyle: const TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              _chosenValue == 'Doctor'
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: InkWell(
                                        onTap: () async {
                                          recivedDrivingLicensePath =
                                              await _getFromGallery();
                                          setState(() {
                                            recivedDrivingLicensePath =
                                                recivedDrivingLicensePath;
                                          });
                                        },
                                        child: Container(
                                          height: 60,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              9,
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 25),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              recivedDrivingLicensePath == ''
                                                  ? const Text(
                                                      "Upload your driving license ",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black54,
                                                      ),
                                                    )
                                                  : const Text(
                                                      'Your driving license is uploaded',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                              const Icon(
                                                Icons.file_copy_outlined,
                                                color: Colors.black54,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validateMobile(value) {
    // Indian Mobile number are of 10 digit only
    if (value!.length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else {
      setState(() {
        isInputmobileValid = true;
      });
      return null;
    }
  }

  String? validateEmail(value) {
    if (!RegExp("^[a-zA-Z0-9+_.-]+@+.[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
      return 'Please a valid Email';
    }
    setState(() {
      isInputValid = true;
    });
    return null;
  }

  String? validateName(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputNameValid = true;
    });
    return null;
  }

  String? validateNamepractice(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputpraticeValid = true;
    });
    return null;
  }

  String? validateLicenseType(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputLTValid = true;
    });
    return null;
  }

  String? validateLicenseNumber(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputLNValid = true;
    });
    return null;
  }

  String? validateUsername(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    } else if (value.contains(' ')) {
      return 'Enter username without using space';
    }
    setState(() {
      isInputUsernameValid = true;
    });
    return null;
  }
}

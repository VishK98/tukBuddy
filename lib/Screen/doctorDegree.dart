// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuk_boddy/Screen/doctorPraticeFocus.dart';
import 'package:tuk_boddy/api_service.dart';

class RegisterUser {
  String degreeName = "";
  String place = '';
}

class DoctorDegree extends StatefulWidget {
  const DoctorDegree({Key? key, required this.stepBack}) : super(key: key);
  final bool stepBack;
  @override
  State<DoctorDegree> createState() => _DoctorDegreeState();
}

class _DoctorDegreeState extends State<DoctorDegree> {
  final degreenameController = TextEditingController();
  final placeController = TextEditingController();
  final degreeCompletionsController = TextEditingController();

  final RegisterUser _data = RegisterUser();

  final _formKey = GlobalKey<FormState>();

  String degreeImage = '';
  bool isInputDegreeValid = false;
  bool isInputPlaceValid = false;
  bool stepBack = false;

  int textLength = 0;
  int placetextLength = 0;

  @override
  void initState() {
    _getPermission();
    super.initState();
  }

  _getPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("isCameraPermission") == null) {
      prefs.setBool("isCameraPermission", true);
      await ImagePicker().pickImage(source: ImageSource.camera);
    }
    if (prefs.getBool("isPermission") == null) {
      prefs.setBool("isPermission", true);
      await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
    }
  }

  _getFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      print('IMAGEPATH==> ${pickedFile.path}');

      return pickedFile.path.toString();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please try again!')));
    }
  }

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _docctorDegree();
    }
  }

  _docctorDegree() async {
    ApiService.fetchData(context);

    ApiService.doctorDegree(_data.degreeName, _data.place, degreeImage,
            degreeCompletionsController.text)
        .then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        degreenameController.clear();
        degreeCompletionsController.clear();

        placeController.clear();
        Navigator.push(
          context,
          PageTransition(
            curve: Curves.linear,
            duration: const Duration(milliseconds: 400),
            type: PageTransitionType.leftToRightWithFade,
            isIos: true,
            child: DoctorPracticeFocus(
              stepBack: false,
            ),
          ),
        );
      }
    });
  }

  Widget userInput(TextEditingController userInput, String hintTitle,
      bool enabled, TextInputType keyboardType,
      {required Null Function(dynamic value) onChanged,
      required String? Function(dynamic value) validator,
      required autovalidate,
      required Icon suffixIcon}) {
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
                      percent: 2 / 7,
                      animation: true,
                      lineHeight: 15.0,
                      barRadius: const Radius.circular(20),
                      progressColor: const Color(0xffff86b7),
                      center: const Text(
                        'Step 2 of 7',
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          userInput(
                              autovalidate: AutovalidateMode.onUserInteraction,
                              degreenameController,
                              'Degree name',
                              true,
                              TextInputType.name, onChanged: ((value) {
                            _data.degreeName = value;
                            setState(() {
                              validateDegreeName(value);
                              if (validateDegreeName(value) != null) {
                                isInputDegreeValid = false;
                              }
                            });
                          }),
                              validator: validateDegreeName,
                              suffixIcon: Icon(
                                isInputDegreeValid ? Icons.check : null,
                                color: Colors.green,
                              )),
                          userInput(
                              autovalidate: AutovalidateMode.onUserInteraction,
                              placeController,
                              'Place of completion',
                              true,
                              TextInputType.name, onChanged: ((value) {
                            _data.place = value;
                            setState(() {
                              validatePlace(value);
                              if (validatePlace(value) != null) {
                                isInputPlaceValid = false;
                              }
                            });
                          }),
                              validator: validatePlace,
                              suffixIcon: Icon(
                                isInputPlaceValid ? Icons.check : null,
                                color: Colors.green,
                              )),
                          InkWell(
                            onTap: () async {
                              degreeImage = await _getFromGallery();
                              setState(() {
                                degreeImage = degreeImage;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              height: 60,
                              width: MediaQuery.of(context).size.width * 9,
                              padding:
                                  const EdgeInsets.only(left: 15, right: 25),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  degreeImage == ''
                                      ? const Text(
                                          "Upload your degree",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black54,
                                          ),
                                        )
                                      : const Text(
                                          'Your degree is uploaded',
                                          style: TextStyle(
                                            fontSize: 15,
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
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            child: Container(
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              height: 60,
                              width: MediaQuery.of(context).size.width * 9,
                              padding:
                                  const EdgeInsets.only(left: 15, right: 25),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: TextFormField(
                                  // controller: dateinput,
                                  controller: degreeCompletionsController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Select your degree completion year',
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
                                          // initialDatePickerMode:
                                          // DatePickerMode.year;

                                          if (pickedDate != null) {
                                            String formattedDate =
                                                // DateFormat('yyyy-MM-dd')
                                                //     .format(pickedDate);
                                                DateFormat('yyyy')
                                                    .format(pickedDate);

                                            setState(() {
                                              degreeCompletionsController.text =
                                                  formattedDate; //set output date to TextField value.
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
                                        fontSize: 17,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateDegreeName(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    } else if (textLength > 3) {
      return 'Please enter valid degree name';
    }
    setState(() {
      isInputDegreeValid = true;
    });
    return null;
  }

  String? validatePlace(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    } else if (placetextLength > 3) {
      return 'Please enter valid input name';
    }
    setState(() {
      isInputPlaceValid = true;
    });
    return null;
  }
}

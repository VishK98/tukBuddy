// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tuk_boddy/api_service.dart';

class RegisterUser {
  String surgery = "";
  String problem = "";
  String desiredOutcomes = "";
}

class PatientForthForm extends StatefulWidget {
  const PatientForthForm({
    Key? key,
    required this.stepBack,
  }) : super(key: key);
  final bool stepBack;
  @override
  State<PatientForthForm> createState() => _PatientForthFormState();
}

class _PatientForthFormState extends State<PatientForthForm> {
  final surgeryController = TextEditingController();
  final problemController = TextEditingController();
  final desiredOutcomesController = TextEditingController();

  final RegisterUser _data = RegisterUser();
  final _formKey = GlobalKey<FormState>();
  bool isInputTreatmentValid = false;
  bool isInputproblemValid = false;
  bool isInputoutComesValid = false;
  bool stepBack = false;
  List<XFile>? selectedImages = [];
  final picker = ImagePicker();

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _patientTreatmentNeed();
    }
  }

  openGallery() async {
    selectedImages = [];
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick.isNotEmpty) {
          selectedImages!.addAll(pickedFile);
          // print('PICKED==>${selectedImages}');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  _patientTreatmentNeed() async {
    ApiService.fetchData(context);
    print(selectedImages);
    ApiService.patientTreatmentNeed(
            _data.surgery, _data.problem, _data.desiredOutcomes, selectedImages)
        .then((value) {
      print('VALUE==>$value');
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.pushNamed(context, 'PatientFifthForm');
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
            // _patientTreatmentNeed();
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
                        percent: 4 / 6,
                        animation: true,
                        lineHeight: 15.0,
                        barRadius: const Radius.circular(20),
                        progressColor: const Color(0xffff86b7),
                        center: const Text(
                          'Step 4 of 6',
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
                          'Getting Excited? We Are!!',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xffff86b7),
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
                          child: userInput(
                            autovalidate: AutovalidateMode.onUserInteraction,
                            surgeryController,
                            'Enter the treatment you want',
                            TextInputType.name,
                            onChanged: ((value) {
                              _data.surgery = value;
                              setState(() {
                                validatetreatment(value);
                                if (validatetreatment(value) != null) {
                                  isInputTreatmentValid = false;
                                }
                              });
                            }),
                            validator: validatetreatment,
                            suffixIcon: Icon(
                              isInputTreatmentValid ? Icons.check : null,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        surgeryController.text.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: userInput(
                                  autovalidate:
                                      AutovalidateMode.onUserInteraction,
                                  problemController,
                                  'Please enter your problem',
                                  TextInputType.name,
                                  onChanged: ((value) {
                                    _data.problem = value;
                                    setState(() {
                                      validateProblem(value);
                                      if (validateProblem(value) != null) {
                                        isInputproblemValid = false;
                                      }
                                    });
                                  }),
                                  validator: validateProblem,
                                  suffixIcon: Icon(
                                    isInputproblemValid ? Icons.check : null,
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            : Container(),
                        problemController.text.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: userInput(
                                  autovalidate:
                                      AutovalidateMode.onUserInteraction,
                                  desiredOutcomesController,
                                  'Enter desire outcomes after treatment',
                                  TextInputType.name,
                                  onChanged: ((value) {
                                    _data.desiredOutcomes = value;
                                    setState(() {
                                      validateOutcomes(value);
                                      if (validateOutcomes(value) != null) {
                                        isInputoutComesValid = false;
                                      }
                                    });
                                  }),
                                  validator: validateOutcomes,
                                  suffixIcon: Icon(
                                    isInputoutComesValid ? Icons.check : null,
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            : Container(),
                        desiredOutcomesController.text.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  openGallery();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 18, right: 18),
                                  height: 60,
                                  width: MediaQuery.of(context).size.width * 9,
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 25),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      selectedImages!.isEmpty
                                          ? const Text(
                                              "Please upload your body part images",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54,
                                              ),
                                            )
                                          : Text(
                                              'You have selected ${selectedImages!.length} images',
                                              style: const TextStyle(
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

  String? validatetreatment(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputTreatmentValid = true;
    });
    return null;
  }

  String? validateProblem(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputproblemValid = true;
    });
    return null;
  }

  String? validateOutcomes(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputoutComesValid = true;
    });
    return null;
  }
}

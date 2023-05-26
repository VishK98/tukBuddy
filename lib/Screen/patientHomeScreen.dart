// ignore_for_file: file_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tuk_boddy/api_service.dart';

class LoginUser {
  String question = '';
  String options = '';
}

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final LoginUser _data = LoginUser();
  List<dynamic> post = [];
  List<File> selectedImages = [];

  bool isLoading = true;
  int textLength = 0;
  var imagePath;
  final picker = ImagePicker();

  final questionController = TextEditingController();
  final optionsController = TextEditingController();
  final imageController = TextEditingController();

  String recivedImage = '';

  @override
  void initState() {
    _postForPatient();
    super.initState();
  }

  _patientOpinionPool() {
    ApiService.fetchData(context);
    ApiService.patientOpinionPool(_data.question, _data.options, imagePath)
        .then((value) {
      // print('MakePost ==> $value');
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        setState(() {
          questionController.clear();
          optionsController.clear();
          selectedImages.clear();
          // print('Lengh==>${selectedImages.length}');
        });
      }
    });
  }

  getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
            setState(() {
              imagePath = xfilePick[i].path;
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  _postForPatient() async {
    ApiService.postForPatient().then((value) {
      setState(() {
        post = value['data'];
        isLoading = false;
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

  Widget userInput(
    TextEditingController userInput,
    String hintTitle,
    TextInputType keyboardType, {
    required Null Function(dynamic value) onChanged,
    required String? Function(dynamic value) validator,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      height: 45,
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
        backgroundColor: const Color.fromARGB(255, 247, 245, 245),
        body: SafeArea(
            child: isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xffff86b7),
                  ))
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            width: MediaQuery.of(context).size.width * 9,
                            height: 280,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'You can make your opinion pool here',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    userInput(
                                      questionController,
                                      'Write your question here...',
                                      TextInputType.emailAddress,
                                      onChanged: ((value) {
                                        _data.question = value;
                                      }),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    userInput(
                                      optionsController,
                                      'Write your options atleast four...',
                                      TextInputType.emailAddress,
                                      onChanged: ((value) {
                                        _data.options = value;
                                      }),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        getImages();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 30, top: 10),
                                        height: 45,
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            selectedImages.isEmpty
                                                ? const Text(
                                                    "Please select your image",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black54,
                                                    ),
                                                  )
                                                : Text(
                                                    'You have selected ${selectedImages.length} images',
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
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: const Color(0xff4f4f4f),
                                        onPressed: () {
                                          // print('Clicked');
                                          // _trySubmitForm();
                                          if (questionController.text.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Please write your question')));
                                          } else if (optionsController
                                              .text.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Please write your options')));
                                          } else {
                                            _patientOpinionPool();
                                          }
                                        },
                                        child: const Text(
                                          'Post',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xffff86b7),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: post.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                          radius: 20,
                                          child: ClipOval(
                                            child: AspectRatio(
                                              aspectRatio: 1,
                                              child: Image.network(
                                                '${URLS.IMAGE_URL}${post[index]["profile_pic"]}',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )),
                                      title: Text('${post[index]['post']}'),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  )));
  }
}

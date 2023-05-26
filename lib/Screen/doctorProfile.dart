// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuk_boddy/Screen/doctorDegree.dart';
import 'package:tuk_boddy/api_service.dart';

class RegisterUser {
  String instagramProfile = "";
  String tiktokProfile = '';
  String facebookProfile = '';
  String snapchatProfile = '';
  String twitterProfile = '';
  String pinterestProfile = '';
  String otherProfile = '';
  String practiceInfo = '';
}

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({Key? key}) : super(key: key);

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  List<dynamic> data = [];

  bool isInputpracticeValid = false;

  final picker = ImagePicker();

  // String membership = '';

  final instagramProfileController = TextEditingController();
  final tiktokProfileController = TextEditingController();
  final facebookProfileController = TextEditingController();
  final snapchatProfileController = TextEditingController();
  final twitterProfileController = TextEditingController();
  final pinterestProfileController = TextEditingController();
  final otherProfileController = TextEditingController();
  final practiceInfoController = TextEditingController();

  final RegisterUser _data = RegisterUser();

  final _formKey = GlobalKey<FormState>();

  String facilityImage = '';
  String beforeImage = '';
  String afterImage = '';
  String fileName = '';
  // List<Asset> images = <Asset>[];
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  List<XFile>? selectedImages = [];
  List<XFile>? selectedAfterImages = [];
  List<XFile>? selectedfacilityImages = [];

  @override
  void initState() {
    _membershipInfo();
    super.initState();
  }

  bool isLoading = true;

  _membershipInfo() async {
    ApiService.membershipInfo().then((value) {
      // print("purchasedMembership==>$value");
      setState(() {
        data = value["data"];
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

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      debugPrint('Everything looks good!');
      _docctorInfo();
    }
  }

  _docctorInfo() async {
    ApiService.fetchData(context);

    ApiService.doctorInfo(
            _data.instagramProfile,
            _data.tiktokProfile,
            _data.facebookProfile,
            _data.snapchatProfile,
            _data.twitterProfile,
            _data.pinterestProfile,
            _data.otherProfile,
            _data.practiceInfo,
            selectedfacilityImages,
            selectedImages,
            selectedAfterImages)
        .then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.push(
          context,
          PageTransition(
            curve: Curves.linear,
            duration: const Duration(milliseconds: 400),
            type: PageTransitionType.leftToRightWithFade,
            isIos: true,
            child: const DoctorDegree(
              stepBack: false,
            ),
          ),
        );
      }
    });
  }

  Widget userInput(
    TextEditingController userInput,
    String hintTitle,
    bool enabled,
    TextInputType keyboardType, {
    required Null Function(dynamic value) onChanged,
    required String? Function(dynamic value) validator,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      height: 70,
      child: TextFormField(
        enabled: enabled,
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
    // var image = selectedImages.length;
    // print('You have selected $image images');
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
            if (data[0]['id'] == 1) {
              _docctorInfo();
            } else {
              _trySubmitForm();
            }
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                // color: Colors.amber,
                height: MediaQuery.of(context).size.height * .3,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          size: 20,
                          color: Colors.white60,
                        )),
                    Center(
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Image.asset(
                          'assets/images/tukBuddy.png',
                        ),
                      ),
                    ),
                    LinearPercentIndicator(
                      percent: 1 / 7,
                      animation: true,
                      lineHeight: 15.0,
                      barRadius: const Radius.circular(20),
                      progressColor: const Color(0xffff86b7),
                      center: const Text(
                        'Step 1 of 7',
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
                child: data.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.red[50]),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                userInput(
                                  instagramProfileController,
                                  data[0]['id'] == 1
                                      ? 'Instagram profile (Only for paid membership)'
                                      : 'Instagram profile',
                                  data[0]['id'] == 1 ? false : true,
                                  TextInputType.name,
                                  onChanged: ((value) {
                                    _data.instagramProfile = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                userInput(
                                  tiktokProfileController,
                                  // 'Tiktok profile',
                                  data[0]['id'] == 1
                                      ? 'Tiktok profile (Only for paid membership)'
                                      : 'Tiktok profile',
                                  data[0]['id'] == 1 ? false : true,
                                  TextInputType.name,
                                  onChanged: ((value) {
                                    _data.tiktokProfile = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                userInput(
                                  facebookProfileController,
                                  // 'Facebook profile',
                                  data[0]['id'] == 1
                                      ? 'Facebook profile (Only for paid membership)'
                                      : 'Facebook profile',
                                  data[0]['id'] == 1 ? false : true,
                                  TextInputType.name,
                                  onChanged: ((value) {
                                    _data.facebookProfile = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                userInput(
                                  snapchatProfileController,
                                  // 'Snapchat profile',
                                  data[0]['id'] == 1
                                      ? 'Snapchat profile (Only for paid membership)'
                                      : 'Snapchat profile',
                                  data[0]['id'] == 1 ? false : true,
                                  TextInputType.name,
                                  onChanged: ((value) {
                                    _data.snapchatProfile = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                userInput(
                                  twitterProfileController,
                                  // 'Twitter profile',
                                  data[0]['id'] == 1
                                      ? 'Twitter profile (Only for paid membership)'
                                      : 'Twitter profile',
                                  data[0]['id'] == 1 ? false : true,
                                  TextInputType.name,
                                  onChanged: ((value) {
                                    _data.twitterProfile = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                userInput(
                                  pinterestProfileController,
                                  // 'Pinterest profile',
                                  data[0]['id'] == 1
                                      ? 'Pinterest profile (Only for paid membership)'
                                      : 'Pinterest profile',
                                  data[0]['id'] == 1 ? false : true,
                                  TextInputType.name,
                                  onChanged: ((value) {
                                    _data.pinterestProfile = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                userInput(
                                  otherProfileController,
                                  // 'Other profile',
                                  data[0]['id'] == 1
                                      ? 'Other profile (Only for paid membership)'
                                      : 'Other profile',
                                  data[0]['id'] == 1 ? false : true,
                                  TextInputType.name,
                                  onChanged: ((value) {
                                    _data.otherProfile = value;
                                  }),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .9,
                                  //  height: 70,
                                  child: TextFormField(
                                    enabled: data[0]['id'] == 1 ? false : true,
                                    onChanged: ((value) {
                                      _data.practiceInfo = value;
                                      setState(() {
                                        validatePratice(value);
                                        if (validatePratice(value) != null) {
                                          isInputpracticeValid = false;
                                        }
                                      });
                                    }),
                                    validator: data[0]['id'] == 1
                                        ? validatePratice
                                        : null,
                                    controller: practiceInfoController,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      constraints: const BoxConstraints(
                                        maxHeight: 130,
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              204, 221, 219, 219),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      hintText: data[0]['id'] == 1
                                          ? 'Practice profile (Only for paid membership)'
                                          : 'Practice profile',
                                      suffixIcon: Icon(
                                        isInputpracticeValid
                                            ? Icons.check
                                            : null,
                                        color: Colors.green,
                                      ),
                                      hintStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    maxLines: 5,
                                    minLines: 1,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () async {
                                    await getfacilityImages();
                                  },
                                  child: Container(
                                    height: 60,
                                    width:
                                        MediaQuery.of(context).size.width * 9,
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 25),
                                    margin: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        selectedfacilityImages!.isEmpty
                                            ? const Text(
                                                "Upload your facility picture",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black54,
                                                ),
                                              )
                                            : Text(
                                                'You have selected ${selectedfacilityImages!.length} images',
                                                style: const TextStyle(
                                                  // fontSize: 15,
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
                                  onTap: () async {
                                    getBeforeImages();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 5, right: 5),
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
                                        selectedImages!.isEmpty
                                            ? const Text(
                                                "Upload your before image",
                                                style: TextStyle(
                                                  fontSize: 18,
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
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    getAfterImages();
                                  },
                                  child: Container(
                                    height: 60,
                                    width:
                                        MediaQuery.of(context).size.width * 9,
                                    margin: const EdgeInsets.only(
                                        left: 5, right: 5),
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
                                        selectedAfterImages!.isEmpty
                                            ? const Text(
                                                "Upload your after image",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black54,
                                                ),
                                              )
                                            : Text(
                                                'You have selected ${selectedAfterImages!.length} images',
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

  getfacilityImages() async {
    selectedfacilityImages = [];
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
    if (data[0]['id'] == 1) {
      if (xfilePick.isNotEmpty && xfilePick.length <= 1) {
        setState(
          () {
            if (xfilePick.isNotEmpty) {
              selectedfacilityImages!.addAll(pickedFile);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nothing is selected')));
            }
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sorry! you can not select more than one image')));
      }
    } else if (data[0]['id'] == 2) {
      if (xfilePick.isNotEmpty && xfilePick.length <= 5) {
        setState(
          () {
            if (xfilePick.isNotEmpty) {
              selectedfacilityImages!.addAll(pickedFile);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nothing is selected')));
            }
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sorry! you can not select more than 5 images')));
      }
    } else {
      if (xfilePick.isNotEmpty && xfilePick.length <= 5) {
        setState(
          () {
            if (xfilePick.isNotEmpty) {
              selectedfacilityImages!.addAll(pickedFile);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nothing is selected')));
            }
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sorry! you can not select more than 5 images')));
      }
    }
  }

  getBeforeImages() async {
    selectedImages = [];
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
    if (data[0]['id'] == 1) {
      print('FirstMember==>');
      if (xfilePick.isNotEmpty && xfilePick.length <= 3) {
        setState(
          () {
            if (xfilePick.isNotEmpty) {
              selectedImages!.addAll(pickedFile);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nothing is selected')));
            }
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sorry! you can not select more than 3 images')));
      }
    } else if (data[0]['id'] == 2) {
      print('Second Member==>');
      if (xfilePick.isNotEmpty && xfilePick.length <= 10) {
        setState(
          () {
            if (xfilePick.isNotEmpty) {
              selectedImages!.addAll(pickedFile);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nothing is selected')));
            }
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sorry! you can not select more than 10 images')));
      }
    } else {
      if (xfilePick.isNotEmpty && xfilePick.length <= 36) {
        setState(
          () {
            if (xfilePick.isNotEmpty) {
              selectedImages!.addAll(pickedFile);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nothing is selected')));
            }
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sorry! you can not select more than 36 images')));
      }
    }
  }

  getAfterImages() async {
    selectedAfterImages = [];
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
    if (data[0]['id'] == 1) {
      if (xfilePick.isNotEmpty && xfilePick.length <= 3) {
        setState(
          () {
            if (xfilePick.isNotEmpty) {
              selectedAfterImages!.addAll(pickedFile);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nothing is selected')));
            }
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sorry! you can not select more than 3 images')));
      }
    } else if (data[0]['id'] == 2) {
      if (xfilePick.isNotEmpty && xfilePick.length <= 10) {
        setState(
          () {
            if (xfilePick.isNotEmpty) {
              selectedAfterImages!.addAll(pickedFile);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nothing is selected')));
            }
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sorry! you can not select more than 10 images')));
      }
    } else {
      if (xfilePick.isNotEmpty && xfilePick.length <= 36) {
        setState(
          () {
            if (xfilePick.isNotEmpty) {
              selectedAfterImages!.addAll(pickedFile);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nothing is selected')));
            }
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sorry! you can not select more than 36 images')));
      }
    }
  }

  String? validatePratice(value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    setState(() {
      isInputpracticeValid = true;
    });
    return null;
  }
}

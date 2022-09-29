import 'dart:convert';
import 'dart:typed_data';

import 'package:chatinunii/authScreens/signup.dart';
import 'package:chatinunii/components/primary_button.dart';
import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/constants.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/screens/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';

class UploadPhoto extends StatefulWidget {
  final flag;
  const UploadPhoto({required this.flag});

  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  final translator = GoogleTranslator();
  var selectPhoto;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(text: 'upload_photo'.tr),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05,
                    bottom: MediaQuery.of(context).size.height * 0.05),
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: localmage == null
                        ? DecorationImage(
                            image: AssetImage('assets/images/default.jpg'))
                        : DecorationImage(
                            image: MemoryImage(base64Decode(localmage)))),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.02),
                child: PrimaryButton(
                    text: 'select_photo'.tr,
                    press: () {
                      chooseImage();
                    }),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: PrimaryButton(
                      text: 'upload_photo'.tr,
                      press: () {
                        Apis()
                            .uploadPhoto('${usernamecontroller.text}}',
                                base64Decode(localmage))
                            .then((value) {
                          if (value == 'Bad Request') {
                            showToast('something_went_wrong'.tr);
                          } else {
                            if (jsonDecode(value)['IsSuccess'] == true) {
                              if (widget.flag == true) {
                                Apis()
                                    .setProfileImage(
                                        jsonDecode(value)['Response']['FileId'])
                                    .then((value) {
                                  if (value == 'Bad Request') {
                                    showToast('something_went_wrong'.tr);
                                  } else {
                                    if (jsonDecode(value)['IsSuccess'] ==
                                        true) {
                                      showToast('photo_uploaded'.tr);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Profile()));
                                    } else {
                                      showToast(
                                          jsonDecode(value)['ErrorMessage']);
                                    }
                                  }
                                });
                              } else {
                                showToast('photo_uploaded'.tr);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Profile()));
                              }
                            } else {
                              showToast(jsonDecode(value)['ErrorMessage']);
                            }
                          }
                        });
                      })),
            ],
          ),
        ),
      ),
    );
  }

  var localmage;
  void chooseImage() async {
    localmage = await pickImage();
    setState(() {});
    if (localmage != null && localmage != 'Error')
      image:
      localmage;
  }

  Future<String> pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? _imagePicker =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (_imagePicker != null) {
      Uint8List bytes = await _imagePicker.readAsBytes();

      String encode = base64Encode(bytes);

      return encode;
    } else {
      if (kDebugMode) {
        print('Pick Image First');
      }
      return 'Error';
    }
  }
}

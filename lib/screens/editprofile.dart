// ignore_for_file: deprecated_member_use, file_names, prefer_const_constructors, unused_label, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:chatinunii/constants.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/models/statusmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../authScreens/signup.dart';
import '../components/toast.dart';

class EditProfile extends StatefulWidget {
  const EditProfile();

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController usernamee = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  // TextEditingController image = TextEditingController();
  bool showPassword = false;
  String? lang;
  StatusModel? status;
  var data;

  @override
  void initState() {
    lang =
        '${Get.deviceLocale.toString().split('_')[0]}-${Get.deviceLocale.toString().split('_')[1]}';
    // TODO: implement initState
    super.initState();
    var l = Get.deviceLocale.toString();
    if (l.contains("uk") || l.contains("ru")) {
      setState(() {
        l = "uk_UA";
      });
    } else if (l.contains("tr")) {
      setState(() {
        l = "tr_Tr";
      });
    } else {
      setState(() {
        l = "en_US";
      });
    }
    apis.getProfile('${l.split('_')[0]}-${l.split('_')[1]}').then((value) {
      if (value == 'Bad Response') {
        showToast('something_went_wrong'.tr);
      } else {
        setState(() {
          data = jsonDecode(value);
        });
      }
    });
    Future.delayed(Duration.zero, () {
      // Locale myLocale = Localizations.localeOf(context);
      apis.getStatus('${l.split('_')[0]}-${l.split('_')[1]}').then((value) {
        setState(() {
          status = value;
        });
        if (value.isSuccess == false) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unable to get Status')));
        }
      }).whenComplete(() {
        int range = status!.response.statuses.length;
        if (statuses.isEmpty) {
          for (var i = 0; i < range; i++) {
            statuses.add((status!.response.statuses[i].statusName).toString());
          }
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: status == null
          ? Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            )
          : data == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                )
              : Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Column(
                          children: [
                            buildTextField(
                                data["Response"]['Records'][0]['UserName'],
                                Icon(
                                  Icons.abc,
                                  size: 30,
                                  color: kPrimaryColor,
                                ),
                                usernamee),
                            buildTextField(
                                data["Response"]['Records'][0]['Email'],
                                Icon(
                                  Icons.email,
                                  color: kPrimaryColor,
                                ),
                                email),
                            SizedBox(
                              height: 15,
                            ),
                            statusList(),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  onPrimary: kPrimaryColor,
                                  elevation: 5,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        colors: [kPrimaryColor, kPrimaryColor]),
                                    borderRadius: BorderRadius.circular(20)),
                                child: InkWell(
                                  onTap: () async {
                                    Apis()
                                        .updateProfile(
                                            usernamee.text == ''
                                                ? data["Response"]['Records'][0]
                                                    ['UserName']
                                                : usernamee.text,
                                            passwordcontroller.text,
                                            email.text == ''
                                                ? data["Response"]['Records'][0]
                                                    ['Email']
                                                : email.text,
                                            _mySelection == null
                                                ? data["Response"]['Records'][0]
                                                    ['StatusId']
                                                : statusid!)
                                        .then((value) {
                                      if (value == 'Bad Request') {
                                        showToast('something_went_wrong'.tr);
                                      } else {
                                        showToast(
                                            'profile_has_been_updated'.tr);
                                        Navigator.pop(context);
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 200,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'send'.tr,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
    );
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

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      automaticallyImplyLeading: false,
      backgroundColor: kPrimaryColor,
      title: Text(
        "edit_profile".tr,
      ),
    );
  }

  Widget buildTextField(
      String labelText, Icon icon, TextEditingController ctrl) {
    return Container(
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor, width: 1),
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  controller: ctrl,
                  maxLines: 1,
                  decoration: InputDecoration(
                    label: Text(labelText),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  List statuses = [];
  String? _mySelection;
  Widget statusList() {
    return Container(
      height: 65,
      width: MediaQuery.of(context).size.width * 0.84,
      decoration: BoxDecoration(
        // color: kPrimaryColor,
        border: Border.all(color: kPrimaryColor),
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.bubble_chart,
              color: kPrimaryColor,
            ),
            DropdownButton<String>(
                hint: _mySelection == null
                    ? Text(data["Response"]['Records'][0]['StatusText'],
                        style: TextStyle(color: kPrimaryColor, fontSize: 16))
                    : Text(_mySelection!,
                        style: TextStyle(color: kPrimaryColor, fontSize: 16)),
                style: TextStyle(color: kPrimaryColor, fontSize: 16),
                // dropdownColor: kPrimaryColor,
                items: statuses.map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                    () {
                      _mySelection = val!;
                    },
                  );
                  for (var i = 0; i < status!.response.statuses.length; i++) {
                    if (status!.response.statuses[i].statusName ==
                        _mySelection) {
                      setState(() {
                        statusid = status!.response.statuses[i].statusId;
                      });
                      break;
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:chatinunii/screens/chats/chats_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:chatinunii/authScreens/login.dart';
import 'package:chatinunii/components/bottomnavbar.dart';
import 'package:chatinunii/constants.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/screens/chats/chatThroughStatus.dart';
import 'package:chatinunii/screens/profile.dart';
import 'package:chatinunii/screens/settings/changepassword.dart';
import 'package:chatinunii/screens/settings/makemegolduser.dart';
import 'package:chatinunii/screens/settings/setlanguage.dart';
import 'package:chatinunii/screens/splashscreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final translator = GoogleTranslator();

  var changpass, makemegold, setlang, logout, settings;
  @override
  @override
  void initState() {
    lang =
        '${Get.deviceLocale.toString().split('_')[0]}-${Get.deviceLocale.toString().split('_')[1]}';
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(text: 'settings'.tr),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              color: kPrimaryColor,
              width: double.infinity,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(5)),
                  child: const Text(
                    'ChatInUni',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChangePassword()));
                },
                child: buildButton(Icons.change_circle, 'change_password'.tr)),
            const Divider(
              color: kPrimaryColor,
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MakeMeGoldUser()));
                },
                child: buildButton(Icons.verified_user, 'make_gold_user'.tr)),
            const Divider(
              color: kPrimaryColor,
            ),
            InkWell(
                onTap: () async {
                  token = null;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove("email");
                  prefs.remove("token");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ChatByStatus(
                                flag: false,
                              )),
                      ModalRoute.withName('/'));
                  loginFlag = false;
                },
                child: buildButton(Icons.logout, 'logout'.tr)),
            const Divider(
              color: kPrimaryColor,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: kPrimaryColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        onTap: (int index) => btn(index, context),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.messenger,
            ),
            label: "chat".tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: 'active_users'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'profile'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: 'settings'.tr,
          ),
        ],
      ),
    );
  }

  Widget buildButton(var icon, String text) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          Icon(
            icon,
            size: 30,
            color: kPrimaryColor,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.015,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 20, color: kPrimaryColor),
          )
        ],
      ),
    );
  }

  String baseurl = 'https://api.chatinuni.com';

  Future getToken() async {
    String finalurl = '$baseurl/User/GetPublicToken';
    var result = await http.post(Uri.parse(finalurl),
        headers: {'Content-Type': 'application/json'});
    var msg = jsonDecode(result.body);
    if (result.statusCode == 200) {
      if (msg['IsSuccess'] == true) {
        return msg;
      } else {
        return 'error';
      }
    } else {
      return 'connectivity problem';
    }
  }
}

// button for bottom navbar
btn(i, context) {
  if (i == 0) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ChatsScreen()));
  } else if (i == 1) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatByStatus(
                  flag: true,
                )));
  } else if (i == 2) {
    if (loginFlag == true) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Profile()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  } else {}
}

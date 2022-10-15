// ignore_for_file: camel_case_types
// ignore_for_file: file_names

import 'dart:async';
import 'package:chatinunii/authScreens/login.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/screens/chats/chatThroughStatus.dart';
import 'package:chatinunii/screens/chats/chats_screen.dart';
import 'package:chatinunii/screens/welcome/welcome_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

String? fcm;

String? token;
String? lang;

class _SplashScreenState extends State<SplashScreen> {
  Future getfcm() async {
    return await FirebaseMessaging.instance.getToken();
  }

  @override
  void initState() {
    lang =
        '${Get.deviceLocale.toString().split('_')[0]}-${Get.deviceLocale.toString().split('_')[1]}';
    super.initState();
    getfcm().then((fcmToken) {
      setState(() {
        fcm = fcmToken;
      });
    });
    Timer(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString("email") != null &&
          prefs.getString("token") != null) {
        setState(() {
          token = prefs.getString("token");
          loginFlag = true;
        });
        socket.emit('UpdateSocketId', {'Token': token, 'FirebaseToken': fcm});
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatsScreen()));
      } else {
        Apis().getToken().then((value) {
          setState(() {
            token = value['Response']['Token'];
          });
        });
        socket.emit('UpdateSocketId', {'Token': token, 'FirebaseToken': fcm});

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => prefs.getString('welcome') == null
                    ? WelcomeScreen()
                    : ChatByStatus(flag: false)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(82, 14, 125, 1),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    opacity: 0.05,
                    image: AssetImage('assets/images/ko-01.png'),
                    fit: BoxFit.cover)),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(5)),
              child: const Text(
                'ChatInUni',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

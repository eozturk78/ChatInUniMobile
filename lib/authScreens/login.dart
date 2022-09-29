import 'dart:convert';
import 'package:chatinunii/authScreens/signup.dart';
import 'package:chatinunii/constants.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/screens/splashscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:translator/translator.dart';
import '../components/toast.dart';
import '../screens/chats/chats_screen.dart';
import 'forgetPassword.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

Apis apis = Apis();
IO.Socket socket = IO.io('https://api.chatinuni.com', <String, dynamic>{
  "transports": ["websocket"],
  "autoConnect": false
});
bool loginFlag = false;

class _LoginState extends State<Login> {
  late bool _passwordVisible;

  final translator = GoogleTranslator();
  var name, pass, login, forgetpass, clickhere, dontHaveAcc, signUp, loginas;
  Future getFcm() async {
    return await FirebaseMessaging.instance.getToken();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    usernamecontroller.clear();
    passwordcontroller.clear();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              // Colors.purple,
              kPrimaryColor,
              kContentColorLightTheme,
            ])),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100),
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
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  margin: const EdgeInsets.only(top: 60),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          // color: Colors.red,
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 22, bottom: 20),
                          child: Text(
                            "login".tr,
                            style: const TextStyle(
                                fontSize: 35,
                                color: Colors.black87,
                                letterSpacing: 2,
                                fontFamily: "Lobster"),
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            height: 70,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: kPrimaryColor, width: 1),
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.email_outlined),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                      maxLines: 1,
                                      controller: usernamecontroller,
                                      decoration: InputDecoration(
                                        label: Text("user_name".tr),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          width: double.infinity,
                          height: 70,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: kPrimaryColor, width: 1),
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.password_outlined),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    controller: passwordcontroller,
                                    obscureText: !_passwordVisible,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      label: Text("password".tr),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: kPrimaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 40,
                          margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "i_forgot_password".tr,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15),
                                textAlign: TextAlign.right,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgetPassword()));
                                  },
                                  child: Text(
                                    'click_here'.tr,
                                    style: TextStyle(
                                        color: kPrimaryColor, fontSize: 15),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        ElevatedButton(
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
                                signIn(usernamecontroller.text,
                                        passwordcontroller.text)
                                    .then((value) async {
                                  if (jsonDecode(value)['IsSuccess'] == false) {
                                    showToast(
                                        jsonDecode(value)['ErrorMessage']);
                                  } else {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(
                                        "email", usernamecontroller.text);
                                    prefs.setString("token",
                                        jsonDecode(value)['Response']['Token']);
                                    if (value == 'Bad Request') {
                                      showToast('something_went_wrong'.tr);
                                    } else {
                                      socket.connect();
                                      socket.onConnect((data) {
                                        socket.on('connection', (data) {});
                                      });
                                      socket.emit('UpdateSocketId', {
                                        'Token': jsonDecode(value)['Response']
                                            ['Token'],
                                        'FirebaseToken': fcm
                                      });

                                      token = jsonDecode(value)['Response']
                                          ['Token'];
                                      loginFlag = true;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ChatsScreen()));
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 200,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  'login'.tr,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            height: 70,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'i_dont_have_account'.tr,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 15),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Signup()));
                                    },
                                    child: Text(
                                      'sign_up'.tr,
                                      style: TextStyle(
                                          color: kPrimaryColor, fontSize: 15),
                                    ))
                              ],
                            )),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future signIn(String username, String password) async {
    String finalurl = 'https://api.chatinuni.com/User/Login';
    var data = {"UserName": username, "Password": password};
    var result = await http.post(Uri.parse(finalurl),
        headers: {
          'Content-Type': 'application/json',
          'lang': lang!,
          'Token': token!,
        },
        body: jsonEncode(data));
    if (result.statusCode == 200) {
      return result.body;
    }

    return result.body;
  }
}

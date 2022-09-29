import 'dart:convert';

import 'package:chatinunii/authScreens/signup.dart';
import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/constants.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _LoginState();
}

Apis apis = Apis();

class _LoginState extends State<ForgetPassword> {
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
                            "forgot_password".tr,
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
                                        label: Text("email_or_user_name".tr),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
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
                              onTap: () {
                                Apis()
                                    .forgetPassword(usernamecontroller.text)
                                    .then((value) {
                                  if (value == 'Bad Request') {
                                    showToast('something_went_wrong'.tr);
                                  } else {
                                    if (jsonDecode(value)['IsSuccess'] ==
                                        true) {
                                      Navigator.pop(context);
                                      showToast('sent_an_email'.tr);
                                    } else {
                                      showToast(
                                          jsonDecode(value)['ErrorMessage']);
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 200,
                                height: 50,
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: FittedBox(
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
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

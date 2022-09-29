import 'package:chatinunii/screens/chats/chatThroughStatus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../../constants.dart';
import '../SiginInOrSignUp/signin_or_signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

var prefs;
setPrefrences() async {
  prefs = await SharedPreferences.getInstance();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final translator = GoogleTranslator();
  var t1, t2, t3;

  var l = Get.deviceLocale.toString();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefrences().then((_) {
      setState(() {});
      prefs.setString("welcome", "done");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(
              flex: 2,
            ),
            Image.asset("assets/images/welcome_image.png"),
            const Spacer(
              flex: 3,
            ),
            Text(
              "skip_screen_exp".tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Text(
              "skip_screen_sub_exp".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.color
                    ?.withOpacity(0.64),
              ),
            ),
            const Spacer(
              flex: 3,
            ),
            FittedBox(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatByStatus(
                        flag: false,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      "skip".tr,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.color
                                ?.withOpacity(0.8),
                          ),
                    ),
                    const SizedBox(
                      width: kDefaultPadding / 4,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.color
                          ?.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

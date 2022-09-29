import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatinunii/components/bottomnavbar.dart';
import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/main.dart';
import 'package:chatinunii/screens/SiginInOrSignUp/signin_or_signup_screen.dart';
import 'package:chatinunii/screens/chats/chatThroughStatus.dart';
import 'package:chatinunii/screens/messages/translatedMessageScreen.dart';
import 'package:chatinunii/screens/profile.dart';
import 'package:chatinunii/screens/settings/settings.dart';
import 'package:chatinunii/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:translator/translator.dart';
import '../../authScreens/login.dart';
import '../../constants.dart';
import '../../models/Chat.dart';
import '../messages/messages_screen.dart';
import 'components/chat_card.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

int countscreen = 0;

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectIndex = 0;
  Timer? timer;
  final translator = GoogleTranslator();
  @override
  void initState() {
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
    if (chats == null) {
      translator
          .translate("Chats", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          chats = value;
        });
      });

      translator
          .translate("People", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          people = value;
        });
      });
      translator
          .translate("Profile", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          profile = value;
        });
      });
      translator
          .translate("Settings", from: 'en', to: '${l.split('_')[0]}')
          .then((value) {
        setState(() {
          settings = value;
        });
      });
    }
    if (token == null) {
      Apis().getToken().then((value) {
        setState(() {
          token = value['Response']['Token'];
        });
      }).whenComplete(() {
        socket.emit('UpdateSocketId', {'Token': token});
        timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
          getData();
        });
      });
    } else {
      socket.emit('UpdateSocketId', {'Token': token});
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        getData();
      });
    }
  }

  getData() {
    Apis().GetchatScreenList().then((value) {
      if (value == 'Bad Request') {
        showToast('Error in getting messages');
      } else {
        setState(() {
          data = jsonDecode(value);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  var data;
  @override
  Widget build(BuildContext context) {
    DateTime pre_backpress = DateTime.now();
    return Scaffold(
      appBar: buildAppBar(),
      body: WillPopScope(
        onWillPop: () async {
          final timegap = DateTime.now().difference(pre_backpress);
          final cantExit = timegap >= Duration(seconds: 2);
          pre_backpress = DateTime.now();
          if (cantExit) {
            //show snackbar
            showToast('Press Back button again to Exit');
            return false;
          } else {
            exit(0);
          }
        },
        child: data == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : data['Response']['Records'] == null
                ? Center(
                    child: Text('there_is_no_chat'.tr),
                  )
                : ListView.builder(
                    itemCount: data['Response']['Records'].length,
                    itemBuilder: (context, index) {
                      return ChatCard(
                        chatId: data['Response']['Records'][index]['ChatId'],
                        unreadNum: data['Response']['Records'][index]
                                ['UnReadMessageCount']
                            .toString(),
                        press: () {
                          countscreen = 0;
                          timer!.cancel();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessagesScreen(
                                        username: data['Response']['Records']
                                            [index]['ChatCreatedUserName'],
                                        data: data['Response']['Records']
                                            [index],
                                        index: index,
                                      )));
                        },
                        chat: Chat(
                            name: data['Response']['Records'][index]
                                ['ChatCreatedUserName'],
                            lastMessage: data['Response']['Records'][index]
                                        ['Messages'] ==
                                    null
                                ? ''
                                : data['Response']['Records'][index]['Messages']
                                        [data['Response']['Records'][index]['Messages'].length - 1]
                                    ['Message'],
                            image: data['Response']['Records'][index]
                                        ['ProfilePhotos'] ==
                                    null
                                ? 'https://chatinuni.com/assets/image/profile-place-holder.jpg'
                                : data['Response']['Records'][index]
                                    ['ProfilePhotos'][0]['FileURL'],
                            time: '',
                            // data['Response']['Records'][index]
                            //     ['LastMessageDate'],
                            isActive: false),
                      );
                    }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: kPrimaryColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (int index) => btn(index, context),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.messenger,
            ),
            label: "chat".tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'active_users'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "profile".tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "settings".tr,
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kPrimaryColor,
      title: Text(
        chats == null ? "" : "$chats",
      ),
    );
  }
}

btn(i, context) {
  if (i == 0) {
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
  } else {
    if (loginFlag == true) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Settings()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }
}

import 'dart:convert';
import 'package:chatinunii/components/toast.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/screens/chats/chatThroughStatus.dart';
import 'package:chatinunii/screens/chats/chats_screen.dart';
import 'package:chatinunii/screens/editprofile.dart';
import 'package:chatinunii/screens/messages/messages_screen.dart';
import 'package:chatinunii/screens/settings/settings.dart';
import 'package:chatinunii/screens/splashscreen.dart';
import 'package:chatinunii/screens/uploadphoto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import '../authScreens/login.dart';
import '../components/bottomnavbar.dart';
import '../constants.dart';

class Profile extends StatefulWidget {
  String? username;
  Profile({Key? key, this.username}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

var data;

SharedPreferences? prefs;

class _ProfileState extends State<Profile> {
  setPrefrences() async {
    prefs = await SharedPreferences.getInstance();
  }

  final translator = GoogleTranslator();
  var editProfile, sendMsg, uploadpic, setMainP, delete, photoDel;
  @override
  void initState() {
    lang =
        '${Get.deviceLocale.toString().split('_')[0]}-${Get.deviceLocale.toString().split('_')[1]}';
    // TODO: implement initState
    super.initState();
    setPrefrences().then((_) {
      setState(() {});
    });
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
    widget.username == null
        ? Apis()
            .getProfile('${l.split('_')[0]}-${l.split('_')[1]}')
            .then((value) {
            if (value == 'Bad Response') {
              showToast('something_went_wrong'.tr);
            } else {
              setState(() {
                data = jsonDecode(value)["Response"]['Records'][0];
              });
              for (var i = 0;
                  i <
                      jsonDecode(value)["Response"]['Records'][0]
                              ['ProfilePhotos']
                          .length;
                  i++) {
                if (jsonDecode(value)["Response"]['Records'][0]['ProfilePhotos']
                        [i]['MainPhoto'] ==
                    1) {
                  setState(() {
                    mainPhoto = jsonDecode(value)["Response"]['Records'][0]
                        ['ProfilePhotos'][i]['FileURL'];
                  });
                  break;
                }
              }
            }
          })
        : Apis().getUserProfile(widget.username!).then((value) {
            if (value == 'Bad Response') {
              showToast('something_went_wrong'.tr);
            } else {
              setState(() {
                data = jsonDecode(value)["Response"];
              });
              if (jsonDecode(value)["Response"]['ProfilePhotos'] == null) {
                setState(() {
                  mainPhoto =
                      'https://chatinuni.com/assets/image/profile-place-holder.jpg';
                });
              } else {
                for (var i = 0;
                    i < jsonDecode(value)["Response"]['ProfilePhotos'].length;
                    i++) {
                  if (jsonDecode(value)["Response"]['ProfilePhotos'][i]
                          ['MainPhoto'] ==
                      1) {
                    setState(() {
                      mainPhoto = jsonDecode(value)["Response"]['ProfilePhotos']
                          [i]['FileURL'];
                    });
                    break;
                  }
                }
              }
            }
          });
  }

  String mainPhoto = 'abcd';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ChatsScreen()));

        return Future.value(false);
      },
      child: Scaffold(
        appBar: buildAppBar(text: "profile".tr),
        body: (data == null)
            ? const Center(child: CircularProgressIndicator())
            : Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(mainPhoto),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              data['UserName'],
                              style:
                                  TextStyle(color: kPrimaryColor, fontSize: 16),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.05,
                            ),
                            prefs!.getString('email') == null
                                ? Text("")
                                : data['UserName'] ==
                                        prefs!.getString('email')!.trim()
                                    ? Text(data['Email'],
                                        style: TextStyle(
                                            color: kPrimaryColor, fontSize: 16))
                                    : Text(""),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        var msgdata;
                        widget.username == null
                            ? null
                            : print("socket ${socket.connected}");
                        var p = {
                          'Message':
                              '', // the message must be send empty string as like “”,
                          'ToUserName':
                              widget.username, // user profile name / UserName,
                          'Lang': lang!, //-phone language,
                          'Token': token!
                        };
                        socket.emit("CreateChat", p);
                        Apis().GetchatScreenList().then((value) {
                          if (value == 'Bad Request') {
                            showToast('something_went_wrong'.tr);
                          } else {
                            int index = 0;
                            if (jsonDecode(value)['Response']['Records'] !=
                                null) {
                              for (var i = 0;
                                  i <
                                      jsonDecode(value)['Response']['Records']
                                          .length;
                                  i++) {
                                if (widget.username ==
                                    jsonDecode(value)['Response']['Records'][i]
                                        ['ChatCreatedUserName']) {
                                  index = i;
                                  break;
                                }
                              }
                            }

                            widget.username == null
                                ? Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const EditProfile()))
                                : Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MessagesScreen(
                                          username: widget.username,
                                          data: jsonDecode(value)['Response']
                                              ['Records'][index],
                                          index: index,
                                        )));
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Ink(
                        decoration: BoxDecoration(
                            border: Border.all(color: kPrimaryColor),
                            gradient: const LinearGradient(
                                colors: [Colors.white, Colors.white]),
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          width: 200,
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            widget.username == null
                                ? 'edit_profile'.tr
                                : 'send_message'.tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.566,
                      child: data['ProfilePhotos'] == null
                          ? Center(
                              child: Text('no_photos_found'.tr),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemCount: data['ProfilePhotos'].length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: (context),
                                          builder: (context) => showDetails(
                                              data['ProfilePhotos'][index]
                                                  ['FileURL'],
                                              data['ProfilePhotos'][index]
                                                  ['FileId']));
                                    },
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  data['ProfilePhotos'][index]
                                                      ['FileURL']),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                );
                              },
                            ),
                    )
                  ],
                ),
              ),
        floatingActionButton: widget.username != null
            ? null
            : FloatingActionButton(
                onPressed: () {
                  bool flag = false;
                  if (data['ProfilePhotos'] == null) {
                    flag = true;
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UploadPhoto(
                            flag: flag,
                          )));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo),
                  ],
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: kPrimaryColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: 2,
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
      ),
    );
  }

  String? localmage;
  Widget showDetails(String img, String? field) {
    return AlertDialog(
        title: Image(image: NetworkImage(img)),
        content: prefs!.getString('email') == null
            ? SizedBox()
            : prefs!.getString('email')!.trim() != data['UserName']
                ? SizedBox()
                : FittedBox(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (field != null) {
                              Apis().deletePhoto(field).then((value) {
                                if (value == 'Bad Response') {
                                  showToast('something_went_wrong'.tr);
                                } else {
                                  showToast('photo_is_deleted'.tr);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Profile()));
                                }
                              });
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete,
                                color: kPrimaryColor,
                              ),
                              Text(
                                'delete'.tr,
                                style: const TextStyle(color: kPrimaryColor),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        InkWell(
                          onTap: () {
                            if (field != null) {
                              Apis().setProfileImage(field).then((value) {
                                if (value == 'Bad Response') {
                                  showToast('something_went_wrong'.tr);
                                } else {
                                  showToast('main_photo_is_changed'.tr);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Profile()));
                                  setState(() {});
                                }
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.person, color: kPrimaryColor),
                              Text('main_photo'.tr,
                                  style: TextStyle(color: kPrimaryColor))
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
  }
}

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

AppBar buildAppBar({required String text}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: kPrimaryColor,
    title: Text(
      text,
    ),
  );
}

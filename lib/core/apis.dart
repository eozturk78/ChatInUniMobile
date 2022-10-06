// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'package:chatinunii/models/statusmodel.dart';
import 'package:chatinunii/screens/chats/chats_screen.dart';
import 'package:chatinunii/screens/messages/messages_screen.dart';
import 'package:chatinunii/screens/splashscreen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controller/msgcontroller.dart';

class Apis {
  String baseurl = 'https://api.chatinuni.com';

  Future getToken() async {
    String finalurl = '$baseurl/User/GetPublicToken';
    await http.get(Uri.parse(finalurl));
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

  Future signUp(String username, String email, String password, String StatusId,
      String lang) async {
    print(lang);
    String finalurl = '$baseurl/User/SignUp';
    var data = {
      'UserName': username,
      'Email': email,
      'Password': password,
      'StatusId': StatusId
    };
    var result = await http.post(Uri.parse(finalurl),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'lang': lang,
          'Token': token!
        });
    var msg = result.body;
    if (result.statusCode == 200) {
      print(msg);
      return msg;
    }

    return msg;
  }

  Future getStatus(String lang) async {
    String finalurl = '$baseurl/User/GetStatusList';
    var result = await http.get(Uri.parse(finalurl), headers: {'lang': lang});
    if (result.statusCode == 200) {
      print(result.body);
      return statusModelFromJson(result.body);
    }
  }

  Future chatThroughStatus(String statusId, String lang) async {
    String finalurl = '$baseurl/User/GetActiveUserList/$statusId';
    var result = await http.post(Uri.parse(finalurl), headers: {
      'lang': lang,
      'Content-Type': 'application/json',
      'Token': token!
    });
    var msg = json.decode(result.body);
    if (result.statusCode == 200) {
      return msg;
    }

    return msg;
  }

  Future signIn(
      String username, String password, String lang, String Token) async {
    String finalurl = 'https://api.chatinuni.com/User/Login';
    var data = {"UserName": username, "Password": password};
    var result = await http.post(Uri.parse(finalurl),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'lang': lang,
          'Token': Token
        });
    var msg = result.body;
    if (result.statusCode == 200) {
      print(msg);
      return msg;
    }

    return msg;
  }

  Future getProfile(String lang) async {
    String finalurl = '$baseurl/User/GetProfile';
    var response = await http.get(Uri.parse(finalurl), headers: {
      'Content-Type': 'application/json',
      'lang': lang,
      'Token': token!
    });
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future getUserProfile(String username) async {
    String finalurl =
        'https://api.chatinuni.com/User/GetUserProfileDetail/$username';
    var response = await http.get(Uri.parse(finalurl), headers: {
      'Content-Type': 'application/json',
      // 'lang': lang!,
      'Token': token!
    });
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future forgetPassword(String username) async {
    String finalurl = '$baseurl/User/ForgotPassword';
    var response = await http.post(Uri.parse(finalurl),
        headers: {
          'Content-Type': 'application/json',
          'lang': lang!,
          'Token': token!
        },
        body: jsonEncode({'UserName': username}));
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future updateProfile(
      String username, String password, String email, String statusId) async {
    String finalurl = '$baseurl/User/UpdateProfile';
    var data = {
      'UserName': username,
      'Password': password,
      'Email': email,
      'StatusId': statusId,
    };
    var response = await http.post(Uri.parse(finalurl),
        headers: {
          'Content-Type': 'application/json',
          'lang': lang!,
          'Token': token!
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future changePassword(String oldPassword, String newpassword) async {
    String finalurl = '$baseurl/User/ChangePassword';
    var data = {'OldPassword': oldPassword, 'NewPassword': newpassword};
    var response = await http.post(Uri.parse(finalurl),
        headers: {
          'Content-Type': 'application/json',
          'lang': lang!,
          'Token': token!
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future uploadPhoto(String fileName, var img) async {
    String finalurl = '$baseurl/User/UploadProfilePhoto';
    var data = {"ImageBase64": img, "FileName": '$fileName.jpg'};
    var response = await http.post(Uri.parse(finalurl),
        headers: {
          'Content-Type': 'application/json',
          'lang': lang!,
          'Token': token!
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future deleteChat(String chatId) async {
    String finalurl = '$baseurl/User/DeleteChat/$chatId';
    var response = await http.post(Uri.parse(finalurl), headers: {
      'Content-Type': 'application/json',
      'lang': lang!,
      'Token': token!
    });
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future deletePhoto(String fileName) async {
    String finalurl = '$baseurl/User/DeleteProfilePhoto/$fileName';
    var response = await http.post(Uri.parse(finalurl), headers: {
      'Content-Type': 'application/json',
      'lang': lang!,
      'Token': token!
    });
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future complaintUser(
      {required String chatId,
      required String toUsername,
      required String reason}) async {
    String finalurl = '$baseurl/User/ComplaintUser';
    var data = {'ToUserName': toUsername, 'ReasonText': reason};
    var response = await http.post(Uri.parse(finalurl),
        headers: {
          'Content-Type': 'application/json',
          'lang': lang!,
          'Token': token!
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future sendGoldUserRequest({required String phoneNumber}) async {
    String finalurl = '$baseurl/User/SendGoldRequest';
    var data = {'PhoneNumber': phoneNumber};
    var response = await http.post(Uri.parse(finalurl),
        headers: {
          'Content-Type': 'application/json',
          'lang': lang!,
          'Token': token!
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future deleteMyAccount() async {
    String finalurl = '$baseurl/User/DeleteMyAccount';
    var response = await http.post(Uri.parse(finalurl),
        headers: {
          'Content-Type': 'application/json',
          'lang': lang!,
          'Token': token!
        });
    if (response.statusCode == 200) {
      return response.body;
    }
  }
  

  Future blockByUser(
      {required String blockedUserNme, required String chatId}) async {
    String finalurl = '$baseurl/User/BlockUserByUser';
    var data = {'BlockedUserName': blockedUserNme, 'ChatId': chatId};
    var response = await http.post(Uri.parse(finalurl),
        headers: {
          'Content-Type': 'application/json',
          'lang': lang!,
          'Token': token!
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future setProfileImage(String field) async {
    String finalUrl = '$baseurl/User/SetMainProfilePhoto/$field';
    var response = await http.post(
      Uri.parse(finalUrl),
      headers: {
        'Content-Type': 'application/json',
        'lang': lang!,
        'Token': token!
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    return response.body;
  }

  Future GetchatScreenList() async {
    String finalUrl = '$baseurl/User/GetMessageList';
    var response = await http.get(
      Uri.parse(finalUrl),
      headers: {
        'Content-Type': 'application/json',
        'lang': lang!,
        'Token': token!
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    return response.body;
  }

  var data;
  Stream<List> getGetChat(
      String username, String chatId, String token, String? langCode) async* {
    String finalUrl = '$baseurl/User/GetMessageList';
    Uri uri = Uri.parse(finalUrl);
    print('dasdasdada da dad ad as');
    if (transFlag == false && countscreen != 0) {
      String transUrl = '$baseurl/User/TranslateChat/$chatId';
      await http.post(
        Uri.parse(transUrl),
        headers: {
          'Content-Type': 'application/json',
          'lang': langCode!,
          'Token': token
        },
      );
    }
    while (true) {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'lang': lang!,
          'Token': token
        },
      );
      data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        int index = 0;
        for (var i = 0;
            i < jsonDecode(response.body)['Response']['Records'].length;
            i++) {
          if (jsonDecode(response.body)['Response']['Records'][i]
                  ['ChatCreatedUserName'] ==
              username) {
            index = i;
            break;
          }
        }
        yield jsonDecode(response.body)['Response']['Records'][index]
            ['Messages'] as List;
      } else {
        throw Exception('Unable to fetch products from the REST API');
      }
    }
  }

  Stream<List> getTranslatedChat(
      String chatId, String? langCode, String token) async* {
    String finalUrl = '$baseurl/User/TranslateChat/$chatId';

    Uri uri = Uri.parse(finalUrl);
    int i = 0;
    while (true) {
      i++;

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'lang': langCode!,
          'Token': token
        },
      );
      data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        if (i % 2 != 0) {
          yield jsonDecode(response.body)['Response']['Messages'] as List;
        } else {
          continue;
        }
      } else {
        throw Exception('Unable to fetch products from the REST API');
      }
    }
  }

  // Stream<List> GetMessageList(int index) async* {
  //   while (true) {
  //     await Future.delayed(Duration(milliseconds: 500));
  //     Stream<List> someProduct = getGetChat(index);
  //     // Get.find<MessageController>().updateBooking(data);
  //     yield* someProduct;
  //   }
  // }

  Future GetPublicLanguageList() async {
    String finalUrl = '$baseurl/User/GetPublicLanguageList';
    var response = await http.get(
      Uri.parse(finalUrl),
      headers: {
        'Content-Type': 'application/json',
        'lang': lang!,
        'Token': token!
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    return response.body;
  }

  Future UpdateUserChatLanguage(String languageId) async {
    String finalurl = '$baseurl/User/UpdateUserChatLanguage/$languageId';
    // var data = {'languageId': languageId};
    var response = await http.post(
      Uri.parse(finalurl),
      headers: {
        'Content-Type': 'application/json',
        'lang': lang!,
        'Token': token!
      },
    );
    // body: jsonEncode(data));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
    }
  }

  Future TranslateChat(String chatId, String? langCode) async {
    String finalurl = '$baseurl/User/TranslateChat/$chatId';
    var response = await http.get(Uri.parse(finalurl),
        headers: {'lang': langCode!, 'Token': token!});
    if (response.statusCode == 200) {
      return response.body;
    }
  }
}

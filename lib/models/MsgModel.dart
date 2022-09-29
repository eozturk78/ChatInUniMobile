// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MessageModel messageModelFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  MessageModel({
    required this.isSuccess,
    required this.errorCode,
    required this.errorMessage,
    required this.response,
  });

  bool isSuccess;
  dynamic errorCode;
  dynamic errorMessage;
  Response response;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        isSuccess: json["IsSuccess"],
        errorCode: json["ErrorCode"],
        errorMessage: json["ErrorMessage"],
        response: Response.fromJson(json["Response"]),
      );

  Map<String, dynamic> toJson() => {
        "IsSuccess": isSuccess,
        "ErrorCode": errorCode,
        "ErrorMessage": errorMessage,
        "Response": response.toJson(),
      };
}

class Response {
  Response({
    required this.records,
  });

  List<Record> records;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        records:
            List<Record>.from(json["Records"].map((x) => Record.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Records": List<dynamic>.from(records.map((x) => x.toJson())),
      };
}

class Record {
  Record({
    required this.chatId,
    required this.profilePhotos,
    required this.chatCreatedUserName,
    required this.date,
    required this.lastMessageDate,
    required this.unReadMessageCount,
    required this.isChatTranslated,
    this.messages,
  });

  String chatId;
  List<ProfilePhoto> profilePhotos;
  String chatCreatedUserName;
  DateTime date;
  DateTime lastMessageDate;
  int unReadMessageCount;
  int isChatTranslated;
  List<Message>? messages;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        chatId: json["ChatId"],
        profilePhotos: List<ProfilePhoto>.from(
            json["ProfilePhotos"].map((x) => ProfilePhoto.fromJson(x))),
        chatCreatedUserName: json["ChatCreatedUserName"],
        date: DateTime.parse(json["Date"]),
        lastMessageDate: DateTime.parse(json["LastMessageDate"]),
        unReadMessageCount: json["UnReadMessageCount"],
        isChatTranslated: json["IsChatTranslated"],
        messages: json["Messages"] == null
            ? null
            : List<Message>.from(
                json["Messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ChatId": chatId,
        "ProfilePhotos":
            List<dynamic>.from(profilePhotos.map((x) => x.toJson())),
        "ChatCreatedUserName": chatCreatedUserName,
        "Date": date.toIso8601String(),
        "LastMessageDate": lastMessageDate.toIso8601String(),
        "UnReadMessageCount": unReadMessageCount,
        "IsChatTranslated": isChatTranslated,
        "Messages": messages == null
            ? null
            : List<dynamic>.from(messages!.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    required this.isFromLoggedUser,
    required this.fromUserName,
    required this.toUserName,
    required this.message,
    required this.date,
  });

  int isFromLoggedUser;
  UserName? fromUserName;
  UserName? toUserName;
  String message;
  DateTime date;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        isFromLoggedUser: json["IsFromLoggedUser"],
        fromUserName: userNameValues.map[json["FromUserName"]],
        toUserName: userNameValues.map[json["ToUserName"]],
        message: json["Message"],
        date: DateTime.parse(json["Date"]),
      );

  Map<String, dynamic> toJson() => {
        "IsFromLoggedUser": isFromLoggedUser,
        "FromUserName": userNameValues.reverse[fromUserName],
        "ToUserName": userNameValues.reverse[toUserName],
        "Message": message,
        "Date": date.toIso8601String(),
      };
}

enum UserName {
  CHT_32_F433_E3_F3_BE4_A82968_BEDF43_DB50412,
  CHT_B23476_D88_D704987_B09177_E0_CC18_D851,
  ERHAN
}

final userNameValues = EnumValues({
  "CHT-32F433E3F3BE4A82968BEDF43DB50412":
      UserName.CHT_32_F433_E3_F3_BE4_A82968_BEDF43_DB50412,
  "CHT-B23476D88D704987B09177E0CC18D851":
      UserName.CHT_B23476_D88_D704987_B09177_E0_CC18_D851,
  "erhan": UserName.ERHAN
});

class ProfilePhoto {
  ProfilePhoto({
    required this.fileId,
    required this.fileUrl,
  });

  String fileId;
  String fileUrl;

  factory ProfilePhoto.fromJson(Map<String, dynamic> json) => ProfilePhoto(
        fileId: json["FileId"],
        fileUrl: json["FileURL"],
      );

  Map<String, dynamic> toJson() => {
        "FileId": fileId,
        "FileURL": fileUrl,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}

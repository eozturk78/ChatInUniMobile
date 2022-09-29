// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.isSuccess,
    required this.errorCode,
    required this.errorMessage,
    required this.response,
  });

  bool isSuccess;
  dynamic errorCode;
  dynamic errorMessage;
  Response response;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
    required this.statuses,
    required this.records,
  });

  List<Status> statuses;
  List<Record> records;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        statuses:
            List<Status>.from(json["Statuses"].map((x) => Status.fromJson(x))),
        records:
            List<Record>.from(json["Records"].map((x) => Record.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Statuses": List<dynamic>.from(statuses.map((x) => x.toJson())),
        "Records": List<dynamic>.from(records.map((x) => x.toJson())),
      };
}

class Record {
  Record({
    required this.email,
    required this.userName,
    required this.statusId,
  });

  String email;
  String userName;
  String statusId;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        email: json["Email"],
        userName: json["UserName"],
        statusId: json["StatusId"],
      );

  Map<String, dynamic> toJson() => {
        "Email": email,
        "UserName": userName,
        "StatusId": statusId,
      };
}

class Status {
  Status({
    required this.statusId,
    required this.statusName,
  });

  String statusId;
  String statusName;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        statusId: json["StatusId"],
        statusName: json["StatusName"],
      );

  Map<String, dynamic> toJson() => {
        "StatusId": statusId,
        "StatusName": statusName,
      };
}

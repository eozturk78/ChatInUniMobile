// To parse this JSON data, do
//
//     final activeStatusUserModel = activeStatusUserModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ActiveStatusUserModel activeStatusUserModelFromJson(String str) =>
    ActiveStatusUserModel.fromJson(json.decode(str));

String activeStatusUserModelToJson(ActiveStatusUserModel data) =>
    json.encode(data.toJson());

class ActiveStatusUserModel {
  ActiveStatusUserModel({
    required this.isSuccess,
    required this.errorCode,
    required this.errorMessage,
    required this.response,
  });

  bool isSuccess;
  dynamic errorCode;
  dynamic errorMessage;
  Response response;

  factory ActiveStatusUserModel.fromJson(Map<String, dynamic> json) =>
      ActiveStatusUserModel(
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
    required this.userId,
    required this.email,
    required this.userName,
    required this.statusText,
    required this.statusIcon,
    required this.profilePhotos,
  });

  String userId;
  String email;
  String userName;
  String statusText;
  String statusIcon;
  String? profilePhotos;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        userId: json["UserId"],
        email: json["Email"],
        userName: json["UserName"],
        statusText: json["StatusText"],
        statusIcon: json["StatusIcon"],
        profilePhotos: json["ProfilePhotos"],
      );

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "Email": email,
        "UserName": userName,
        "StatusText": statusText,
        "StatusIcon": statusIcon,
        "ProfilePhotos": profilePhotos,
      };
}

class Status {
  Status({
    required this.statusId,
    required this.statusText,
    required this.fileUrl,
  });

  String statusId;
  String statusText;
  String fileUrl;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        statusId: json["StatusId"],
        statusText: json["StatusText"],
        fileUrl: json["FileUrl"],
      );

  Map<String, dynamic> toJson() => {
        "StatusId": statusId,
        "StatusText": statusText,
        "FileUrl": fileUrl,
      };
}

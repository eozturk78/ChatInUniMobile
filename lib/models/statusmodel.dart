// To parse this JSON data, do
//
//     final statusModel = statusModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

StatusModel statusModelFromJson(String str) =>
    StatusModel.fromJson(json.decode(str));

String statusModelToJson(StatusModel data) => json.encode(data.toJson());

class StatusModel {
  StatusModel({
    required this.isSuccess,
    required this.errorCode,
    required this.errorMessage,
    required this.response,
  });

  bool isSuccess;
  dynamic errorCode;
  dynamic errorMessage;
  Response response;

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
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
  });

  List<Status> statuses;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        statuses:
            List<Status>.from(json["Statuses"].map((x) => Status.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Statuses": List<dynamic>.from(statuses.map((x) => x.toJson())),
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

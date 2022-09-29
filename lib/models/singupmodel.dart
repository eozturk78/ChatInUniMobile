// To parse this JSON data, do
//
//     final signup = signupFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

singupmodel signupFromJson(String str) =>
    singupmodel.fromJson(json.decode(str));

String signupToJson(singupmodel data) => json.encode(data.toJson());

class singupmodel {
  singupmodel({
    required this.isSuccess,
    required this.errorCode,
    required this.errorMessage,
    required this.response,
  });

  bool isSuccess;
  dynamic errorCode;
  dynamic errorMessage;
  Response response;

  factory singupmodel.fromJson(Map<String, dynamic> json) => singupmodel(
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
    required this.body,
    required this.subject,
  });

  String body;
  String subject;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        body: json["Body"],
        subject: json["Subject"],
      );

  Map<String, dynamic> toJson() => {
        "Body": body,
        "Subject": subject,
      };
}

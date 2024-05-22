// To parse this JSON data, do
//
//     final registrationRes = registrationResFromJson(jsonString);

import 'dart:convert';

RegistrationRes registrationResFromJson(String str) =>
    RegistrationRes.fromJson(json.decode(str));

String registrationResToJson(RegistrationRes data) =>
    json.encode(data.toJson());

class RegistrationRes {
  String message;

  RegistrationRes({
    required this.message,
  });

  factory RegistrationRes.fromJson(Map<String, dynamic> json) =>
      RegistrationRes(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

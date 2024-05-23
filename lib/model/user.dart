// To parse this JSON data, do
//
//     final User = UserFromJson(jsonString);

import 'dart:convert';

User UserFromJson(String str) => User.fromJson(json.decode(str));

String UserToJson(User data) => json.encode(data.toJson());

class User {
  int id;
  String firstname;
  String lastname;
  String email;
  String phone;
  dynamic emailVerifiedAt;
  String role;
  String? image;
  String badgeToken;
  dynamic passwordResetToken;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.emailVerifiedAt,
    required this.role,
    required this.image,
    required this.badgeToken,
    this.passwordResetToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"],
        role: json["role"],
        image: json["image"],
        badgeToken: json["badgeToken"],
        passwordResetToken: json["password_reset_token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "email_verified_at": emailVerifiedAt,
        "role": role,
        "image": image,
        "badgeToken": badgeToken,
        "password_reset_token": passwordResetToken,
      };
}

import 'dart:convert';

ReservationRes reservationResFromJson(String str) =>
    ReservationRes.fromJson(json.decode(str));

String reservationResToJson(ReservationRes data) => json.encode(data.toJson());

class ReservationRes {
  String message;
  String status;

  ReservationRes({
    required this.message,
    required this.status,
  });

  factory ReservationRes.fromJson(Map<String, dynamic> json) => ReservationRes(
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
      };
}

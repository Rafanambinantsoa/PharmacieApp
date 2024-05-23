// To parse this JSON data, do
//
//     final listReservation = listReservationFromJson(jsonString);

import 'dart:convert';

List<ListReservation> listReservationFromJson(String str) =>
    List<ListReservation>.from(
        json.decode(str).map((x) => ListReservation.fromJson(x)));

String listReservationToJson(List<ListReservation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListReservation {
  String eventTilte;
  DateTime eventDate;
  int eventId;

  ListReservation({
    required this.eventTilte,
    required this.eventDate,
    required this.eventId,
  });

  factory ListReservation.fromJson(Map<String, dynamic> json) =>
      ListReservation(
        eventTilte: json["eventTilte"],
        eventDate: DateTime.parse(json["eventDate"]),
        eventId: json["eventId"],
      );

  Map<String, dynamic> toJson() => {
        "eventTilte": eventTilte,
        "eventDate":
            "${eventDate.year.toString().padLeft(4, '0')}-${eventDate.month.toString().padLeft(2, '0')}-${eventDate.day.toString().padLeft(2, '0')}",
        "eventId": eventId,
      };
}

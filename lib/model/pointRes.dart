// To parse this JSON data, do
//
//     final pointRes = pointResFromJson(jsonString);

import 'dart:convert';

PointRes pointResFromJson(String str) => PointRes.fromJson(json.decode(str));

String pointResToJson(PointRes data) => json.encode(data.toJson());

class PointRes {
  int points;

  PointRes({
    required this.points,
  });

  factory PointRes.fromJson(Map<String, dynamic> json) => PointRes(
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "points": points,
      };
}

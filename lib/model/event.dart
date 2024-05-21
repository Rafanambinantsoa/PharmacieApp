import 'dart:convert';

List<Events> eventsFromJson(String str) =>
    List<Events>.from(json.decode(str).map((x) => Events.fromJson(x)));

String eventsToJson(List<Events> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Events {
  int id;
  String titre;
  String description;
  String date;
  String heure;
  String lieu;
  int status;
  int userId;

  Events({
    required this.id,
    required this.titre,
    required this.description,
    required this.date,
    required this.heure,
    required this.lieu,
    required this.status,
    required this.userId,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        id: json["id"],
        titre: json["titre"],
        description: json["description"],
        date: json["date"],
        heure: json["heure"],
        lieu: json["lieu"],
        status: json["status"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "titre": titre,
        "description": description,
        "date": date,
        "heure": heure,
        "lieu": lieu,
        "status": status,
        "user_id": userId,
      };
}

enum Heure { THE_1200 }

final heureValues = EnumValues({"12:00": Heure.THE_1200});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

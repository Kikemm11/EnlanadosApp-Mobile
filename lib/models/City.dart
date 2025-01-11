import 'dart:convert';

City cityFromJson(String str) => City.fromJson(json.decode(str));
String cityToJson(City data) => json.encode(data.toJson());

class City {
  int? id;
  String name;
  DateTime createdAt;

  City({
    this.id,
    required this.name,
    required this.createdAt
  });


  factory City.fromJson(Map<String, dynamic> json ) => City(
      id: json["id"],
      name: json["name"] as String,
      createdAt: DateTime.parse(json["created_at"] as String)
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt.toIso8601String()
  };

}
import 'dart:convert';

Status statusFromJson(String str) => Status.fromJson(json.decode(str));
String statusMethodToJson(Status data) => json.encode(data.toJson());

class Status {
  int? id;
  String name;
  DateTime createdAt;

  Status({
    this.id,
    required this.name,
    required this.createdAt
  });


  factory Status.fromJson(Map<String, dynamic> json ) => Status(
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
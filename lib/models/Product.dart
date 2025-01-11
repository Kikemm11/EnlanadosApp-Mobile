import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));
String productMethodToJson(Product data) => json.encode(data.toJson());

class Product {
  int? id;
  String name;
  DateTime createdAt;

  Product({
    this.id,
    required this.name,
    required this.createdAt
  });


  factory Product.fromJson(Map<String, dynamic> json ) => Product(
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
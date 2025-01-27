/*
This file contains the WoolStock model mapping the sqlite table

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/


import 'dart:convert';

WoolStock woolStockFromJson(String str) => WoolStock.fromJson(json.decode(str));
String woolStockMethodToJson(WoolStock data) => json.encode(data.toJson());

class WoolStock {
  int? id;
  String color;
  int quantity;
  DateTime lastUpdated;
  DateTime createdAt;

  WoolStock({
    this.id,
    required this.color,
    required this.quantity,
    DateTime? lastUpdated,
    DateTime? createdAt,
  }): createdAt = createdAt ?? DateTime.now(), lastUpdated = lastUpdated ?? DateTime.now();


  // Convertion methods

  factory WoolStock.fromJson(Map<String, dynamic> json ) => WoolStock(
      id: json["id"],
      color: json["color"] as String,
      quantity: json["quantity"] as int,
      lastUpdated: DateTime.parse(json["last_updated"] as String),
      createdAt: DateTime.parse(json["created_at"] as String)
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "color": color,
    "quantity": quantity,
    "last_updated": lastUpdated.toIso8601String(),
    "created_at": createdAt.toIso8601String()
  };

}
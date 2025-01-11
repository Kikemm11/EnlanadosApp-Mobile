import 'dart:convert';

WoolStock woolStockFromJson(String str) => WoolStock.fromJson(json.decode(str));
String woolStockMethodToJson(WoolStock data) => json.encode(data.toJson());

class WoolStock {
  int? id;
  String color;
  double quantity;
  DateTime lastUpdated;
  DateTime createdAt;

  WoolStock({
    this.id,
    required this.color,
    required this.quantity,
    required this.lastUpdated,
    required this.createdAt
  });


  factory WoolStock.fromJson(Map<String, dynamic> json ) => WoolStock(
      id: json["id"],
      color: json["color"] as String,
      quantity: json["quantity"] as double,
      lastUpdated: DateTime.parse(json["last_updated"] as String),
      createdAt: DateTime.parse(json["created_at"] as String)
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "color": color,
    "quantity": quantity,
    "last_updated": lastUpdated,
    "created_at": createdAt.toIso8601String()
  };

}
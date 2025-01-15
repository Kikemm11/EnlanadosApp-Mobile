import 'dart:convert';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));
String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  int? id;
  int orderId;
  int productTypeId;
  String description;
  double addedPrice;
  double discount;
  DateTime createdAt;

  Item({
    this.id,
    required this.orderId,
    required this.productTypeId,
    required this.description,
    this.addedPrice = 0.0,
    this.discount = 0.0,
    DateTime? createdAt,
  }
      ): createdAt = createdAt ?? DateTime.now();


  factory Item.fromJson(Map<String, dynamic> json ) => Item(
      id: json["id"],
      orderId: json["order_id"] as int,
      productTypeId: json["product_type_id"] as int,
      description: json["description"] as String,
      addedPrice: json["added_price"] as double,
      discount: json["discount"] as double,
      createdAt: DateTime.parse(json["created_at"] as String)
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "product_type_id": productTypeId,
    "description": description,
    "added_price": addedPrice,
    "discount": discount,
    "created_at": createdAt.toIso8601String()
  };

}
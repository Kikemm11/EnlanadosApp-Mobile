import 'dart:convert';

ProductType productTypeFromJson(String str) => ProductType.fromJson(json.decode(str));
String productTypeMethodToJson(ProductType data) => json.encode(data.toJson());

class ProductType {
  int? id;
  String name;
  int productId;
  double price;
  DateTime createdAt;

  ProductType({
    this.id,
    required this.name,
    required this.productId,
    required this.price,
    DateTime? createdAt,
  }): createdAt = createdAt ?? DateTime.now();


  factory ProductType.fromJson(Map<String, dynamic> json ) => ProductType(
      id: json["id"],
      name: json["name"] as String,
      productId: json["product_id"],
      price: json["price"],
      createdAt: DateTime.parse(json["created_at"] as String)
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "product_id": productId,
    "price": price,
    "created_at": createdAt.toIso8601String()
  };

}
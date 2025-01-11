import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));
String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  int? id;
  String client;
  int cityId;
  int productTypeId;
  String description;
  double addedPrice;
  double credit;
  int paymentMethodId;
  DateTime estimatedDate;
  int statusId;
  DateTime createdAt;

  Order({
    this.id,
    required this.client,
    required this.cityId,
    required this.productTypeId,
    required this.description,
    this.addedPrice = 0.0,
    this.credit = 0.0,
    required this.paymentMethodId,
    required this.estimatedDate,
    required this.statusId,
    required this.createdAt
  });


  factory Order.fromJson(Map<String, dynamic> json ) => Order(
      id: json["id"],
      client: json["client"] as String,
      cityId: json["city_id"] as int,
      productTypeId: json["product_type_id"] as int,
      description: json["description"] as String,
      addedPrice: json["added_price"] as double,
      credit: json["credit"] as double,
      paymentMethodId: json["payment_method_id"] as int,
      estimatedDate: DateTime.parse(json["estimated_date"] as String),
      statusId: json["status_id"] as int,
      createdAt: DateTime.parse(json["created_at"] as String)
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "client": client,
    "city_id": cityId,
    "product_type_id": productTypeId,
    "description": description,
    "added_price": addedPrice,
    "credit": credit,
    "payment_method_id": paymentMethodId,
    "estimated_date": estimatedDate.toIso8601String(),
    "status_id": statusId,
    "created_at": createdAt.toIso8601String()
  };

}
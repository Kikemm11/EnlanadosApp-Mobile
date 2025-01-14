import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));
String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  int? id;
  String client;
  int cityId;
  double credit;
  int paymentMethodId;
  DateTime estimatedDate;
  int statusId;
  DateTime createdAt;

  Order({
    this.id,
    required this.client,
    required this.cityId,
    this.credit = 0.0,
    required this.paymentMethodId,
    required this.estimatedDate,
    this.statusId = 1,
    DateTime? createdAt,
  }
  ): createdAt = createdAt ?? DateTime.now();


  factory Order.fromJson(Map<String, dynamic> json ) => Order(
      id: json["id"],
      client: json["client"] as String,
      cityId: json["city_id"] as int,
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
    "credit": credit,
    "payment_method_id": paymentMethodId,
    "estimated_date": estimatedDate.toIso8601String(),
    "status_id": statusId,
    "created_at": createdAt.toIso8601String()
  };

}
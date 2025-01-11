import 'dart:convert';

PaymentMethod paymentMethodFromJson(String str) => PaymentMethod.fromJson(json.decode(str));
String paymentMethodToJson(PaymentMethod data) => json.encode(data.toJson());

class PaymentMethod {
  int? id;
  String name;
  DateTime createdAt;

  PaymentMethod({
    this.id,
    required this.name,
    required this.createdAt
  });


  factory PaymentMethod.fromJson(Map<String, dynamic> json ) => PaymentMethod(
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
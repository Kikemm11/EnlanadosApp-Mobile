/*
This file contains the PaymentMethodController methods and main instances 

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/

import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/PaymentMethod.dart';

class PaymentMethodController with ChangeNotifier {
  List<PaymentMethod> _paymentMethods = [];
  PaymentMethod? _currentPaymentMethod;


  // Getters
  List<PaymentMethod> get paymentMethods => _paymentMethods;
  PaymentMethod? get currentPaymentMethod => _currentPaymentMethod;


  // Get all the payment methods
  Future<String> getAllPaymentMethods() async {
    try {
      _paymentMethods = await DBProvider.db.readAllPaymentMethods();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  // Get one payment methodgiven its id
  Future<PaymentMethod?> getOnePaymentMethod(int paymentMethodId) async {
    try {
      _currentPaymentMethod = await DBProvider.db.readOnePaymentMethod(paymentMethodId);
      notifyListeners();
      return _currentPaymentMethod;
    } catch (e) {
      return null;
    }
  }
}
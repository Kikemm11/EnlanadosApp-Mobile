import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/PaymentMethod.dart';

class PaymentMethodController with ChangeNotifier {
  List<PaymentMethod> _paymentMethods = [];
  PaymentMethod? _currentPaymentMethod;

  List<PaymentMethod> get paymentMethods => _paymentMethods;

  PaymentMethod? get currentPaymentMethod => _currentPaymentMethod;

  Future<String> getAllPaymentMethods() async {
    try {
      _paymentMethods = await DBProvider.db.readAllPaymentMethods();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

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
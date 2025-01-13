import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/Order.dart';

class OrderController with ChangeNotifier {
  List<Order> _orders = [];
  Order? _currentOrder;

  List<Order> get orders => _orders;

  Order? get currentOrder => _currentOrder;

  Future<String> getAllOrders() async {
    try {
      _orders = await DBProvider.db.readAllOrders();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> getOneOrder(Order order) async {
    try {
      _currentOrder = await DBProvider.db.readOneOrder(order);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> insertOrder(Order order) async {
    try {
      await DBProvider.db.insertOrder(order);
    } catch(e){
      return e.toString();
    }
    return await getAllOrders();
  }

  Future<String> updateOrder(Order order) async {
    try {
      await DBProvider.db.updateOrder(order);
    } catch(e){
      return e.toString();
    }
    return await getAllOrders();
  }

  Future<String> deliverOrder(Order order) async {
    try {
      await DBProvider.db.deliverOrder(order);
    } catch(e){
      return e.toString();
    }
    return await getAllOrders();
  }

  Future<String> cancelOrder(Order order) async {
    try {
      await DBProvider.db.cancelOrder(order);
    } catch(e){
      return e.toString();
    }
    return await getAllOrders();
  }

  Future<String> deleteOrder(Order order) async {
    try {
      await DBProvider.db.deleteOrder(order);
    } catch(e){
      return e.toString();
    }
    return await getAllOrders();
  }
}
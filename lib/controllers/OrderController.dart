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

  Future<String> getCurrentMonthOrders() async {
    try {
      _orders = await DBProvider.db.readCurrentMonthOrders();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> getFilteredOrders(Map<String, dynamic> filterData) async {
    try {
      _orders = await DBProvider.db.readFilteredOrders(filterData);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<int?> insertOrder(Order order) async {
    try {
      Order newOrder = await DBProvider.db.insertOrder(order);
      return newOrder.id;
    } catch(e){
      return -1;
    }
  }

  Future<String> updateOrder(Order order) async {
    try {
      await DBProvider.db.updateOrder(order);
    } catch(e){
      return e.toString();
    }
    return 'Ok';
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

  Future<String> deleteOrder(int orderId) async {
    try {
      await DBProvider.db.deleteOrder(orderId);
    } catch(e){
      return e.toString();
    }
    return await getAllOrders();
  }
}
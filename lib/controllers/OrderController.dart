import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/Order.dart';
import 'package:enlanados_app_mobile/controllers/ItemController.dart';

class OrderController with ChangeNotifier {
  List<Order> _orders = [];
  List<Order> _ordersHome = [];
  List<Order> _statisticOrders = [];
  int _totalOrders = 0;
  double _totalIncome = 0.0;
  Order? _currentOrder;

  List<Order> get orders => _orders;
  List<Order> get ordersHome => _ordersHome;
  List<Order> get statisticOrders => _statisticOrders;
  int get totalOrders => _totalOrders;
  double get totalIncome => _totalIncome;
  Order? get currentOrder => _currentOrder;

  Future<String> getCurrentMonthWhitStatusOrders() async {
    try {
      _ordersHome = await DBProvider.db.readCurrentMonthWhitStatusOrders();
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

  Future<String> getStatisticsOrders(Map<String, dynamic> dateData) async {
    double totalIncome = 0.0;

    try {
      _statisticOrders = await DBProvider.db.readStatisticsOrders(dateData);
      _totalOrders = _statisticOrders.length;

      for (Order order in _statisticOrders) {
        totalIncome += await ItemController().getOrderTotalIncome(order);
      }

      _totalIncome = totalIncome;

      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  String cleanStatisticsData() {
    _statisticOrders = [];
    _totalIncome = 0.0;
    _totalOrders = 0;
    notifyListeners();
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
    return 'Ok';
  }

  Future<String> cancelOrder(Order order) async {
    try {
      await DBProvider.db.cancelOrder(order);
    } catch(e){
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> deleteOrder(int orderId) async {
    try {
      await DBProvider.db.deleteOrder(orderId);
    } catch(e){
      return e.toString();
    }
    return 'Ok';
  }
}
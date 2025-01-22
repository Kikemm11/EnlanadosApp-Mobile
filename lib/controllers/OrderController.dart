/*
This file contains the OrderController methods and main instances 

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/

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


  // Getters
  List<Order> get orders => _orders;
  List<Order> get ordersHome => _ordersHome;
  List<Order> get statisticOrders => _statisticOrders;
  int get totalOrders => _totalOrders;
  double get totalIncome => _totalIncome;
  Order? get currentOrder => _currentOrder;


  // Get all the current month orders with status 'Pendiente'
  Future<String> getCurrentMonthWhitStatusOrders() async {
    try {
      _ordersHome = await DBProvider.db.readCurrentMonthWhitStatusOrders();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }


  // Get one order given its id
  Future<String> getOneOrder(Order order) async {
    try {
      _currentOrder = await DBProvider.db.readOneOrder(order);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  // Get all the current month orders
  Future<String> getCurrentMonthOrders() async {
    try {
      _orders = await DBProvider.db.readCurrentMonthOrders();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  // Get all the orders wich correspond to the applied filters
  Future<String> getFilteredOrders(Map<String, dynamic> filterData) async {
    try {
      _orders = await DBProvider.db.readFilteredOrders(filterData);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  // Get all the orders between the two selected dates and calculate its statistical info
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

  // Set to default value the statistics value
  String cleanStatisticsData() {
    _statisticOrders = [];
    _totalIncome = 0.0;
    _totalOrders = 0;
    notifyListeners();
    return 'Ok';
  }

  // Insert a new order
  Future<int?> insertOrder(Order order) async {
    try {
      Order newOrder = await DBProvider.db.insertOrder(order);
      return newOrder.id;
    } catch(e){
      return -1;
    }
  }

  // Update an order given its id
  Future<String> updateOrder(Order order) async {
    try {
      await DBProvider.db.updateOrder(order);
    } catch(e){
      return e.toString();
    }
    return 'Ok';
  }

  // Change the status of an order from 'Pendiente' to 'Entregado'
  Future<String> deliverOrder(Order order) async {
    try {
      await DBProvider.db.deliverOrder(order);
    } catch(e){
      return e.toString();
    }
    return 'Ok';
  }

  // Change the status of an order from 'Pendiente' to 'Cancelado'
  Future<String> cancelOrder(Order order) async {
    try {
      await DBProvider.db.cancelOrder(order);
    } catch(e){
      return e.toString();
    }
    return 'Ok';
  }

  // Delete an order (Not used for now)
  Future<String> deleteOrder(int orderId) async {
    try {
      await DBProvider.db.deleteOrder(orderId);
    } catch(e){
      return e.toString();
    }
    return 'Ok';
  }
}
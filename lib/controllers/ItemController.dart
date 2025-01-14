import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/Order.dart';
import 'package:enlanados_app_mobile/models/Item.dart';

class ItemController with ChangeNotifier {
  List<Item> _items = [];
  Item? _currentItem;

  List<Item> get items => _items;

  Item? get currentItem => _currentItem;

  Future<String> getOrderItems(Order order) async {
    try {
      _items = await DBProvider.db.readOrderItems(order);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> getOneItem(Item item) async {
    try {
      _currentItem = await DBProvider.db.readOneItem(item);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> insertItem(Item item) async {
    try {
      await DBProvider.db.insertItem(item);
    } catch(e){
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> updateItem(Item item) async {
    try {
      await DBProvider.db.updateItem(item);
    } catch(e){
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> deleteItem(Item item) async {
    try {
      await DBProvider.db.deleteItem(item);
    } catch(e){
      return e.toString();
    }
    return 'Ok';
  }
}
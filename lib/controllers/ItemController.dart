import 'package:enlanados_app_mobile/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/Order.dart';
import 'package:enlanados_app_mobile/models/Item.dart';

class ItemController with ChangeNotifier {
  List<Item> _items = [];
  Item? _currentItem;

  List<Item> get items => _items;

  Item? get currentItem => _currentItem;

  Future<String> getOrderItems(int orderId) async {
    try {
      _items = await DBProvider.db.readOrderItems(orderId);
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
  
  Future<double> getOrderTotalIncome(Order order) async {

    try {
      double result = 0.0;
      List<Item> items = await DBProvider.db.readOrderItems(order.id!);

      for (Item item in items) {
        ProductType productType = await DBProvider.db.readOneProductType(item.productTypeId);
        result += (productType.price + item.addedPrice - item.discount);
      }
      return result;
    } catch (e) {
      return 0.0;
    }
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

  Future<String> deleteItem(Item item, orderId) async {
    try {
      await DBProvider.db.deleteItem(item);
    } catch(e){
      return e.toString();
    }
    return getOrderItems(orderId);
  }
}
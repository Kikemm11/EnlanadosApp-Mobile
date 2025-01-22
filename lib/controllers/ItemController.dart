/*
This file contains the ItemController methods and main instances 

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/

import 'package:enlanados_app_mobile/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/Order.dart';
import 'package:enlanados_app_mobile/models/Item.dart';

class ItemController with ChangeNotifier {
  List<Item> _items = [];
  Item? _currentItem;


  // Getters
  List<Item> get items => _items;
  Item? get currentItem => _currentItem;


  // Get all the items related to an order given its id from the database
  Future<String> getOrderItems(int orderId) async {
    try {
      _items = await DBProvider.db.readOrderItems(orderId);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }


  // Get all the items related to an order given its id from 
  //the database and return them as a list
  Future<List<Item>> getOrderItemsList(int orderId) async {
    try {
      _items = await DBProvider.db.readOrderItems(orderId);
      notifyListeners();
      return _items;
    } catch (e) {
      return [];
    }
  }

  // Get one item from the database given its id
  Future<String> getOneItem(Item item) async {
    try {
      _currentItem = await DBProvider.db.readOneItem(item);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }
  
  // Calculates the total amount of income from an order trought 
  // all its related items taking in count its added price and discount
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

  // Creates an item
  Future<String> insertItem(Item item) async {
    try {
      await DBProvider.db.insertItem(item);
    } catch(e){
      return e.toString();
    }
    return 'Ok';
  }

  // Updates an item
  Future<String> updateItem(Item item) async {
    try {
      await DBProvider.db.updateItem(item);
    } catch(e){
      return e.toString();
    }
    return 'Ok';
  }

  // Deletes an item
  Future<String> deleteItem(Item item, orderId) async {
    try {
      await DBProvider.db.deleteItem(item);
    } catch(e){
      return e.toString();
    }
    return getOrderItems(orderId);
  }
}
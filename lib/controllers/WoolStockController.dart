/*
This file contains the WoolStockController methods and main instances 

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/

import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/WoolStock.dart';

class WoolStockController with ChangeNotifier {
  List<WoolStock> _woolStock = [];
  WoolStock? _currentWoolStock;


  // Getters
  List<WoolStock> get woolStock => _woolStock;
  WoolStock? get currentWoolStock => _currentWoolStock;


  // Get all the wools 
  Future<String> getAllWoolStocks() async {
    try {
      _woolStock = await DBProvider.db.readAllWoolStock();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  // Get one wool given its id
  Future<String> getOneWoolStock(WoolStock woolStock) async {
    try {
      _currentWoolStock = await DBProvider.db.readOneWoolStock(woolStock);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  // Insert a wool
  Future<String> insertWoolStock(WoolStock woolStock) async {
    try {
      await DBProvider.db.insertWoolStock(woolStock);
    } catch(e){
      if (e.toString().contains('UNIQUE')) {
        return 'UNIQUE';
      } else {
        return e.toString();
      }
    }
    return await getAllWoolStocks();
  }

  // Update a wool given its id
  Future<String> updateWoolStock(WoolStock woolStock) async {
    try {
      await DBProvider.db.updateWoolStock(woolStock);
    } catch(e){
      return e.toString();
    }
    return await getAllWoolStocks();
  }

  // Increment the quantity of a particular wool by one
  Future<String> incrementWoolStock(WoolStock woolStock) async {
    try {
      woolStock.quantity += 1;
      woolStock.lastUpdated = DateTime.now();
      await DBProvider.db.updateWoolStock(woolStock);
    } catch(e){
      return e.toString();
    }
    return await getAllWoolStocks();
  }

  // Decrement the quantity of a particular wool by one avoiding negatives
  Future<String> decrementWoolStock(WoolStock woolStock) async {
    try {
      woolStock.quantity = woolStock.quantity - 1 < 0 ? 0 : woolStock.quantity - 1;
      woolStock.lastUpdated = DateTime.now();
      await DBProvider.db.updateWoolStock(woolStock);
    } catch(e){
      return e.toString();
    }
    return await getAllWoolStocks();
  }

  // Delete a wool given its id
  Future<String> deleteWoolStock(WoolStock woolStock) async {
    try {
      await DBProvider.db.deleteWoolStock(woolStock);
    } catch(e){
      return e.toString();
    }
    return await getAllWoolStocks();
  }
}
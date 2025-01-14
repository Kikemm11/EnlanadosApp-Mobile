import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/WoolStock.dart';

class WoolStockController with ChangeNotifier {
  List<WoolStock> _woolStock = [];
  WoolStock? _currentWoolStock;

  List<WoolStock> get woolStock => _woolStock;

  WoolStock? get currentWoolStock => _currentWoolStock;

  Future<String> getAllWoolStocks() async {
    try {
      _woolStock = await DBProvider.db.readAllWoolStock();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> getOneWoolStock(WoolStock woolStock) async {
    try {
      _currentWoolStock = await DBProvider.db.readOneWoolStock(woolStock);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

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

  Future<String> updateWoolStock(WoolStock woolStock) async {
    try {
      await DBProvider.db.updateWoolStock(woolStock);
    } catch(e){
      return e.toString();
    }
    return await getAllWoolStocks();
  }

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

  Future<String> deleteWoolStock(WoolStock woolStock) async {
    try {
      await DBProvider.db.deleteWoolStock(woolStock);
    } catch(e){
      return e.toString();
    }
    return await getAllWoolStocks();
  }
}
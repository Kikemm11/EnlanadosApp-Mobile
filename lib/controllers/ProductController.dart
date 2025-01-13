import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/Product.dart';

class ProductController with ChangeNotifier {
  List<Product> _products = [];
  Product? _currentProduct;

  List<Product> get products => _products;

  Product? get currentProduct => _currentProduct;

  Future<String> getAllProducts() async {
    try {
      _products = await DBProvider.db.readAllProducts();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> getOneProduct(Product product) async {
    try {
      _currentProduct = await DBProvider.db.readOneProduct(product);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> insertProduct(Product product) async {
    try {
      await DBProvider.db.insertProduct(product);
    } catch(e){
      if (e.toString().contains('UNIQUE')) {
        return 'UNIQUE';
      } else {
        return e.toString();
      }
    }
    return await getAllProducts();
  }

  Future<String> updateProduct(Product product) async {
    try {
      await DBProvider.db.updateProduct(product);
    } catch(e){
      if (e.toString().contains('UNIQUE')) {
        return 'UNIQUE';
      } else {
        return e.toString();
      }
    }
    return await getAllProducts();
  }

  Future<String> deleteProduct(Product product) async {
    try {
      await DBProvider.db.deleteProduct(product);
    } catch(e){
      return e.toString();
    }
    return await getAllProducts();
  }
}
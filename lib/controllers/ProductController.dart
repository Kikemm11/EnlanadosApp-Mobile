/*
This file contains the ProductController methods and main instances 

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/

import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/Product.dart';

class ProductController with ChangeNotifier {
  List<Product> _products = [];
  Product? _currentProduct;


  // Getters
  List<Product> get products => _products;
  Product? get currentProduct => _currentProduct;


  // Get all the products
  Future<String> getAllProducts() async {
    try {
      _products = await DBProvider.db.readAllProducts();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  // Get one product given its id
  Future<Product?> getOneProduct(int productId) async {
    try {
      _currentProduct = await DBProvider.db.readOneProduct(productId);
      notifyListeners();
      return _currentProduct;
    } catch (e) {
      return null;
    }
  }

  // Insert a product and manage UNIQUE constraint
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

  // Update a porduct given its id
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

  // Delete a product given its id
  Future<String> deleteProduct(Product product) async {
    try {
      await DBProvider.db.deleteProduct(product);
    } catch(e){
      return e.toString();
    }
    return await getAllProducts();
  }
}
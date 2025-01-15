import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/ProductType.dart';

class ProductTypeController with ChangeNotifier {
  List<ProductType> _productTypes = [];
  ProductType? _currentProductType;

  List<ProductType> get productTypes => _productTypes;

  ProductType? get currentProductType => _currentProductType;

  Future<String> getAllProductTypes() async {
    try {
      _productTypes = await DBProvider.db.readAllProductTypes();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> getOneProductType(int productTypeId) async {
    try {
      _currentProductType = await DBProvider.db.readOneProductType(productTypeId);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> insertProductType(ProductType productType) async {
    try {
      await DBProvider.db.insertProductType(productType);
    } catch(e){
      return e.toString();
    }
    return await getAllProductTypes();
  }

  Future<String> updateProductType(ProductType productType) async {
    try {
      await DBProvider.db.updateProductType(productType);
    } catch(e){
      return e.toString();
    }
    return await getAllProductTypes();
  }

  Future<String> deleteProductType(ProductType productType) async {
    try {
      await DBProvider.db.deleteProductType(productType);
    } catch(e){
      return e.toString();
    }
    return await getAllProductTypes();
  }
}
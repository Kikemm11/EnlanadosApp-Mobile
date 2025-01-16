import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/ProductType.dart';

class ProductTypeController with ChangeNotifier {
  List<ProductType> _productTypes = [];
  List<ProductType> _productProductTypes = [];
  ProductType? _currentProductType;

  List<ProductType> get productTypes => _productTypes;

  List<ProductType> get productProductTypes => _productProductTypes;

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

  Future<String> getProductProductTypes(int productId) async {
    try {
      _productProductTypes = await DBProvider.db.readProductProductTypes(productId);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<ProductType?> getOneProductType(int productTypeId) async {
    try {
      _currentProductType = await DBProvider.db.readOneProductType(productTypeId);
      notifyListeners();
      return _currentProductType;
    } catch (e) {
      return null;
    }
  }

  Future<String> insertProductType(ProductType productType, int productId) async {
    try {
      await DBProvider.db.insertProductType(productType);
    } catch(e){
      return e.toString();
    }
    return await getProductProductTypes(productId);
  }

  Future<String> updateProductType(ProductType productType, int productId) async {
    try {
      await DBProvider.db.updateProductType(productType);
    } catch(e){
      return e.toString();
    }
    return await getProductProductTypes(productId);
  }

  Future<String> deleteProductType(ProductType productType, int productId) async {
    try {
      await DBProvider.db.deleteProductType(productType);
    } catch(e){
      return e.toString();
    }
    return await getProductProductTypes(productId);
  }
}
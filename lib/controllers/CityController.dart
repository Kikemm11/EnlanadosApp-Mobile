/*
This file contains the CityController methods and main instances 

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/

import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/City.dart';


class CityController with ChangeNotifier {
  List<City> _cities = [];
  City? _currentCity;


  // Getters
  List<City> get cities => _cities;
  City? get currentCity => _currentCity;


  // Query all the cities from the database 
  Future<String> getAllCities() async {
    try {
      _cities = await DBProvider.db.readAllCities();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  // Query one city from the database given its id
  Future<City?> getOneCity(int cityId) async {
    try {
      _currentCity = await DBProvider.db.readOneCity(cityId);
      notifyListeners();
      return _currentCity;
    } catch (e) {
      return null;
    }
  }
}
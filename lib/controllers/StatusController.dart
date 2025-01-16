import 'package:flutter/cupertino.dart';
import 'package:enlanados_app_mobile/database/Database.dart';
import 'package:enlanados_app_mobile/models/Status.dart';

class StatusController with ChangeNotifier {
  List<Status> _statuses = [];
  Status? _currentStatus;

  List<Status> get statuses => _statuses;

  Status? get currentStatus => _currentStatus;

  Future<String> getAllStatuses() async {
    try {
      _statuses = await DBProvider.db.readAllStatuses();
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<Status?> getOneStatus(int statusId) async {
    try {
      _currentStatus = await DBProvider.db.readOneStatus(statusId);
      notifyListeners();
      return _currentStatus;
    } catch (e) {
      return null;
    }
  }
}
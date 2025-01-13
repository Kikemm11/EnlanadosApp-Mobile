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

  Future<String> getOneStatus(Status status) async {
    try {
      _currentStatus = await DBProvider.db.readOneStatus(status);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }
}
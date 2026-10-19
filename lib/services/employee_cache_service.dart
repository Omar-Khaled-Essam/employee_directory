import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/employee.dart';

class EmployeeCacheService {
  static const String _cacheKey = 'cached_employees';

  Future<void> saveEmployees(List<Employee> employees) async {
    final preferences = await SharedPreferences.getInstance();

    final jsonList = employees.map((employee) {
      return employee.toJson();
    }).toList();

    await preferences.setString(_cacheKey, jsonEncode(jsonList));
  }

  Future<List<Employee>> getCachedEmployees() async {
    final preferences = await SharedPreferences.getInstance();
    final cachedJson = preferences.getString(_cacheKey);

    if (cachedJson == null || cachedJson.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(cachedJson);

      if (decoded is! List) return [];

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Employee.fromJson)
          .toList();
    } on FormatException {
      return [];
    }
  }
}

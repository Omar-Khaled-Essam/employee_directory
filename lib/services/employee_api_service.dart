import 'package:dio/dio.dart';

import '../models/employee.dart';

class EmployeeApiService {
  static const String _baseUrl = 'https://dummy.restapiexample.com/api/v1';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await _dio.get('/employees');

      final body = response.data;

      if (body is! Map<String, dynamic> ||
          body['status'] != 'success' ||
          body['data'] is! List) {
        throw Exception('The server returned invalid employee data.');
      }

      // Parse each JSON object into an Employee.
      return (body['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Employee.fromJson)
          .toList();
    } on DioException catch (error) {
      if (error.response?.statusCode == 429) {
        throw Exception('Too many requests. Please wait and try again.');
      }

      if (error.response != null) {
        throw Exception(
          'The server returned an error. Please try again later.',
        );
      }

      throw Exception('Unable to connect. Check your internet connection.');
    }
  }
}

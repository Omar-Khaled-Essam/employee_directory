import 'package:flutter/material.dart';

import '../models/employee.dart';
import '../services/employee_api_service.dart';
import '../services/employee_cache_service.dart';
import '../widgets/employee_card.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import 'employee_details_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final EmployeeApiService _apiService = EmployeeApiService();
  final EmployeeCacheService _cacheService = EmployeeCacheService();

  List<Employee> _employees = [];
  bool _isLoading = true;
  bool _hasLoaded = false;
  String? _errorMessage;
  bool _isUsingCache = false;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees({bool forceRefresh = false}) async {
    if (_isLoading && _hasLoaded) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Restore cached data before requesting fresh data.
      if (!_hasLoaded && !forceRefresh) {
        final cached = await _cacheService.getCachedEmployees();

        if (!mounted) return;

        if (cached.isNotEmpty) {
          setState(() {
            _employees = cached;
            _isUsingCache = true;
            _hasLoaded = true;
            _isLoading = false;
          });
        }
      }

      // Fetch fresh employee records from the REST API.
      final employees = await _apiService.fetchEmployees();

      if (!mounted) return;

      setState(() {
        _employees = employees;
        _isUsingCache = false;
        _isLoading = false;
        _hasLoaded = true;
      });

      // Save successful results for the next app launch.
      await _cacheService.saveEmployees(employees);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasLoaded = true;
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _refreshEmployees() async {
    await _loadEmployees(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Directory'),
        actions: [
          IconButton(
            tooltip: 'Refresh employees',
            onPressed: _isLoading ? null : _refreshEmployees,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _refreshEmployees,
        icon: const Icon(Icons.cloud_download),
        label: const Text('Fetch Employees'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _employees.isEmpty) {
      return const LoadingView();
    }

    if (_employees.isEmpty && _errorMessage != null) {
      return ErrorView(message: _errorMessage!, onRetry: _refreshEmployees);
    }

    if (_employees.isEmpty) {
      return const Center(child: Text('No employees available.'));
    }

    return Column(
      children: [
        if (_isLoading) const LinearProgressIndicator(),
        if (_errorMessage != null)
          MaterialBanner(
            content: Text('Could not refresh data: $_errorMessage'),
            actions: [
              TextButton(
                onPressed: _refreshEmployees,
                child: const Text('Retry'),
              ),
            ],
          ),
        if (_isUsingCache)
          const ListTile(
            leading: Icon(Icons.offline_pin),
            title: Text('Showing saved employee data'),
            dense: true,
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshEmployees,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 90, top: 8),
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                final employee = _employees[index];

                return EmployeeCard(
                  employee: employee,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            EmployeeDetailsScreen(employee: employee),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

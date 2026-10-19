import 'package:flutter/material.dart';

import '../models/employee.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailsScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Details')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                child: Text(
                  employee.name.isNotEmpty
                      ? employee.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(fontSize: 36),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                employee.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              _buildDetail(
                icon: Icons.badge_outlined,
                label: 'Employee ID',
                value: employee.id.toString(),
              ),
              _buildDetail(
                icon: Icons.work_outline,
                label: 'Position',
                value: 'Not provided by the API',
              ),
              _buildDetail(
                icon: Icons.cake_outlined,
                label: 'Age',
                value: '${employee.age} years',
              ),
              _buildDetail(
                icon: Icons.payments_outlined,
                label: 'Salary',
                value: employee.salary.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}

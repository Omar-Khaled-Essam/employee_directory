import 'package:flutter/material.dart';

import 'screens/employee_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EmployeeDirectoryApp());
}

class EmployeeDirectoryApp extends StatelessWidget {
  const EmployeeDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Directory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const EmployeeListScreen(),
    );
  }
}

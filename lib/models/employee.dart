class Employee {
  final int id;
  final String name;
  final int salary;
  final int age;
  final String profileImage;

  const Employee({
    required this.id,
    required this.name,
    required this.salary,
    required this.age,
    this.profileImage = '',
  });

  // Convert one employee JSON object into a Dart object.
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: _toInt(json['id']),
      name: json['employee_name']?.toString() ?? 'Unknown employee',
      salary: _toInt(json['employee_salary']),
      age: _toInt(json['employee_age']),
      profileImage: json['profile_image']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  // Convert the object back to JSON for local caching.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_name': name,
      'employee_salary': salary,
      'employee_age': age,
      'profile_image': profileImage,
    };
  }
}

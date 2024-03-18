class User {
  int id;
  String name;
  String email;
  String password;

  User({required this.id, required this.name, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}

class Task {
  int? id;
  String name;
  bool isCompleted;

  Task({
    this.id,
    required this.name,
    this.isCompleted = false,
  });

  // Convert Task object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}

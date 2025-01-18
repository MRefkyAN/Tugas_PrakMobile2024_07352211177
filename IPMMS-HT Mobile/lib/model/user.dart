class User {
  final String id;
  final String username;
  final String password;
  final String fullName; 
  final String email; 
  final String phone; 
  final String role; 

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      fullName: json['fullName'], 
      email: json['email'], 
      phone: json['phone'], 
      role: json['role'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'fullName': fullName, 
      'email': email, 
      'phone': phone, 
      'role': role,
    };
  }
}

class User {
  final String id;
  final String username;
  final String password;
  final String? imageUrl;

  User({
    required this.id,
    required this.username,
    required this.password,
    this.imageUrl,
  });

  // Factory method to create a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      imageUrl: json['image'] as String?,
    );
  }

  // Method to convert a User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'image': imageUrl,
    };
  }
}

class User {
  final String name;
  final String email;

  User(this.name, this.email);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}
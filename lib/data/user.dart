class User {
  const User({
    this.id,
    required this.email,
    required this.name,
    required this.yearOfBirth,
    required this.description,
    this.password,
    this.tags = const [],
    this.images = const [],
  });

  final int? id;
  final String email;
  final String? password;
  final String name;
  final int yearOfBirth;
  final String description;
  final List<String> tags;
  final List<String> images;

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json['email'] as String,
        password: json['password'] != null ? json['password'] as String : null,
        name: json['name'] as String,
        yearOfBirth: json['birth_date'] as int,
        description: json['description'] as String,
        id: json['id'] as int,
        tags: (json['tags'] as List).map((e) => e as String).toList(),
        images: (json['images'] as List).map((e) => e as String).toList(),
      );

  Map<String, String> toJson() {
    return {
      if (email.isNotEmpty) 'email': email,
      if (name.isNotEmpty) 'name': name,
      'birth_date': yearOfBirth.toString(),
      if (description.isNotEmpty) 'description': description,
      if (password?.isNotEmpty == true) 'password': password!,
    };
  }
}

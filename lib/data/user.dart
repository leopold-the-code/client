class User {
  const User({
    required this.email,
    this.name,
    this.yearOfBirth,
    this.description,
    this.password,
    this.surname,
    this.id,
    this.tags = const [],
    this.images = const [],
  });

  final String email;
  final String? name;
  final int? yearOfBirth;
  final String? description;
  final String? password;
  final String? surname;
  final int? id;
  final List<String> tags;
  final List<String> images;

  // factory User.test() => const User(
  //       email: 'test.mail.com',
  //       name: 'test name',
  //       yearOfBirth: 2001,
  //       description: 'desc1',
  //       password: 'psw1',
  //       surname: 'surname1',
  //     );

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
      'email': email,
      'name': name ?? '',
      'birth_date': yearOfBirth.toString(),
      'description': description ?? '',
      'password': password ?? '',
      'surname': surname ?? '',
    };
  }
}
// 'demotoken'

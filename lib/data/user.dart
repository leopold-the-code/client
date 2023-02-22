import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
class User {
  const User({
    required this.email,
    required this.name,
    required this.yearOfBirth,
    required this.description,
    this.password,
    this.surname,
    this.id,
  });

  final String email;
  final String name;
  final int yearOfBirth;
  final String description;
  final String? password;
  final String? surname;
  final int? id;

  factory User.test() => User(
        email: 'test.mail.com',
        name: 'test name',
        yearOfBirth: 2001,
        description: 'desc1',
        password: 'psw1',
        surname: 'surname1',
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json['email'] as String,
        name: json['name'] as String,
        yearOfBirth: 0, //json['birth_date'] as String,
        description: json['description'] as String,
      );

  Map<String, String> toJson() {
    return {
      'email': email,
      'name': name,
      'birth_date': yearOfBirth.toString(),
      'description': description,
      'password': password ?? '',
      'surname': surname ?? '',
    };
  }
}
// 'demotoken'

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String email,
    required String name,
    required int yearOfBirth,
    required String description,
  }) = _User;

  // factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}

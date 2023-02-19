import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:client/data/user.dart';
import 'package:http/http.dart' as http;

abstract class Repository {
  Future<String> register(User user, String password);
  Future<String> login(User user);
  // Future addPhoto(String url);
  Future addTag(String tag);
  Future<User> feed();
  Future like(String userId);
  Future dislike(String userId);
  Future<User> matches();
}

const String baseUrl = 'find-friends.fly.dev';

class RepositoryImpl implements Repository {
  @override
  Future<String> register(User user, String password) async {
    final url = Uri.https(baseUrl, '/register');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(user.toJson()));
    return response.body;
  }

  @override
  Future<bool> uploadImage(String filename) async {
    final url = Uri.https(baseUrl, '/upload_image');
    final request = http.MultipartRequest("POST", url);

    request.files.add(http.MultipartFile(
      'file',
      File(filename).readAsBytes().asStream(),
      File(filename).lengthSync(),
      filename: filename.split("/").last,
    ));

    request.headers.addAll({
      'accept': 'application/json',
      'X-Token':
          'aCQexsEq0A99CXd2iWdgW5HkGPwPgdwCOPWbz2sRJ/CJQu8nuZnQKabJ6nYmMVoZ1BM2CJMgXDAq+APoAOuNWQ==',
      'Content-Type': 'multipart/form-data',
    });

    return request.send().then((value) => value.statusCode == 200);
  }

  @override
  Future addTag(String tag) {
    // TODO: implement addTag
    throw UnimplementedError();
  }

  @override
  Future dislike(String userId) {
    // TODO: implement dislike
    throw UnimplementedError();
  }

  @override
  Future<User> feed() {
    // TODO: implement feed
    throw UnimplementedError();
  }

  @override
  Future like(String userId) {
    // TODO: implement like
    throw UnimplementedError();
  }

  @override
  Future<String> login(User user) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<User> matches() {
    // TODO: implement matches
    throw UnimplementedError();
  }
}

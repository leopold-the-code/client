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
  Future<List<User>> feed();
  Future like(String userId);
  Future dislike(String userId);
  Future<User> matches();
}

const String baseUrl = 'find-friends.fly.dev';
const String token =
    'Eo5k70Ze7wR9upSursFgcNJMyh4+PexD3MmnUa9NsqDXrjrcwENO09YIVEgaYA8kZC4sl+4OJnU+vG3rYxZ0GQ==';

class RepositoryImpl implements Repository {
  @override
  Future<String> register(User user, String password) async {
    final url = Uri.https(baseUrl, '/register');
    print(user.toJson());
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
      'X-Token': token,
      'Content-Type': 'multipart/form-data',
    });

    return request.send().then((value) => value.statusCode == 200);
  }

  Future<Uint8List> getImage(int id) async {
    final url = Uri.https(
      baseUrl,
      '/get_image/$id',
    );

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      'X-Token': token,
    });
    return response.bodyBytes;
  }

  @override
  Future addTag(String tag) async {}

  @override
  Future dislike(String userId) {
    // TODO: implement dislike
    throw UnimplementedError();
  }

  @override
  Future<List<User>> feed() async {
    final url = Uri.https(
      baseUrl,
      '/feed',
    );

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      'X-Token': token,
    });
    final mp = jsonDecode(response.body);
    final us = (mp['users'] as List).map((e) => User.fromJson(e)).toList();
    return us;
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

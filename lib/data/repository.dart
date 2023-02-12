import 'package:client/data/user.dart';

abstract class Repository {
  Future<String> register(User user, String password);
  Future<String> login(User user);
  Future addPhoto(String url);
  Future addTag(String tag);
  Future<User> feed();
  Future like(String userId);
  Future dislike(String userId);
  Future<User> matches();
}

class RepositoryImpl implements Repository {
  @override
  Future<String> register(User user, String password) async {
    // await Future.delayed(Duration(seconds: 2));
    return Future.value('token');
  }

  @override
  Future addPhoto(String url) {
    // TODO: implement addPhoto
    throw UnimplementedError();
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

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:client/data/user.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

const String baseUrl = 'friends.alisher.cc';

class RepositoryImpl {
  static String token = '';

  Future<String> register(User user) async {
    final url = Uri.https(baseUrl, '/register');
    print(user.toJson());
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()));
    final json = jsonDecode(response.body);
    final token = json['token'] as String?;
    if (token == null) {
      throw Exception(response.body);
    }
    return token;
  }

  Future<String> login(String email, String password) async {
    final url = Uri.https(baseUrl, '/login', {'email': email, 'password': password});
    final response = await http.post(url, headers: {'Content-Type': 'application/json'});
    final json = jsonDecode(response.body);
    final token = json['token'] as String?;
    if (token == null) {
      throw Exception(response.body);
    }
    return token;
  }

  Future<User?> me() async {
    final url = Uri.https(baseUrl, '/me');
    final response = await http.get(url, headers: {
      'accept': 'application/json',
      'X-Token': token,
    });
    if (response.statusCode == 200) {
      final u = User.fromJson(jsonDecode(response.body));
      return u;
    }
    return null;
  }

  Future<bool> updateProfile(User me) async {
    final url = Uri.https(baseUrl, '/me');
    final json = me.toJson();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Token': token,
      },
      body: jsonEncode(json),
    );
    return response.body.isNotEmpty;
  }

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

  Future<bool> addTag(String tag) async {
    final url = Uri.https(baseUrl, '/tag', {'tag_value': tag});
    final response = await http.post(url, headers: {
      'accept': 'application/json',
      'X-Token': token,
    });
    return response.body.isNotEmpty;
  }

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

  Future<bool> like(int userId) async {
    final url = Uri.https(baseUrl, '/like', {'subject': userId.toString()});
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Token': token,
      },
    );
    return response.body.isNotEmpty;
  }

  Future<bool> dislike(int userId) async {
    final url = Uri.https(baseUrl, '/dislike', {'subject': userId.toString()});
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Token': token,
      },
    );
    return response.body.isNotEmpty;
  }

  Future<List<User>> matches() async {
    final url = Uri.https(
      baseUrl,
      '/matches',
    );

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      'X-Token': token,
    });
    final mp = jsonDecode(response.body);
    final us = (mp as List).map((e) => User.fromJson(e)).toList();
    return us;
  }

  Future<bool> updateLocation() async {
    Location location = Location();
    PermissionStatus permissionGranted;

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    LocationData locationData = await location.getLocation();
    await _updateLocation(locationData.latitude!, locationData.longitude!);
    return true;
  }

  Future<bool> _updateLocation(double lat, double long) async {
    final url = Uri.https(baseUrl, '/me');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Token': token,
      },
      body: jsonEncode({
        'latitude': lat,
        'longitude': long,
      }),
    );
    return response.body.isNotEmpty;
  }

  Future<bool> resetFeed() async {
    final url = Uri.https(baseUrl, '/reset_swipes');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Token': token,
      },
    );
    return response.body.isNotEmpty;
  }
}

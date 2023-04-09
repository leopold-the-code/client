import 'package:client/app.dart';
import 'package:client/app_state.dart';
import 'package:client/data/repository.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextStyle get style => const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    RepositoryImpl()
        .me()
        .then((value) => AppScope.of(context)?.me = value)
        .then((value) => mounted ? setState(() {}) : null);
  }

  @override
  Widget build(BuildContext context) {
    final me = AppScope.of(context)!.me!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email: ${me.email}',
            style: style,
          ),
          Text(
            'Name: ${me.name}',
            style: style,
          ),
          Text(
            'Description: ${me.description}',
            style: style,
          ),
          Text(
            'Year of birth: ${me.yearOfBirth}',
            style: style,
          ),
          Text(
            'Tags: ${me.tags}',
            style: style,
          ),
          const SizedBox(height: 20),
          if (me.hasLocationData)
            Text(
              'lat: ${me.lat}, long: ${me.long}',
              style: style,
            ),
          if (me.images.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('No uploaded image found'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.uploadImage.name);
            },
            child: const Text('Upload image'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.matches.name);
            },
            child: const Text('Matches'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.tags.name);
            },
            child: const Text('Add tag'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.updateProfile.name);
            },
            child: const Text('Update profile data'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              RepositoryImpl().resetFeed();
            },
            child: const Text('Reset feed'),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                AppScope.of(context)?.token = '';
                Navigator.of(context).pushNamed(Routes.init.name);
              },
              child: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }
}

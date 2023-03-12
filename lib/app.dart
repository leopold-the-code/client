import 'package:client/app_state.dart';
import 'package:client/routes/feed.dart';
import 'package:client/routes/home.dart';
import 'package:client/routes/profile.dart';
import 'package:client/routes/tag_screen.dart';
import 'package:client/routes/upload_photo.dart';
import 'package:flutter/material.dart';

import 'routes/login.dart';
import 'routes/register.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      child: MaterialApp(
        home: const InitialScreen(),
        routes: {
          Routes.init.name: (context) => const InitialScreen(),
          Routes.register.name: (context) => const RegistrationScreen(),
          Routes.login.name: (context) => const LoginScreen(),
          Routes.uploadImage.name: (context) => const UploadPhoto(),
          Routes.home.name: (context) => const HomeScreen(),
          Routes.feed.name: (context) => const FeedScreen(),
          Routes.profile.name: (context) => const MyProfile(),
          Routes.tags.name: (context) => const TagScreen(),
          Routes.updateProfile.name: (context) => const RegistrationScreen(isUpdateProfile: true),
        },
      ),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.register.name);
                },
                child: const Text('Registration')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.login.name);
                },
                child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}

enum Routes {
  init('/init'),
  register('/register'),
  login('/login'),

  home('/home'),
  feed('/feed'),
  profile('/profile'),
  uploadImage('/upload_image'),
  tags('/tags'),
  updateProfile('/update_profile');

  final String name;
  const Routes(this.name);

  @override
  String toString() => name;
}

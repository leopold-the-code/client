import 'package:client/app_state.dart';
import 'package:client/data/repository.dart';
import 'package:client/routes/feed.dart';
import 'package:client/routes/home.dart';
import 'package:client/routes/matches.dart';
import 'package:client/routes/profile.dart';
import 'package:client/routes/tag_screen.dart';
import 'package:client/routes/upload_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'routes/login.dart';
import 'routes/register.dart';

const bool enableTestUser = true;

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
          Routes.matches.name: (context) => const MatchesScreen(),
        },
      ),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.loose,
        children: [
          Positioned(
            width: screenWidth,
            child: SvgPicture.asset(
              'assets/onboarding_bg.svg',
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      // fontFamily: 'Gilroy',
                    ),
                  ),
                ),
                const SizedBox(height: 270),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.register.name);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Registration',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.login.name);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1976D2))),
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                if (enableTestUser) ...[
                  ElevatedButton(
                    onPressed: () async {
                      final token = await RepositoryImpl().login(
                        'morti@gmail.com',
                        '11111',
                      );

                      if (token.isNotEmpty) {
                        print('registered. token: $token');
                        AppScope.of(context)?.token = token;
                        RepositoryImpl.token = token;

                        final me = await RepositoryImpl().me();
                        AppScope.of(context)?.me = me;
                        Navigator.of(context).pushNamed(Routes.home.name);
                      }
                    },
                    child: const Text('Login as test user'),
                  ),
                ],
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
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
  updateProfile('/update_profile'),
  matches('/matches');

  final String name;
  const Routes(this.name);

  @override
  String toString() => name;
}

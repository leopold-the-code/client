import 'package:client/app.dart';
import 'package:client/data/repository.dart';
import 'package:client/routes/feed.dart';
import 'package:client/routes/profile.dart';
import 'package:client/routes/upload_photo.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../data/user.dart';
import '../app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum NavBar {
  feed(0),
  profile(1);

  final int ind;
  const NavBar(this.ind);
}

class _HomeScreenState extends State<HomeScreen> {
  NavBar navState = NavBar.feed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'),
        actions: [
          ElevatedButton(
              onPressed: () {
                AppScope.of(context)?.token = '';
                Navigator.of(context).pushNamed(Routes.init.name);
              },
              child: Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            navState = NavBar.feed;
          } else {
            navState = NavBar.profile;
          }
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dynamic_feed), label: 'feed'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
        ],
      ),
      body: navState.index == 0 ? FeedScreen() : MyProfile(),
    );
  }
}

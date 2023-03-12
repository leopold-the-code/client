import 'package:client/routes/feed.dart';
import 'package:client/routes/profile.dart';
import 'package:flutter/material.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            navState = NavBar.feed;
          } else {
            navState = NavBar.profile;
          }
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dynamic_feed), label: 'feed'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
        ],
      ),
      body: SafeArea(child: navState.index == 0 ? const FeedScreen() : const MyProfile()),
    );
  }
}

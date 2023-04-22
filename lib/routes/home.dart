import 'package:client/data/repository.dart';
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
  int _index = 0;

  @override
  void initState() {
    super.initState();
    RepositoryImpl().updateLocation().then((updated) {
      if (updated) {
        debugPrint('location updated');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B2238),
        onTap: (index) {
          if (index == 0) {
            navState = NavBar.feed;
            _index = 0;
          } else {
            navState = NavBar.profile;
            _index = 1;
          }
          setState(() {});
        },
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dynamic_feed_sharp,
              color: _index == 0 ? Colors.white : null,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _index == 1 ? Colors.white : null,
            ),
            label: '',
          ),
        ],
      ),
      body: SafeArea(child: navState.index == 0 ? const FeedScreen() : const MyProfile()),
    );
  }
}

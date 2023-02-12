import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../data/user.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late MatchEngine _matchEngine;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    for (int i = 1; i < 5; i++) {
      users.add(generateUser(i));
    }
    _matchEngine =
        MatchEngine(swipeItems: <SwipeItem>[...users.map((u) => SwipeItem(content: u)).toList()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: SwipeCards(
              matchEngine: _matchEngine,
              onStackFinished: () {
                print('finished');
              },
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/ranger_${index + 1}.jpeg'),
                    ),
                  ),
                  child: Text(
                    users[index].name,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                );
              }),
        ),
      ),
    );
  }

  User generateUser(int id) => User(
        email: 'email$id',
        name: 'name$id',
        yearOfBirth: id,
        description: 'description $id',
      );
}

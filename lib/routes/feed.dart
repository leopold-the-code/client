import 'package:client/app.dart';
import 'package:client/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../data/user.dart';
import 'app_state.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late MatchEngine _matchEngine;
  List<User> users = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('dep feed');
    RepositoryImpl().feed().then((value) {
      users.addAll(value);
      _matchEngine =
          MatchEngine(swipeItems: <SwipeItem>[...users.map((u) => SwipeItem(content: u)).toList()]);
      setState(() {});
    });
    _matchEngine =
        MatchEngine(swipeItems: <SwipeItem>[...users.map((u) => SwipeItem(content: u)).toList()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feed')),
      floatingActionButton: FloatingActionButton(
        child: Text('logout'),
        onPressed: () {
          AppScope.of(context)?.token = '';
          AppScope.of(context)?.setState(() {
            
          });
          // Navigator.of(context).pushNamed(Routes.init.name);
          // setState(() {});
        },
      ),
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
                      image: AssetImage('assets/ranger_${(index % 4 + 1)}.jpeg'),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        users[index].name,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        users[index].description,
                        style: TextStyle(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
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

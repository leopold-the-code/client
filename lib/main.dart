import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Demo(),
      ),
    );
  }
}

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  late MatchEngine _matchEngine;
  final List<User> users = <User>[
    User(name: 'Sanzh', color: Colors.green),
    User(name: 'Alish', color: Colors.blue),
    User(name: 'Dias', color: Colors.red),
    User(name: 'Khalinur', color: Colors.orange)
  ];

  @override
  void initState() {
    super.initState();
    _matchEngine =
        MatchEngine(swipeItems: <SwipeItem>[...users.map((u) => SwipeItem(content: u)).toList()]);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                    color: users[index].color,
                    image: DecorationImage(image: AssetImage('assets/ranger_${index + 1}.jpeg'))),
                child: Text(
                  users[index].name,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              );
            }),
      ),
    );
  }
}

class User {
  final String name;
  final Color color;

  User({
    required this.name,
    required this.color,
  });
}

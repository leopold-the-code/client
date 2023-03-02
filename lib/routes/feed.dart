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
    final sz = MediaQuery.of(context).size;
    final h = sz.height / 2;

    return Center(
      child: SizedBox(
        height: h,
        child: SwipeCards(
            matchEngine: _matchEngine,
            onStackFinished: () {
              print('finished');
            },
            itemBuilder: (context, index) {
              final imgs = users[index].images;

              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(20),
                  image: imgs.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imgs.first, headers: {
                          'accept': 'application/json',
                          'X-Token': RepositoryImpl.token,
                        }))
                      : DecorationImage(image: AssetImage('assets/ranger_${(index % 4 + 1)}.jpeg')),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      users[index].email,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      users[index].name ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      users[index].description ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'tags: ${users[index].tags.join(',')}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

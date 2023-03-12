import 'package:client/data/repository.dart';
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
    return SwipeCards(
      matchEngine: _matchEngine,
      onStackFinished: () {},
      upSwipeAllowed: true,
      itemBuilder: (context, index) {
        final user = users[index];
        return InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((context) => _ProfileInfoCard(user: user)),
              );
            },
            child: _Card(user: user));
      },
    );
  }
}

class _Card extends StatelessWidget {
  final User user;

  const _Card({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: user.images.isNotEmpty
            ? DecorationImage(
                fit: BoxFit.fitHeight,
                image: NetworkImage(
                  user.images.last,
                  headers: {
                    'accept': 'application/json',
                    'X-Token': RepositoryImpl.token,
                  },
                ),
              )
            : const DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage('assets/ranger_1.jpeg'),
              ),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.center,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name}, ${2023 - user.yearOfBirth}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.tags.join(', '),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final User user;

  const _ProfileInfoCard({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (user.images.isNotEmpty)
          Image(
            fit: BoxFit.fitHeight,
            image: NetworkImage(
              user.images.last,
              headers: {
                'accept': 'application/json',
                'X-Token': RepositoryImpl.token,
              },
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name}, ${2023 - user.yearOfBirth}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.tags.join(', '),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.description,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (user.images.isNotEmpty)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              height: 100,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: user.images
                      .map(
                        (img) => Image(
                          image: NetworkImage(
                            img,
                            headers: {
                              'accept': 'application/json',
                              'X-Token': RepositoryImpl.token,
                            },
                          ),
                        ),
                      )
                      .toList()),
            ),
          ),
      ],
    );
  }
}

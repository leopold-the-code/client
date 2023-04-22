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
  final List<User> users = [];
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _matchEngine = MatchEngine(swipeItems: <SwipeItem>[]);
    _loadFeed();
  }

  Future<void> _loadFeed() {
    setState(() => _isLoading = true);
    return RepositoryImpl().feed().then((value) {
      users.clear();
      users.addAll(value);
      _matchEngine = MatchEngine(swipeItems: <SwipeItem>[...users.map((u) => _item(u)).toList()]);
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (users.isEmpty) {
      return const Center(child: Text('Feed is empty'));
    }

    return SwipeCards(
      matchEngine: _matchEngine,
      onStackFinished: () {
        debugPrint('adios feed finished');
        _loadFeed();
      },
      upSwipeAllowed: true,
      itemBuilder: (context, index) {
        final user = users[index];
        return InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((context) => ProfileInfoCard(user: user)),
              );
            },
            child: _Card(user: user));
      },
    );
  }

  SwipeItem _item(User u) {
    return SwipeItem(
      content: u,
      likeAction: () {
        RepositoryImpl().like(u.id!);
      },
      nopeAction: () {
        RepositoryImpl().dislike(u.id!);
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
                  'https://friends.alisher.cc/get_image/${user.images.last}',
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

class ProfileInfoCard extends StatelessWidget {
  final User user;

  const ProfileInfoCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // if (user.images.isNotEmpty)
        //   Image(
        //     fit: BoxFit.fitHeight,
        //     image: NetworkImage(
        //       user.images.last,
        //       headers: {
        //         'accept': 'application/json',
        //         'X-Token': RepositoryImpl.token,
        //       },
        //     ),
        //   )
        // else
        const Image(
          fit: BoxFit.fitHeight,
          image: AssetImage('assets/ranger_1.jpeg'),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.transparent, Colors.black54, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
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
        // if (user.images.isNotEmpty)
        //   Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Container(
        //       color: Colors.white,
        //       height: 100,
        //       child: ListView(
        //         scrollDirection: Axis.horizontal,
        //         children: [
        //           for (int i = 0; i < 10; i++)
        //             Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
        //               child: Image(
        //                 image: NetworkImage(
        //                   user.images.length > i ? user.images[i] : user.images.last,
        //                   headers: {
        //                     'accept': 'application/json',
        //                     'X-Token': RepositoryImpl.token,
        //                   },
        //                 ),
        //               ),
        //             ),
        //         ],
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}

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
    return Container(
      color: const Color(0xFF0B2238),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(
                  child: Text(
                  'Feed is empty',
                  style: TextStyle(color: Colors.white),
                ))
              : SwipeCards(
                  matchEngine: _matchEngine,
                  onStackFinished: () {
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
                ),
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

  TextStyle get style => const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontFamily: 'Ubuntu',
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
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
                  '${user.name}${user.distance != null ? ', ${user.distance.toString()} km' : ''}',
                  style: style.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (user.description.isNotEmpty)
                  Text(
                    '${user.description} ',
                    style: style.copyWith(
                      fontSize: 20,
                    ),
                  ),
                const SizedBox(height: 16),
                if (user.tags.isNotEmpty)
                  SizedBox(
                    height: 30,
                    width: width - 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: user.tags
                          .map(
                            (t) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                label: Text('#$t', style: style.copyWith(color: Colors.black)),
                                showCheckmark: false,
                                selected: true,
                                onSelected: (isSelected) {},
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 50)
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

  TextStyle get style => const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontFamily: 'Ubuntu',
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (user.images.isNotEmpty)
          Image(
            fit: BoxFit.fitHeight,
            image: NetworkImage(
              'https://friends.alisher.cc/get_image/${user.images.last}',
              headers: {
                'accept': 'application/json',
                'X-Token': RepositoryImpl.token,
              },
            ),
          )
        else
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
                  '${user.name}${user.distance != null ? ', ${user.distance.toString()} km' : ''}',
                  style: style.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${2023 - user.yearOfBirth} years old',
                  style: style.copyWith(
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                if (user.description.isNotEmpty)
                  Text(
                    '${user.description} ',
                    style: style.copyWith(
                      fontSize: 20,
                    ),
                  ),
                const SizedBox(height: 16),
                if (user.tags.isNotEmpty)
                  SizedBox(
                    height: 30,
                    width: width - 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: user.tags
                          .map(
                            (t) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                label: Text('#$t', style: style.copyWith(color: Colors.black)),
                                showCheckmark: false,
                                selected: true,
                                onSelected: (isSelected) {},
                              ),
                            ),
                          )
                          .toList(),
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
              color: const Color(0xFF0B2238),
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i in user.images)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                      child: Image(
                        image: NetworkImage(
                          'https://friends.alisher.cc/get_image/$i',
                          headers: {
                            'accept': 'application/json',
                            'X-Token': RepositoryImpl.token,
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

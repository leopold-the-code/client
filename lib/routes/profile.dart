import 'package:client/app.dart';
import 'package:client/app_state.dart';
import 'package:client/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextStyle get style => const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontFamily: 'Ubuntu',
      );

  @override
  void initState() {
    super.initState();
    RepositoryImpl().me().then((value) {
      if (mounted) {
        setState(() {
          AppScope.of(context)?.me = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final me = AppScope.of(context)?.me;
    if (me == null) {
      return const CircularProgressIndicator();
    }

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0B2238),
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     // Color(0xFF000000),
        //     Color(0xFF0B2238),
        //     // Color(0xFF010304),
        //     Color(0xFF14324F),
        //     // Color(0xFF031425),
        //   ],
        // ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: me.images.isNotEmpty
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: NetworkImage(
                                'https://friends.alisher.cc/get_image/${me.images.last}',
                                headers: {
                                  'accept': 'application/json',
                                  'X-Token': RepositoryImpl.token,
                                },
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          me.name,
                          style: style.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        // const SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.updateProfile.name);
                          },
                          child: const Icon(
                            Icons.settings,
                            size: 18,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Table(
                      children: [
                        TableRow(
                          children: [
                            Text(
                              'Email:',
                              style: style.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              me.email,
                              style: style,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Description:',
                              style: style.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              me.description,
                              style: style,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Year of birth:',
                              style: style.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              me.yearOfBirth.toString(),
                              style: style,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My images',
                style: style.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.uploadImage.name);
                },
                child: SvgPicture.asset('assets/add.svg'),
              )
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            // color: const Color(0xFF010304),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: me.images
                  .map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _Wrapper(
                        child: Image.network(
                          fit: BoxFit.cover,
                          'https://friends.alisher.cc/get_image/$t',
                          headers: {
                            'accept': 'application/json',
                            'X-Token': RepositoryImpl.token,
                          },
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My tags',
                style: style.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.tags.name);
                },
                child: SvgPicture.asset('assets/add.svg'),
              )
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: me.tags
                  .map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text('#$t', style: style.copyWith(color: Colors.black)),
                        showCheckmark: false,
                        selected: true,
                        selectedColor: Colors.white,
                        onSelected: (isSelected) {},
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.matches.name);
                  },
                  child: Text(
                    'Matches',
                    style: style.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    AppScope.of(context)?.token = '';
                    Navigator.of(context).pushNamed(Routes.init.name);
                  },
                  child: Text(
                    'Sign out',
                    style: style.copyWith(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    RepositoryImpl().resetFeed();
                  },
                  child: Text(
                    'Reset feed',
                    style: style.copyWith(
                      color: Colors.yellow,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
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

class _Wrapper extends StatelessWidget {
  const _Wrapper({
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: Colors.blueAccent),
      ),
      child: child,
    );
  }
}

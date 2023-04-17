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
  TextStyle get style => const TextStyle(fontSize: 16);

  @override
  void initState() {
    super.initState();
    RepositoryImpl()
        .me()
        .then((value) => AppScope.of(context)?.me = value)
        .then((value) => mounted ? setState(() {}) : null);
  }

  @override
  Widget build(BuildContext context) {
    final me = AppScope.of(context)!.me!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: Image.asset('assets/ranger_1.jpeg').image,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.uploadImage.name);
                      },
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 18,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 24),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          me.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 16),
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
                    const SizedBox(height: 8),
                    Text(
                      'Email: ${me.email}',
                      style: style,
                    ),
                    Text(
                      'Description: ${me.description}',
                      style: style,
                    ),
                    Text(
                      'Year of birth: ${me.yearOfBirth}',
                      style: style,
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
              const Text(
                'My tags',
                style: TextStyle(
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
                        label: Text('#$t', style: const TextStyle(color: Colors.white)),
                        showCheckmark: false,
                        selected: true,
                        selectedColor: const Color(0xFF1976D2),
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
                  child: const Text('Matches',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    AppScope.of(context)?.token = '';
                    Navigator.of(context).pushNamed(Routes.init.name);
                  },
                  child: const Text('Sign out',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

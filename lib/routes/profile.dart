import 'package:client/app.dart';
import 'package:client/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: RepositoryImpl().getImage(1),
            builder: ((context, snapshot) {
              final img = snapshot.data;
              if (img == null) {
                return SizedBox();
              }
              return SizedBox(width: 300, child: Image.memory(img));
            }),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.uploadImage.name);
            },
            child: Text('Uplaod image'),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.tags.name);
            },
            child: Text('Add tag'),
          ),
        ],
      ),
    );
  }
}

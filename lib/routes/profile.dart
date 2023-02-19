import 'package:client/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: FutureBuilder(
        future: RepositoryImpl().getImage(1),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          }
          return Image.memory(
            snapshot.data!,
            width: 200,
            height: 200,
          );
        },
      ),
    ));
  }
}

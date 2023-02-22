import 'package:client/routes/feed.dart';
import 'package:client/routes/upload_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes/auth.dart';

enum Routes {
  init,
  registration,
  login,
  feed,
  profile,
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        home: UploadPhoto(),
      ),
    );
  }
}

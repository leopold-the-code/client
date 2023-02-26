import 'package:client/app.dart';
import 'package:client/data/repository.dart';
import 'package:client/data/user.dart';
import 'package:client/routes/app_state.dart';
import 'package:client/routes/feed.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtlr = TextEditingController();
  final TextEditingController pswdCtlr = TextEditingController();

  @override
  void dispose() {
    emailCtlr.dispose();
    pswdCtlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration')),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 400,
          child: Column(
            children: [
              Text('Login'),
              TextField(
                controller: emailCtlr,
                decoration: InputDecoration(hintText: 'email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: pswdCtlr,
                decoration: InputDecoration(hintText: 'password'),
                obscureText: true,
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final token = await RepositoryImpl().register(
                      User.test(),
                      pswdCtlr.text,
                    );

                    if (token.isNotEmpty) {
                      print('registered. token: $token');
                      AppScope.of(context)?.token = token;
                      Navigator.of(context).pushNamed(Routes.feed.name);
                    }
                  },
                  child: Text('next')),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:client/app.dart';
import 'package:client/data/repository.dart';
import 'package:client/data/user.dart';
import 'package:client/app_state.dart';
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
      appBar: AppBar(title: Text('Login')),
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
                    if (emailCtlr.text.isEmpty || pswdCtlr.text.isEmpty) {
                      return;
                    }

                    final token = await RepositoryImpl().login(
                      emailCtlr.text,
                      pswdCtlr.text,
                    );

                    if (token.isNotEmpty) {
                      print('registered. token: $token');
                      AppScope.of(context)?.token = token;
                      RepositoryImpl.token = token;

                      final me = await RepositoryImpl().me();
                      AppScope.of(context)?.me = me;
                      Navigator.of(context).pushNamed(Routes.home.name);
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

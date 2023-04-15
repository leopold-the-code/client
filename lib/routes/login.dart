import 'package:client/app.dart';
import 'package:client/app_state.dart';
import 'package:client/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtlr = TextEditingController();
  final TextEditingController pswdCtlr = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    emailCtlr.dispose();
    pswdCtlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          child: SvgPicture.asset(
            'assets/back_btn.svg',
            fit: BoxFit.scaleDown,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailCtlr,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pswdCtlr,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    )),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 32),
              InkWell(
                onTap: _login,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1976D2)),
                  ),
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text('Not Registered Yet?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.register.name);
                    },
                    child: const Text('Create an account'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _login() async {
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
  }
}

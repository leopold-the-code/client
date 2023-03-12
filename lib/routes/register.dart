import 'package:client/app_state.dart';
import 'package:client/data/repository.dart';
import 'package:client/data/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationScreen extends StatefulWidget {
  final bool isUpdateProfile;
  const RegistrationScreen({
    super.key,
    this.isUpdateProfile = false,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailCtlr = TextEditingController();
  final TextEditingController pswdCtlr = TextEditingController();
  final TextEditingController nameCtlr = TextEditingController();
  final TextEditingController yearCtlr = TextEditingController();
  final TextEditingController descCtlr = TextEditingController();
  String _errorText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isUpdateProfile ? 'Update profile' : 'Registration')),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 400,
          child: Column(
            children: [
              // Text('Registration'),
              TextField(
                controller: emailCtlr,
                decoration: const InputDecoration(hintText: 'email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: pswdCtlr,
                decoration: const InputDecoration(hintText: 'password'),
                obscureText: true,
              ),
              TextField(
                controller: nameCtlr,
                decoration: const InputDecoration(hintText: 'name'),
              ),
              TextField(
                controller: yearCtlr,
                decoration: const InputDecoration(hintText: 'year of birth'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextField(
                controller: descCtlr,
                decoration: const InputDecoration(hintText: 'description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      if (widget.isUpdateProfile) {
                        final upd = await RepositoryImpl().updateProfile(
                          User(
                            email: emailCtlr.text,
                            password: pswdCtlr.text.isNotEmpty ? pswdCtlr.text : null,
                            name: nameCtlr.text,
                            yearOfBirth: int.parse(yearCtlr.text),
                            description: descCtlr.text,
                          ),
                        );
                      } else {
                        final token = await RepositoryImpl().register(
                          User(
                              email: emailCtlr.text,
                              name: nameCtlr.text,
                              yearOfBirth: 2001,
                              description: descCtlr.text,
                              password: pswdCtlr.text),
                        );
                        debugPrint(token);
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      setState(() {
                        _errorText = e.toString();
                      });
                    }
                  },
                  child: const Text('Submit')),
              Text(_errorText),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailCtlr.dispose();
    pswdCtlr.dispose();
    yearCtlr.dispose();
    nameCtlr.dispose();
    descCtlr.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdateProfile) {
      final me = AppScope.of(context)!.me!;
      emailCtlr.text = me.email;
      nameCtlr.text = me.name;
      yearCtlr.text = me.yearOfBirth.toString();
      descCtlr.text = me.description;
    }
  }
}

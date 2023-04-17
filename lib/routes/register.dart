import 'package:client/app_state.dart';
import 'package:client/data/repository.dart';
import 'package:client/data/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app.dart';

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
  final TextEditingController yearCtrl = TextEditingController();
  final TextEditingController emailCtlr = TextEditingController();
  final TextEditingController pswdCtlr = TextEditingController();
  final TextEditingController nameCtlr = TextEditingController();
  final TextEditingController descCtlr = TextEditingController();
  bool _passwordVisible = false;
  int? _selectedYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to our community!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Fill the forms with about your information',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
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
                TextField(
                  controller: nameCtlr,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  readOnly: true,
                  controller: yearCtrl,
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    hintText: 'Year of birth',
                    hintStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descCtlr,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                InkWell(
                  onTap: _register,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1976D2)),
                    ),
                    child: const Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text('You have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.login.name);
                      },
                      child: const Text('Log in'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _register() async {
    try {
      if (widget.isUpdateProfile) {
        final upd = await RepositoryImpl().updateProfile(
          User(
            email: emailCtlr.text,
            password: pswdCtlr.text.isNotEmpty ? pswdCtlr.text : null,
            name: nameCtlr.text,
            yearOfBirth: _selectedYear ?? 2001,
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
      print(e);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select the Year of birth"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 50),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
              selectedDate: DateTime(_selectedYear ?? 2023),
              onChanged: (DateTime dateTime) {
                _selectedYear = dateTime.year;
                yearCtrl.text = _selectedYear.toString();
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailCtlr.dispose();
    pswdCtlr.dispose();
    nameCtlr.dispose();
    descCtlr.dispose();
    yearCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdateProfile) {
      final me = AppScope.of(context)!.me!;
      emailCtlr.text = me.email;
      nameCtlr.text = me.name;
      yearCtrl.text = me.yearOfBirth.toString();
      descCtlr.text = me.description;
    }
  }
}

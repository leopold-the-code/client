import 'package:client/data/repository.dart';
import 'package:client/data/user.dart';
import 'package:client/routes/upload_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailCtlr = TextEditingController();
  final TextEditingController pswdCtlr = TextEditingController();
  final TextEditingController nameCtlr = TextEditingController();
  final TextEditingController yearCtlr = TextEditingController();
  final TextEditingController descCtlr = TextEditingController();

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
              Text('Registration'),
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
              TextField(
                controller: nameCtlr,
                decoration: InputDecoration(hintText: 'name'),
              ),
              // CalendarDatePicker(
              //   initialDate: DateTime(2001),
              //   firstDate: DateTime(1995),
              //   lastDate: DateTime(2010),
              //   onDateChanged: (_) {},
              //   initialCalendarMode: DatePickerMode.year,
              // ),
              TextField(
                controller: yearCtlr,
                decoration: InputDecoration(hintText: 'year of birth'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextField(
                controller: descCtlr,
                decoration: InputDecoration(hintText: 'description'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    final token = await RepositoryImpl().register(
                      User.test(),
                      // User(
                      //   // email: emailCtlr.text,
                      //   // name: nameCtlr.text,
                      //   // yearOfBirth: 2001,
                      //   // description: descCtlr.text,
                      // ),
                      pswdCtlr.text,
                    );

                    if (token.isNotEmpty) {
                      print('registered. token: $token');
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => UploadPhoto()));
                    }
                  },
                  child: Text('next')),
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
}

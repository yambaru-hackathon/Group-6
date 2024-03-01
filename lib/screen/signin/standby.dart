import 'package:flutter/material.dart';
import 'sign_in.dart';
import '../signup/sign_up.dart';
import '../signup/enter_personal_data.dart';

class StandBy extends StatefulWidget {
  const StandBy({super.key});

  @override
  State<StandBy> createState() => _StandByState();
}

class _StandByState extends State<StandBy> {
  // int _counter = 0;

  void _incrementCounter() {
    // setState(() {
    //   _counter++;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is standby screen. You can choose Sign in or Sign up.',
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignIn()));
                },
                child: const Text('to sign in')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignUp()));
                },
                child: const Text('to sign up')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnterPersonalData()));
                },
                child: const Text('マイナンバーページ開発用')),
          ],
        ),
      ),
    );
  }
}

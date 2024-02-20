import 'package:flutter/material.dart';
import '../App.dart';

class EnterPersonalData extends StatefulWidget {
  const EnterPersonalData({super.key});

  @override
  State<EnterPersonalData> createState() => _EnterPersonalDataState();
}

class _EnterPersonalDataState extends State<EnterPersonalData> {
  // int _counter = 0;

  void _incrementCounter() {
    // setState(() {
    //   _counter++;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is enter personal data screen.',
            ),
            ElevatedButton(
              onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppScreen())
              );},
              child: const Text('to Home Screen')),
          ],
        ),
      ),
    );
  }
}
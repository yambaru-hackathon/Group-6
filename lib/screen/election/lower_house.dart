import 'package:flutter/material.dart';

class LowerHouse extends StatefulWidget {
  const LowerHouse({super.key});

  @override
  State<LowerHouse> createState() => _LowerHouseState();
}

class _LowerHouseState extends State<LowerHouse> {
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
              'This is lower house election screen.',
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const EnterPersonalData())
                // );
              },
              child: const Text('to election list')),
          ],
        ),
      ),
    );
  }
}
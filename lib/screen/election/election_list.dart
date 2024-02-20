import 'package:flutter/material.dart';
import 'lower_house.dart';

class ElectionList extends StatefulWidget {
  const ElectionList({super.key});

  @override
  State<ElectionList> createState() => _ElectionListState();
}

class _ElectionListState extends State<ElectionList> {
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
              'This is election list screen.',
            ),
            ElevatedButton(
              onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LowerHouse())
              );},
              child: const Text('to lower house election screen')),
          ],
        ),
      ),
    );
  }
}
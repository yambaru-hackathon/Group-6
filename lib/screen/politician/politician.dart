import 'package:flutter/material.dart';
import '../article/article.dart';

class Politician extends StatefulWidget {
  const Politician({super.key});

  @override
  State<Politician> createState() => _PoliticianState();
}

class _PoliticianState extends State<Politician> {
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
              'This is politician screen.',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Article())
                );
              },
              child: const Text('to article screen')
            )
          ],
        ),
      ),
    );
  }
}
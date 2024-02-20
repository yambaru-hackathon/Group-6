import 'package:flutter/material.dart';

class PopularVote extends StatefulWidget {
  const PopularVote({super.key});

  @override
  State<PopularVote> createState() => _PopularVoteState();
}

class _PopularVoteState extends State<PopularVote> {
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is popular vote screen.',
            ),
          ],
        ),
      ),
    );
  }
}
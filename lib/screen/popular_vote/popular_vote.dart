import 'package:flutter/material.dart';

class PopularVote extends StatefulWidget {
  const PopularVote({super.key});

  @override
  State<PopularVote> createState() => _PopularVoteState();
}

class _PopularVoteState extends State<PopularVote> {
  bool isRunning = false; //ボタンの時に変化する用
  int popularVotePoint = 100; //使える残りのポイント数
  int popularVoteCurrentPoint = 0; //今から投票するポイント
  //int _counter = 0;

  //void _incrementCounter() {
  //  setState(() {
  //    _counter++;
  //  });
  //}

  void toggleSwitch() {
    setState(() {
      isRunning = !isRunning;
    });
  }

  void changePoint(value) {
    setState(() {
      value ? popularVotePoint-- : popularVotePoint++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is popular vote screen.',
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () {
                      changePoint(true);
                    },
                    child: const Icon(Icons.remove),
                  ),
                  Text('$popularVotePoint'),
                  FloatingActionButton(
                    onPressed: () {
                      changePoint(false);
                    },
                    child: const Icon(Icons.add),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}

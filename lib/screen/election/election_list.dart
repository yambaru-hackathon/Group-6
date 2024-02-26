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
      appBar: AppBar(),
      body: Center(
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListWheelScrollView(itemExtent: 30, children: [
              for (var i in List.generate(10, (i) => i))
                Container(
                    width: 200,
                    color: Colors.cyanAccent,
                    child: Center(child: Text((i + 1).toString() + " 番目")))
            ]),

//            const Text(
//              'This is election list screen.',
//            ),
//            ElevatedButton(
//                onPressed: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => const LowerHouse()));
//                },
//                child: const Text('to lower house election screen')),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../components/app_bar.dart';
import 'lower_house.dart';

class ElectionList extends StatefulWidget {
  const ElectionList({super.key});

  @override
  State<ElectionList> createState() => _ElectionListState();
}

class _ElectionListState extends State<ElectionList> {
  final _controller = FixedExtentScrollController(initialItem: 0);
  double _height = 200;

//  int _counter = 0;

  void _incrementCounter() {
    // setState(() {
    //   _counter++;
    // });
  }
  void _scroll(position) {
    _controller.animateToItem(position,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  int _selectedItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('選挙を選ぶ'),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 400,
              child: ListWheelScrollView(
                controller: _controller,
                diameterRatio: 20, //リストの間の幅
                itemExtent: _height, //リストの幅
//                overAndUnderCenterOpacity: 0.5, //透明度
                perspective: 0.0001, //まるみ
                useMagnifier: false, //拡大するか否か
                magnification: 1, //拡大のどあい
                physics: FixedExtentScrollPhysics(),
                onSelectedItemChanged: (int index) {
                  // update the UI on selected item changes
                  setState(() {
                    _selectedItemIndex = index;
                  });
                },
                children: [
                  for (var i in List.generate(10, (i) => i))
                    Container(
                      child: Card(
                        shadowColor: Colors.black,
                        elevation: _selectedItemIndex == i ? 30 : 0,
                        margin: _selectedItemIndex == i
                            ? const EdgeInsets.only(
                                right: 60,
                                left: 60,
                              )
                            : const EdgeInsets.only(
                                top: 30,
                                bottom: 30,
                                right: 90,
                                left: 90,
                              ),
                        color: _selectedItemIndex != i
                            ? Colors.white
                            : Color.fromARGB(255, 99, 112, 255),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: const Color.fromARGB(255, 50, 61, 180), //色
                            width: 2, //太さ
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: _selectedItemIndex < i
                                ? Radius.zero
                                : Radius.circular(10),
                            topRight: _selectedItemIndex < i
                                ? Radius.zero
                                : Radius.circular(10),
                            bottomLeft: _selectedItemIndex > i
                                ? Radius.zero
                                : Radius.circular(10),
                            bottomRight: _selectedItemIndex > i
                                ? Radius.zero
                                : Radius.circular(10),
                          ),
                        ),
                        child: InkWell(
                          splashColor: const Color.fromARGB(255, 148, 207, 255)
                              .withAlpha(30),
                          onTap: () {
                            setState(() {
                              _selectedItemIndex = i;
                              _scroll(i);
                            });
                            debugPrint('Card taped');
                          },
                          child: Center(
                            child: Text(
                              (i + 1).toString() + " 番目",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              'This is election list screen.',
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LowerHouse()));
                },
                child: const Text('to lower house election screen')),
          ],
        ),
      ),
    );
  }
}

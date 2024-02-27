import 'dart:ffi';
import 'package:flutter/material.dart';
import '../../components/app_bar.dart';
import 'lower_house.dart';

class ElectionList extends StatefulWidget {
  const ElectionList({super.key});

  @override
  State<ElectionList> createState() => _ElectionListState();
}

class ListGenerator {
  static Map<String, dynamic> generateList(int i) {
    Map<String, dynamic> map = {};

    i == 1
        ? map['page'] = 'LowerHouse'
        : i == 2
            ? map['page'] = 'UpperHouse'
            : map['page'] = 'AnotherHouse';

    i == 1
        ? map['id'] = '衆議院選挙'
        : i == 2
            ? map['id'] = '参議院選挙'
            : map['id'] = 'その他の選挙$i';
    map['year'] = '$i';
    map['date'] = '$i';
    return map;
  }
}

class TwoDimensionalListGenerator {
  List<Map<String, dynamic>> generateTwoDimensionalList(int rows) {
    List<Map<String, dynamic>> twoDList = [];
    for (int j = 0; j < rows; j++) {
      Map<String, dynamic> sampleList = {'order': j};
      sampleList.addAll(ListGenerator.generateList(j));
      twoDList.add(sampleList);
    }
    return twoDList;
  }
}

class _ElectionListState extends State<ElectionList> {
  final _controller = FixedExtentScrollController(initialItem: 0);
  String page = 'test';

  final List<Map<String, dynamic>> _electionList =
      TwoDimensionalListGenerator().generateTwoDimensionalList(6);

  //そこに飛ぶ
  void _scroll(position) {
    _controller.animateToItem(position,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  int _selectedItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, '選挙を選ぶ'),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 400,
              child: ListWheelScrollView(
                controller: _controller,
                diameterRatio: 50, //リストの間の幅
                itemExtent: 150, //リストの幅
//                overAndUnderCenterOpacity: 0.5, //透明度
                perspective: 0.0001, //まるみ
                useMagnifier: false, //拡大するか否か
                magnification: 1, //拡大のどあい
                physics: FixedExtentScrollPhysics(),
                onSelectedItemChanged: (int index) {
                  // update the UI on selected item changes
                  setState(() {
                    _selectedItemIndex = index;
                    page = _electionList[index]['page'];
                  });
                },
                children: [
                  for (var map in _electionList)
                    Container(
                      width: 500,
                      height: 300,
                      child: Card(
                        shadowColor: Colors.black,
                        elevation: _selectedItemIndex == map['order'] ? 30 : 0,
                        margin: _selectedItemIndex == map['order']
                            ? const EdgeInsets.only(
                                right: 60,
                                left: 60,
                              )
                            : _selectedItemIndex < map['order']
                                ? const EdgeInsets.only(
                                    top: 10,
                                    bottom: 30,
                                    right: 90,
                                    left: 90,
                                  )
                                : const EdgeInsets.only(
                                    top: 30,
                                    bottom: 10,
                                    right: 90,
                                    left: 90,
                                  ),
                        color: _selectedItemIndex == map['order']
                            ? Color.fromARGB(255, 99, 112, 255)
                            : _selectedItemIndex + 1 == map['order'] ||
                                    _selectedItemIndex - 1 == map['order']
                                ? Colors.white
                                : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: _selectedItemIndex + 1 == map['order'] ||
                                    _selectedItemIndex - 1 == map['order']
                                ? const Color.fromARGB(255, 50, 61, 180)
                                : Colors.transparent, //色
                            width: 2, //太さ
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                            // BorderRadius.only(
//                            topLeft: _selectedItemIndex < map['order']
//                                ? Radius.zero
//                                : Radius.circular(10),
//                            topRight: _selectedItemIndex < map['order']
//                                ? Radius.zero
//                                : Radius.circular(10),
//                            bottomLeft: _selectedItemIndex > map['order']
//                                ? Radius.zero
//                                : Radius.circular(10),
//                            bottomRight: _selectedItemIndex > map['order']
//                                ? Radius.zero
//                                : Radius.circular(10),
                          ),
                        ),
                        child: InkWell(
                          splashColor: const Color.fromARGB(255, 148, 207, 255)
                              .withAlpha(30),
                          onTap: () {
                            setState(() {
                              _selectedItemIndex = map['order'];
                              _scroll(map['order']);
                              page = map['page'];
                            });
                            debugPrint('Card taped');
                          },
                          child: Center(
                            child: Text(
                              _selectedItemIndex == map['order']
                                  ? (map['id']) +
                                      '\n' +
                                      (map['year']).toString() +
                                      '/' +
                                      (map['date']).toString()
                                  : (map['id']),
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
                  MaterialPageRoute(builder: (context) => const LowerHouse()),
                );
              },
              child: const Text('to lower house election screen'),
            ),
            ElevatedButton(
              onPressed: () {
                if (page == 'LowerHouse') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LowerHouse()),
                  );
                } else if (page == 'UpperHouse') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpperHouse()),
                  );
                } else if (page == 'AnotherHouse') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnotherHouse()),
                  );
                }
              },
              child: const Text('投票画面へGO!'),
            ),
          ],
        ),
      ),
    );
  }
}

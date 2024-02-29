//import 'dart:ffi';
import 'package:flutter/material.dart';
import '../../components/app_bar.dart';
import 'voter_selection.dart';

class PopularVote extends StatefulWidget {
  const PopularVote({super.key});

  @override
  State<PopularVote> createState() => _ElectionListState();
}

class ListGenerator {
  static Map<String, dynamic> generateList(int i) {
    Map<String, dynamic> map = {};

    i == 0
        ? map['page'] = 'LooksLikeCatOwner'
        : i == 1
            ? map['page'] = 'LooksLikeSleepFast'
            : map['page'] = 'WantSomeoneBecomeParent';

    i == 0
        ? map['id'] = '猫を飼ってそうな人'
        : i == 1
            ? map['id'] = '眠りに入るのがはやそうな人'
            : map['id'] = '親にしたい人';
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

class _ElectionListState extends State<PopularVote> {
  final _controller = FixedExtentScrollController(initialItem: 0);
  String page = 'test';
  String id = '人気投票';

  final List<Map<String, dynamic>> _electionList =
      TwoDimensionalListGenerator().generateTwoDimensionalList(3);

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
        child: ClipRect(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      id = _electionList[index]['id'];
                    });
                  },
                  children: [
                    for (var map in _electionList)
                      Container(
                        width: _selectedItemIndex == map['order'] ? 300 : 200,
                        height: 300,
                        child: Card(
                          shadowColor: Colors.black,
                          elevation:
                              _selectedItemIndex == map['order'] ? 30 : 0,
                          margin: _selectedItemIndex < map['order']
                              ? const EdgeInsets.only(
                                  top: 10,
                                  bottom: 30,
                                )
                              : _selectedItemIndex > map['order']
                                  ? EdgeInsets.only(
                                      top: 30,
                                      bottom: 10,
                                    )
                                  : EdgeInsets.all(0),
                          color: _selectedItemIndex == map['order']
                              ? Color.fromARGB(255, 165, 233, 211)
                              : _selectedItemIndex + 1 == map['order'] ||
                                      _selectedItemIndex - 1 == map['order']
                                  ? Colors.white
                                  : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: _selectedItemIndex + 1 == map['order'] ||
                                      _selectedItemIndex - 1 == map['order']
                                  ? Color.fromARGB(255, 137, 198, 179)
                                  : Colors.transparent, //色
                              width: 4, //太さ
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
                            splashColor:
                                const Color.fromARGB(255, 148, 207, 255)
                                    .withAlpha(30),
                            onTap: () {
                              setState(() {
                                _selectedItemIndex = map['order'];
                                _scroll(map['order']);
                                page = map['page'];
                                id = map['id'];
                              });
                              debugPrint('Card taped');
                            },
                            child: Center(
                              child: Text(
                                _selectedItemIndex == map['order']
                                    ? (map['id']) +
                                        '\nランキング\n' +
                                        (map['year']).toString() +
                                        '/' +
                                        (map['date']).toString()
                                    : (map['id']),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: 200,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                voterSelection(id: id, page: page)),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '人気投票',
                            style: TextStyle(
                                color: Color.fromARGB(255, 85, 142, 124),
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'へGO!',
                            style: TextStyle(
                              color: Color.fromARGB(255, 137, 198, 179),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

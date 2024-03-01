import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/app_bar.dart';
import 'lower_house.dart';

//local

import '../../provider/auth_state.dart';

class ElectionList extends ConsumerStatefulWidget {
  const ElectionList({super.key});

  @override
  ConsumerState<ElectionList> createState() => _ElectionListState();
}

class ListGenerator {
  static Map<String, dynamic> generateList(int i) {
    Map<String, dynamic> map = {};

    i == 0
        ? map['page'] = 'lower_house'
        : i == 1
            ? map['page'] = 'upper_house'
            : map['page'] = 'AnotherHouse';

    i == 0
        ? map['id'] = '衆議院選挙'
        : i == 1
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

class _ElectionListState extends ConsumerState<ElectionList> {
  final CollectionReference<Map<String, dynamic>> electionData =
      FirebaseFirestore.instance.collection('elections');
  var lowerHouseData;
  var upperHouseData;

  final users = FirebaseFirestore.instance.collection('users');

  final _controller = FixedExtentScrollController(initialItem: 0);
  String page = 'test';

  final List<Map<String, dynamic>> _electionList =
      TwoDimensionalListGenerator().generateTwoDimensionalList(2);

  //そこに飛ぶ
  void _scroll(position) {
    _controller.animateToItem(position,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _fetchData() async {
    // データベースから選挙情報を取得
    lowerHouseData = await electionData.doc('lowerHouse').get();
    upperHouseData = await electionData.doc('upperHouse').get();

    setState(() {
      _electionList[0]['id'] = lowerHouseData['name'];
      _electionList[1]['id'] = upperHouseData['name'];
      _electionList[0]['date'] = "${lowerHouseData['untilDate']} まで";
      _electionList[1]['date'] = "${upperHouseData['untilDate']} まで";
    });
  }

  void _fetchUserVote() async {
    // データベースからユーザーの投票履歴を取得
    lowerHouseData = await electionData.doc('lowerHouse').get();
    upperHouseData = await electionData.doc('upperHouse').get();

    final uid = ref.read(userIdProvider);
    final userData = await users.doc(uid).get();
    final String lowerHouseVote = userData['lowerHouseVote'];

    // 選挙が終了している場合、選挙リストから削除
    // 衆議院選挙
    setState(() {
      if (lowerHouseVote.isNotEmpty) {
        // debugPrint('vote history of user is fetched');
        _electionList
            .removeWhere((element) => element['id'] == lowerHouseData['name']);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchData();
    _fetchUserVote();
  }

  int _selectedItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    _fetchUserVote();
    return Scaffold(
      appBar: myAppBar(context, '選挙を選ぶ'),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromARGB(255, 255, 255, 255),
        child: ClipRect(
          child: Column(
          //          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Stack(children: [
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
                              elevation:
                                  _selectedItemIndex == map['order'] ? 30 : 0,
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
                                splashColor:
                                    const Color.fromARGB(255, 148, 207, 255)
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
                
                  // 選挙リストがない場合、選挙リストがないことを表示
                  _electionList.length == 0
                      ? SizedBox(
                          height: 400,
                          child: ListWheelScrollView(
                            controller: _controller,
                            diameterRatio: 50, //リストの間の幅
                            itemExtent: 150, //リストの幅
                            //                overAndUnderCenterOpacity:0.5, //透明度
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
                              Container(
                                width: 500,
                                height: 300,
                                child: Card(
                                  shadowColor: Colors.black,
                                  elevation: 30,
                                  margin: const EdgeInsets.only(
                                    right: 60,
                                    left: 60,
                                  ),
                                  color: Color.fromARGB(255, 99, 112, 255),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: const Color.fromARGB(255, 50, 61, 180),
                                      width: 2, //太さ
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: InkWell(
                                    splashColor:
                                        const Color.fromARGB(255, 148, 207, 255)
                                            .withAlpha(30),
                                    onTap: () {
                                      debugPrint('Card taped');
                                    },
                                    child: Center(
                                      child: Text(
                                        'Coming soon',
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
                        )
                      : SizedBox(), // 選挙リストがある場合何も表示しない
                ]),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 200,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () {
                      onPressedToVoting();
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '投票画面',
                            style: TextStyle(
                                color: Color.fromARGB(255, 112, 129, 245),
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'へGO!',
                            style: TextStyle(
                              color: Color.fromARGB(255, 112, 129, 245),
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

  Future<void> onPressedToVoting() async {
    final user = await users.doc(ref.read(userIdProvider)).get();
    final String myNumber = user['myNumber'];

    if (page == 'lower_house' && myNumber.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LowerHouse()),
      );
    } else {
      // マイナンバーが登録されていない場合、登録画面に遷移
    }
  }
}

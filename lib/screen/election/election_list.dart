import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/app_bar.dart';
import 'lower_house.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

//local
import '../signup/enter_personal_data.dart';
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
  String userMyNumber = '';

  final List<Map<String, dynamic>> _electionList =
      TwoDimensionalListGenerator().generateTwoDimensionalList(2);

  //そこに飛ぶ
  void _scroll(position) {
    _controller.animateToItem(position,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Future<void> _fetchData() async {
    EasyLoading.show(status: 'loading...');
    // データベースから選挙情報を取得
    lowerHouseData = await electionData.doc('lowerHouse').get();
    upperHouseData = await electionData.doc('upperHouse').get();

    final uid = ref.read(userIdProvider);
    final userData = await users.doc(uid).get();
    final String lowerHouseVote = userData['lowerHouseVote'];
    userMyNumber = userData['myNumber'];

    setState(() {
      _electionList[0]['id'] = lowerHouseData['name'];
      _electionList[1]['id'] = upperHouseData['name'];
      _electionList[0]['date'] = "${lowerHouseData['untilDate']} まで";
      _electionList[1]['date'] = "${upperHouseData['untilDate']} まで";

      if (lowerHouseVote.isNotEmpty) {
        // debugPrint('vote history of user is fetched');
        _electionList
            .removeWhere((element) => element['id'] == lowerHouseData['name']);
      }
    });
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    _fetchData();
    // TODO: implement initState
    super.initState();
  }

  int _selectedItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, '選挙を選ぶ'),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: ClipRect(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Stack(children: [
                SizedBox(
                  height: 300,
                  child: ListWheelScrollView(
                    controller: _controller,
                    diameterRatio: 50, //リストの間の幅
                    itemExtent: 150, //リストの幅
                    //                overAndUnderCenterOpacity: 0.5, //透明度
                    perspective: 0.0001, //まるみ
                    useMagnifier: false, //拡大するか否か
                    magnification: 1, //拡大のどあい
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (int index) {
                      // update the UI on selected item changes
                      setState(() {
                        _selectedItemIndex = index;
                        page = _electionList[index]['page'];
                      });
                    },
                    children: [
                      for (var map in _electionList)
                        SizedBox(
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
                                    ? const EdgeInsets.only(
                                        top: 30,
                                        bottom: 10,
                                      )
                                    : const EdgeInsets.all(0),
                            color: _selectedItemIndex == map['order']
                                ? const Color.fromARGB(255, 133, 149, 255)
                                : _selectedItemIndex + 1 == map['order'] ||
                                        _selectedItemIndex - 1 == map['order']
                                    ? Colors.white
                                    : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: _selectedItemIndex + 1 == map['order'] ||
                                        _selectedItemIndex - 1 == map['order']
                                    ? const Color.fromARGB(255, 112, 129, 245)
                                    : Colors.transparent, //色
                                width: 4, //太さ
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
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
                                  style: const TextStyle(
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
                _electionList.isEmpty
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
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (int index) {
                            // update the UI on selected item changes
                            setState(() {
                              _selectedItemIndex = index;
                            });
                          },
                          children: [
                            SizedBox(
                              width: 500,
                              height: 300,
                              child: Card(
                                shadowColor: Colors.black,
                                elevation: 30,
                                margin: const EdgeInsets.only(
                                  right: 60,
                                  left: 60,
                                ),
                                color: const Color.fromARGB(255, 112, 129, 245),
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 112, 129, 245),
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
                                  child: const Center(
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
                    : const SizedBox(), // 選挙リストがある場合何も表示しない
              ]),
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
              if (userMyNumber.isEmpty)
                Column(
                  children: [
                    const Text(
                      'マイナンバーが登録されていないので投票できません',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EnterPersonalData(
                                    isInitText: true,
                                    isFromAppScreen: true,
                                  )),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'マイナンバーを登録する',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onPressedToVoting() async {
    EasyLoading.show(status: 'loading...');
    final user = await users.doc(ref.read(userIdProvider)).get();
    final String myNumber = user['myNumber'];

    debugPrint(page + myNumber + user['prefecture']);
    if (page == 'lower_house' &&
        myNumber.isNotEmpty &&
        user['prefecture'] != 'エラー') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LowerHouse()),
      );
    } else {
      // マイナンバーが登録されていない場合、登録画面に遷移
    }
    EasyLoading.dismiss();
  }
}

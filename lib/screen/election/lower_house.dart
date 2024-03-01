import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// local
import '../../provider/auth_state.dart';
import '../../components/app_bar.dart';

//firestoreCollections
final politicians = FirebaseFirestore.instance.collection('politician');
final users = FirebaseFirestore.instance.collection('users');

class LowerHouse extends ConsumerStatefulWidget {
  const LowerHouse({super.key});

  @override
  ConsumerState<LowerHouse> createState() => _LowerHouseState();
}

class Completed extends StatelessWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: const Text(
            '投票ありがとうございました',
          ),
        ),
      ),
    );
  }
}

class ConfirmVotingPage extends ConsumerStatefulWidget {
  String politicianName;

  ConfirmVotingPage(this.politicianName, {super.key});

  @override
  ConsumerState<ConfirmVotingPage> createState() => ConfirmVotingPageState();
}

class ConfirmVotingPageState extends ConsumerState<ConfirmVotingPage> {
  Future<void> onPressVotingButton(BuildContext context) async {
    // 投票処理
    // 選択した政治家のidを取得
    final selectedPoliticianSnapshot = await politicians
        .where('name', isEqualTo: widget.politicianName)
        .get();
    final selectedPoliticianId = selectedPoliticianSnapshot.docs[0].id;

    // ユーザーの選択した政治家のidを更新
    final uid = ref.read(userIdProvider);
    debugPrint(selectedPoliticianId);
    await users.doc(uid).update({
      'lowerHouseVote': selectedPoliticianId,
    });

    // 投票数を更新
    await updateVotes(selectedPoliticianSnapshot);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const Completed(),
    ));
  }
  
  // 得票数の更新の通信を行う
  Future<void> updateVotes(QuerySnapshot<Map<String, dynamic>> politicianSnapshot) async {
    await politicians.doc(politicianSnapshot.docs[0].id).update({
      'votes': ++politicianSnapshot.docs[0].data()['votes'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投票します'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(255, 137, 198, 179),
                    width: 3,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 36.0,
                  backgroundImage:
                      AssetImage('assets/images/politician_img.png'),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.politicianName,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Container(
                    width: 150,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 137, 198, 179),
                          width: 5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'よろしいですか？',
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text(
                    '変更、再投票はできません',
                    style: TextStyle(
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20), // テキストとボタンの間隔
          ElevatedButton(
            onPressed: () {
              onPressVotingButton(context);
            },
            child: const Text('投票する'),
          ),
        ],
      ),
    );
  }
}

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget({super.key});

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

class _LowerHouseState extends ConsumerState<LowerHouse> {
  String userPrefecture = '';
  String userSenkyokuNum = '';

  var politiciansList = [];

  Future<void> _getUserData() async {
    final snapshot = await users.doc(ref.read(userIdProvider)).get();
    userPrefecture = snapshot['prefecture'];
    userSenkyokuNum = snapshot['senkyokuNum'];
    debugPrint(userPrefecture + userSenkyokuNum);
  }

  Future<void> _getPoliticians() async {
    await _getUserData();
    final snapshot = await politicians
        .where('prefecture', isEqualTo: userPrefecture)
        .where('senkyokuNum', isEqualTo: userSenkyokuNum)
        .get();
    setState(() {
      politiciansList = snapshot.docs.map((doc) => doc.data()).toList();
    });

    debugPrint(snapshot.docs.map((doc) => doc.data()).toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getPoliticians();
  }

  Widget buildLowersList() {
    return ListView(
      children: <Widget>[
        for (int i = 0; i < politiciansList.length; i++)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ConfirmVotingPage(politiciansList[i]['name']),
              ));
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 183, 230, 215),
                        width: 3,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 36.0,
                      backgroundImage:
                          AssetImage('assets/images/politician_img.png'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          politiciansList[i]['name'],
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        Container(
                          width: 150,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 137, 198, 179),
                                width: 5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  //CheckBox(),
                  const Center(
                    child: CheckboxWidget(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, '投票先を選ぶ'),
      body: buildLowersList(),
    );
  }
}

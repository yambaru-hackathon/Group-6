import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happyhappyhappy/provider/auth_service.dart';

// local
import '../../provider/auth_state.dart';
import '../../components/app_bar.dart';

class LowerHouse extends ConsumerStatefulWidget {
  const LowerHouse({super.key});

  @override
  ConsumerState<LowerHouse> createState() => _LowerHouseState();
}

class Completed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Container(
          child: Text(
            '投票ありがとうございました',
          ),
        ),
      ),
    );
  }
}

class ConfirmVotingPage extends StatelessWidget {
  const ConfirmVotingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('next page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromARGB(255, 137, 198, 179),
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 36.0,
                  backgroundImage:
                      AssetImage('assets/images/politician_img.png'),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Texttttttttttttttt',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 137, 198, 179),
                          width: 5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'よろしいですか？',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    '変更、再投票はできません',
                    style: TextStyle(
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20), // テキストとボタンの間隔
          ElevatedButton(
            onPressed: () {
              //print('投票完了');
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Completed(),
              ));
            },
            child: Text('投票する'),
          ),
        ],
      ),
    );
  }
}

class CheckboxWidget extends StatefulWidget {
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
  final politicians = FirebaseFirestore.
                        instance.collection('politician');
  final users = FirebaseFirestore.instance.
                        collection('users');
  
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
    final snapshot = await politicians.where('prefecture', isEqualTo: userPrefecture)
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
                builder: (context) => ConfirmVotingPage(),
              ));
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color.fromARGB(255, 183, 230, 215),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 36.0,
                      backgroundImage:
                          AssetImage('assets/images/politician_img.png'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          politiciansList[i]['name'],
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
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
                  Spacer(),
                  //CheckBox(),
                  Center(
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

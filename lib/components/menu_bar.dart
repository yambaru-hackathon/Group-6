// package
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// local
import '../provider/auth_service.dart';

class MyMenuBar extends StatefulWidget {
  const MyMenuBar({super.key});

  @override
  State<MyMenuBar> createState() => _MyMenuBarState();
}

class _MyMenuBarState extends State<MyMenuBar> {
  final AuthService _authService = AuthService();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // 郵便番号
  String postcode = '';
  String postcodeFirst = '';

  //選挙区コード
  String prefectureCode = '';
  String districtNum = '';

  // 選挙区
  String prefectureText = '';
  String hireiDistrictText = '';
  String electoralDistrictText = '';

  // 郵便番号から選挙区を取得
  Future<void> loadJsonAsset() async {
    final String hireiJsonString =
        await rootBundle.loadString('assets/json/hirei.json');
    final dynamic hireiJsonResponse = json.decode(hireiJsonString);
    final String postalJsonString =
        await rootBundle.loadString('assets/json/postal2senkyoku.light.json');
    final dynamic postalJsonResponse = json.decode(postalJsonString);
    setState(() {
      try {
        if (postalJsonResponse[postcodeFirst] != null) {
          prefectureCode = postalJsonResponse[postcodeFirst]['p'];
          districtNum = postalJsonResponse[postcodeFirst]['s'];
        } else {
          prefectureCode = postalJsonResponse[postcode]['p'];
          districtNum = postalJsonResponse[postcode]['s'];
        }
        prefectureText = hireiJsonResponse[prefectureCode]['prefecture'];
        hireiDistrictText = hireiJsonResponse[prefectureCode]['region'];

        electoralDistrictText = '$prefectureText $districtNum区';
      } catch (e) {
        prefectureText = 'エラー';
        hireiDistrictText = 'エラー';
        electoralDistrictText = 'エラー';
      }
    });

    debugPrint(prefectureText);
    debugPrint(hireiDistrictText);
    debugPrint(electoralDistrictText);
  }

  Future<void> fetchUserData() async {
    final userData = await db.collection('users').doc(auth.currentUser?.uid).get();
    setState(() {
      postcode = userData['postcode'];
      postcodeFirst = postcode.substring(0, 3);
    });
    loadJsonAsset();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 0,
                  width: 300,
                ),
                const Text('選挙区',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('比例区  $hireiDistrictTextブロック',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('小選挙区  $electoralDistrictText',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Text('郵便番号: $postcode'),
              ],
            ),
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () async {
              await _authService.signOut();
            },
          ),
        ],
      ),
    );
  }
}

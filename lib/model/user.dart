import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.id,
    required this.postcode,
    required this.myNumber,
    required this.prefecture,
    required this.senkyokuNum,
    required this.lowerHouseVote,
  });

  final String id;
  final String postcode;
  final String myNumber;
  final String prefecture;
  final String senkyokuNum;
  final String lowerHouseVote;

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      postcode: data['postcode'],
      myNumber: data['myNumber'],
      prefecture: data['prefecture'],
      senkyokuNum: data['senkyokuNum'],
      lowerHouseVote: data['lowerHouseVote'],
    );
  }
}

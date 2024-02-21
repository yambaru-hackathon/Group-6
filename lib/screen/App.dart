import 'package:flutter/material.dart';
import 'election/election_list.dart';
import 'article/article.dart';
import 'popular_vote/popular_vote.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _currentIndex = 0;

  final _pageWidgets = [
    ElectionList(),
    PopularVote(),
    Article(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidgets.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '人気'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'フォロー中'),
        ],
        currentIndex: _currentIndex,
        fixedColor: Colors.blueAccent,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
   void _onItemTapped(int index){ 
    setState(() => _currentIndex = index );
   }
}
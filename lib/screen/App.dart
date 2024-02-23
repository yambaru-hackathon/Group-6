import 'package:flutter/material.dart';
import 'package:navigator_scope/navigator_scope.dart';
import 'election/election_list.dart';
import 'article/article.dart';
import 'popular_vote/popular_vote.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int currentTab = 0;

  final tabs = const [
    NavigationDestination(
      icon: Icon(Icons.how_to_vote),
      label: '投票',
    ),
    NavigationDestination(
      icon: Icon(Icons.star),
      label: '人気',
    ),
    NavigationDestination(
      icon: Icon(Icons.people),
      label: '調べる',
    ),
  ];

  final navigatorKeys = [
    GlobalKey<NavigatorState>(debugLabel: '投票 Tab'),
    GlobalKey<NavigatorState>(debugLabel: '人気 Tab'),
    GlobalKey<NavigatorState>(debugLabel: '調べる Tab'),
  ];

  NavigatorState get currentNavigator => navigatorKeys[currentTab].currentState!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigatorScope(
        currentDestination: currentTab,
        destinationCount: tabs.length,
        destinationBuilder: (context, index) {
          return NestedNavigator(
            navigatorKey: navigatorKeys[index],
            builder: (context) => [
              ElectionList(),
              PopularVote(),
              Article(),
            ][index],
          ); 
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentTab,
        onDestinationSelected: onTabselected,
        destinations: tabs,
        indicatorColor: Colors.black12,
        surfaceTintColor: Colors.black12,
        shadowColor: Colors.black,
      ),
    );
  }
   void onTabselected(int tab){ 
    if (tab == currentTab && currentNavigator.canPop()) {
      // Pop to the first route in the current navigator' stack
      // if the current tab is tapped again.
      currentNavigator.popUntil((route) => route.isFirst);
    } else {
      setState(() => currentTab = tab);
    }
   }
}
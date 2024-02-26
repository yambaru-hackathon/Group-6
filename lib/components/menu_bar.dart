import 'package:flutter/material.dart';
import '../provider/auth_service.dart';


class MyMenuBar extends StatefulWidget {
  MyMenuBar({super.key});

  @override
  State<MyMenuBar> createState() => _MyMenuBarState();
}

class _MyMenuBarState extends State<MyMenuBar> {
  final AuthService _authService = AuthService();

  String postcode = '';
  String postcodeFirst = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postcode = '9052171';
    postcodeFirst = postcode.substring(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Text('Menu Bar'),
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


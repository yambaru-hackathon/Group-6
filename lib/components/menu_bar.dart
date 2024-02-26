import 'package:flutter/material.dart';
import '../provider/auth_service.dart';

class MyMenuBar extends StatelessWidget {
  MyMenuBar({super.key});

  final AuthService _authService = AuthService();

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


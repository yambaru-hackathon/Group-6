import 'package:flutter/material.dart';

PreferredSize myAppBar(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: AppBar(
      centerTitle: true,
      title: Text(title),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
        const SizedBox(width: 5),
      ],
    ),
  );
}

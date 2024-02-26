import 'package:flutter/material.dart';

PreferredSize myAppBar(String title) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: AppBar(
      centerTitle: true,
      title: Text(title),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // do something
          },
        ),
        const SizedBox(width: 5),
      ],
    ),
  );
}

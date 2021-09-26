import 'package:flutter/material.dart';

import 'home.screen.dart';

class JokeScreen extends StatelessWidget {
  static const routeName = '/screenTwo';
  const JokeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_right_alt),
            onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName),
          )
        ],
      ),
    );
  }
}

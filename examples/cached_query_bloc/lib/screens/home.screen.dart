import 'package:examples/screens/joke.screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('posts'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_right_alt),
            onPressed: () => Navigator.pushNamed(context, JokeScreen.routeName),
          )
        ],
      ),
    );
  }
}

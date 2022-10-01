import 'package:flutter/material.dart';

import '../models/post_model.dart';

class Post extends StatelessWidget {
  final PostModel post;

  const Post({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            "Title",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            post.title,
            textAlign: TextAlign.center,
          ),
          const Text(
            "Body",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            post.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

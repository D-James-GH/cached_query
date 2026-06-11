import 'package:flutter/material.dart';
import 'package:build_extensions/posts/screens/single_post_screen.dart';

import '../post_model/post_model.dart';

class PostListItem extends StatelessWidget {
  final PostModel post;
  final int index;

  const PostListItem({super.key, required this.post, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<SinglePostScreen>(
          builder: (context) => SinglePostScreen(id: post.id),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(post.id.toString()),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(post.body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

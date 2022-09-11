import 'package:flutter/material.dart';
import 'package:infinite_list_with_bloc/post/pages/post_list_page.dart';

/// A page just used for caching demos
class DetailsPage extends StatelessWidget {
  static const routeName = "details";
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_right_alt),
            onPressed: () => Navigator.pushReplacementNamed(
              context,
              PostListPage.routeName,
            ),
          )
        ],
      ),
      body: const Center(
        child: Text(
          "Another page",
        ),
      ),
    );
  }
}

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mutation/posts/post_model.dart';
import 'package:mutation/posts/posts_repo.dart';

class CreatePostForm extends StatefulWidget {
  const CreatePostForm({super.key});

  @override
  State<CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(label: Text("Title")),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: bodyController,
            decoration: const InputDecoration(label: Text("Body")),
          ),
          MutationBuilder(
            mutation: createPostMutation(),
            builder: (context, state, mutate) {
              final isLoading = state.status == QueryStatus.loading;

              return ElevatedButton(
                // disable the button while loading
                onPressed: isLoading
                    ? null
                    : () => mutate(
                          PostModel(
                            body: bodyController.text,
                            title: titleController.text,
                            userId: "123456",
                          ),
                        ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Create"),
              );
            },
          )
        ],
      ),
    );
  }
}

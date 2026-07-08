import 'dart:async';
import 'dart:io';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';

import '../movies/movie_screen.dart';
import '../posts/post_list_screen.dart';
import 'cancel_demo_service.dart';

class CancelQueryScreen extends StatefulWidget {
  static const routeName = '/cancel-demo';

  const CancelQueryScreen({super.key});

  @override
  State<CancelQueryScreen> createState() => _CancelQueryScreenState();
}

class _CancelQueryScreenState extends State<CancelQueryScreen> {
  final CancelDemoService _service = CancelDemoService();
  late final Query<Post> _query = _service.query;

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watchQuery(query: _query);
    final hasData = state.data != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancellation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_right_alt),
            onPressed: () => Navigator.pushReplacementNamed(
              context,
              PostListScreen.routeName,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mood),
            onPressed: () => Navigator.pushReplacementNamed(
              context,
              MovieScreen.routeName,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tap Fetch to start a real request to the local mock backend. '
              'The backend waits 5 seconds before replying so there is time '
              'to press Cancel and see the query return to its previous state.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'GET ${_service.cancelDemoUri}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              _statusText(state),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (state.isLoading) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 16),
            ],
            if (hasData) _PostCard(post: state.data!),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: state.isLoading ? null : () => _query.refetch(),
                    child: Text(hasData ? 'Refetch' : 'Fetch'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: state.isLoading ? _cancelFetch : null,
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _cancelFetch() {
    _query.cancel('User cancelled');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request cancelled - showing previous result'),
      ),
    );
  }

  String _statusText(QueryState<Post> state) {
    if (state.isLoading) {
      return 'Loading from the mock backend...';
    }

    if (state is QueryError<Post>) {
      if (state.error is SocketException) {
        return 'Could not reach the backend. Start it with: melos run backend';
      }

      return 'Request failed: ${state.error}';
    }

    if (state.data != null) {
      return 'Post loaded. Refetch, then Cancel before the 5 second delay ends.';
    }

    return 'Tap Fetch to start.';
  }
}

class _PostCard extends StatelessWidget {
  final Post post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Post ${post.id}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              post.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(post.body),
          ],
        ),
      ),
    );
  }
}

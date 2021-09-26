import 'package:examples/blocs/joke/joke_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home.screen.dart';

class JokeScreen extends StatelessWidget {
  static const routeName = '/screenTwo';
  const JokeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('jokes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_right_alt),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, HomeScreen.routeName),
          )
        ],
      ),
      body: BlocBuilder<JokeBloc, JokeState>(builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (state.status == JokeStatus.loading)
                const SizedBox(
                    width: 40, height: 40, child: CircularProgressIndicator()),
              if (state.status == JokeStatus.initial) const Text('no joke yet'),
              if (state.joke != null) Text(state.joke!.joke),
            ],
          ),
        );
      }),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/player_bloc.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (state is PlayerFailure) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                ),
                Text('Oops! ${state.message}'),
                RaisedButton(
                  onPressed: () {
                    BlocProvider.of<PlayerBloc>(context).add(
                      const InitialisePlayer(
                        'assets/midi/midi.mid',
                        'assets/music/music.wav',
                        'music/music.wav',
                      ),
                    );
                  },
                  child: const Text('Try again'),
                ),
              ],
            );
          }
          else if (state is PlayerSuccess) {
            return const Center(
              child: Text('༼ つ ◕_◕ ༽つ'),
            );
          }
          else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
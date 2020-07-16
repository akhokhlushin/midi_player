import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:rxdart/rxdart.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  double volumeMusic = 0.5;
  double replicGap = 0.0;

  BehaviorSubject<double> volumeMusicStream = BehaviorSubject<double>();
  BehaviorSubject<double> volumeReplicStream = BehaviorSubject<double>();
  BehaviorSubject<double> replicGapStream = BehaviorSubject<double>();

  @override
  void initState() {
    volumeMusicStream.add(volumeMusic);
    volumeReplicStream.add(volumeMusic);
    replicGapStream.add(replicGap);

    BlocProvider.of<PlayerBloc>(context).add(
      InitialisePlayer(
        midiFilePath: 'assets/midi/miidi.mid',
        songPath1: 'assets/music/muusic.wav',
        songPath2: 'music/muusic.wav',
        volumeMusic: volumeMusicStream,
        volumeReplic: volumeReplicStream,
        replicGap: replicGapStream,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerFailure) {
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
                      InitialisePlayer(
                        midiFilePath: 'assets/midi/miidi.mid',
                        songPath2: 'assets/music/muusic.wav',
                        songPath1: 'music/muusic.wav',
                        volumeMusic: volumeMusicStream,
                        volumeReplic: volumeReplicStream,
                        replicGap: replicGapStream,
                      ),
                    );
                  },
                  child: const Text('Try again'),
                ),
              ],
            );
          } else if (state is PlayerInitial) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('༼ つ ◕_◕ ༽つ'),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const <Widget>[
                    Text('Replic'),
                    Text('Music'),
                  ],
                ),
                const SizedBox(height: 24),
                Slider(
                  value: volumeMusic,
                  onChanged: (value) {
                    setState(() {
                      volumeMusic = value;
                    });

                    volumeMusicStream.add(value);
                    volumeReplicStream.add(1 - value);
                  },
                  min: 0.0,
                  max: 1.0,
                  label: '${volumeMusic * 100}%',
                  inactiveColor: Colors.red,
                ),
                const SizedBox(height: 24),
                Text('${replicGap.toStringAsFixed(2)} seconds'),
                const SizedBox(height: 24),
                Slider(
                  value: replicGap,
                  onChanged: (value) {
                    setState(() {
                      replicGap = value;
                    });

                    replicGapStream.add(value);
                  },
                  min: 0.0,
                  max: 5.0,
                  label: '$replicGap s',
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

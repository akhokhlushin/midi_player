import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/core/constants.dart';
import 'package:midi_player/features/player/presentation/bloc/midi/midi_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/pause/pause_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:rxdart/rxdart.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  double volumeMusic = 0.5;
  int replicGap = 0;

  BehaviorSubject<double> volumeMusicStream = BehaviorSubject<double>();
  BehaviorSubject<double> volumeReplicStream = BehaviorSubject<double>();
  BehaviorSubject<int> replicGapStream = BehaviorSubject<int>();
  BehaviorSubject<bool> playButtonStream = BehaviorSubject<bool>.seeded(false);

  @override
  void initState() {
    volumeMusicStream.add(volumeMusic);
    volumeReplicStream.add(volumeMusic);
    replicGapStream.add(replicGap);

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
                    BlocProvider.of<MidiBloc>(context).add(
                      InitialiseMidi(midiFilePath),
                    );
                  },
                  child: const Text('Try again'),
                ),
              ],
            );
          } else if (state is PlayerInitial) {
            return BlocConsumer<MidiBloc, MidiState>(
              listener: (context, state) {
                if (state is MidiSuccess) {
                  BlocProvider.of<PlayerBloc>(context).add(
                    Play(
                      replics: state.replics,
                      songPath: songPath,
                      volumeMusic: volumeMusicStream,
                      volumeReplic: volumeReplicStream,
                      player: playButtonStream,
                      replicGap: replicGapStream,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is MidiLoading || state is MidiInitial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MidiFailure) {
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
                          BlocProvider.of<MidiBloc>(context).add(
                            InitialiseMidi(midiFilePath),
                          );
                        },
                        child: const Text('Try again'),
                      ),
                    ],
                  );
                } else if (state is MidiSuccess) {
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
                      Text(
                        "${replicGap.toStringAsFixed(2)} replics 'durations' which would bypassed before next replic",
                      ),
                      const SizedBox(height: 24),
                      Slider(
                        value: replicGap.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            replicGap = value.toInt();
                          });
                        },
                        max: 12.0,
                        label: '$replicGap',
                      ),
                      StreamBuilder<bool>(
                        stream: playButtonStream,
                        initialData: false,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data) {
                              return IconButton(
                                icon: Icon(Icons.play_arrow),
                                onPressed: () {
                                  BlocProvider.of<PlayerBloc>(context).add(
                                    Play(
                                      replics: state.replics,
                                      songPath: songPath,
                                      volumeMusic: volumeMusicStream,
                                      volumeReplic: volumeReplicStream,
                                      player: playButtonStream,
                                      replicGap: replicGapStream,
                                    ),
                                  );
                                },
                              );
                            } else {
                              return IconButton(
                                icon: Icon(Icons.pause),
                                onPressed: () {
                                  BlocProvider.of<PauseBloc>(context).add(
                                    PauseE(playButtonStream),
                                  );
                                },
                              );
                            }
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

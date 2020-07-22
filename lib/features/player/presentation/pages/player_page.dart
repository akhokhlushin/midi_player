import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/core/constants.dart';
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
  BehaviorSubject<int> timeBeforeStream = BehaviorSubject<int>();
  BehaviorSubject<int> timeAfterStream = BehaviorSubject<int>();

  @override
  void initState() {
    volumeMusicStream.add(volumeMusic);
    volumeReplicStream.add(volumeMusic);
    replicGapStream.add(replicGap);

    BlocProvider.of<PlayerBloc>(context).add(
      InitialisePlayer(
        midiFilePath: midiFilePath,
        songPath1: songPath1,
        songPath2: songPath2,
        volumeMusic: volumeMusicStream,
        volumeReplic: volumeReplicStream,
        replicGap: replicGapStream,
        timeAfterStream: timeAfterStream,
        timeBeforeStream: timeBeforeStream,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
                        midiFilePath: midiFilePath,
                        songPath2: songPath2,
                        songPath1: songPath1,
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
          } else if (state is PlayerLoading) {
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
                  value: replicGap,
                  onChanged: (value) {
                    setState(() {
                      replicGap = value;
                    });

                    replicGapStream.add(value);
                  },
                  divisions: 12,
                  min: 0.0,
                  max: 12.0,
                  label: '$replicGap',
                ),
                Column(
                  children: const <Widget>[
                    Text('Music loading...'),
                    CircularProgressIndicator(),
                  ],
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
                Text(
                  "${replicGap.toStringAsFixed(2)} replics 'durations' which would bypassed before next replic",
                ),
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
                  max: 12.0,
                  label: '$replicGap',
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    StreamBuilder<int>(
                      initialData: 0,
                      stream: timeBeforeStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            height: 50,
                            width: size.width * .2,
                            color: Colors.red,
                            child: Center(
                              child: Text('${snapshot.data / 5} ticks'),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    StreamBuilder<double>(
                      initialData: 0,
                      stream: replicGapStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            height: 50,
                            width: size.width * .3,
                            color: Colors.green,
                            child: Center(
                              child: Text(
                                replicGap.toStringAsFixed(2),
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    Container(
                      height: 50,
                      width: size.width * .4,
                      color: Colors.blue,
                      child: const Center(
                        child: Text('Replic'),
                      ),
                    ),
                    StreamBuilder<int>(
                      initialData: 0,
                      stream: timeAfterStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            height: 50,
                            width: size.width * .1,
                            color: Colors.yellow,
                            child: Center(
                              child: Text('${snapshot.data / 5} ticks'),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
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

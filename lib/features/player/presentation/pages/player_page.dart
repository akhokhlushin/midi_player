import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/core/constants.dart';
import 'package:midi_player/core/widgets/common_stream_builder.dart';
import 'package:midi_player/core/widgets/void.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:midi_player/features/player/presentation/bloc/midi/midi_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/pause/pause_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/resume/resume_bloc.dart';
import 'package:midi_player/features/player/presentation/widgets/error.dart';
import 'package:midi_player/features/player/presentation/widgets/gap_setter.dart';
import 'package:midi_player/features/player/presentation/widgets/volume_setter.dart';
import 'package:rxdart/rxdart.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with TickerProviderStateMixin {
  static const _initialVolume = .5;

  double volumeMusic = _initialVolume;

  final BehaviorSubject<double> _volumeMusicStream =
      BehaviorSubject<double>.seeded(_initialVolume);
  final BehaviorSubject<double> _volumeReplicStream =
      BehaviorSubject<double>.seeded(_initialVolume);
  final BehaviorSubject<int> _replicGapStream = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<bool> _playButtonStream =
      BehaviorSubject<bool>.seeded(false);

  void _play(MidiSuccess state) {
    BlocProvider.of<PlayerBloc>(context).add(
      PlayE(
        replics: state.music.replics,
        songPath: songPath,
        onMidiEvents: state.onMidiEvent,
        volumeMusic: _volumeMusicStream,
        volumeReplic: _volumeReplicStream,
        player: _playButtonStream,
        replicGap: _replicGapStream,
      ),
    );
  }

  void _resume(MidiSuccess state) {
    BlocProvider.of<ResumeBloc>(context).add(
      Restart(
        replics: state.music.replics,
        onMidiEvents: state.onMidiEvent,
        songPath: songPath,
        volumeMusic: _volumeMusicStream,
        volumeReplic: _volumeReplicStream,
        player: _playButtonStream,
        replicGap: _replicGapStream,
      ),
    );
  }

  void _pause() {
    BlocProvider.of<PauseBloc>(context).add(
      PauseE(
        _playButtonStream,
      ),
    );
  }

  @override
  void initState() {
    BlocProvider.of<MidiBloc>(context).add(
      InitialiseMidi(
        midiFilePath: midiFilePath,
        replicGap: _replicGapStream,
        playButton: _playButtonStream,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final AnimationController animationController = AnimationController(
      vsync: this,
      value: 0,
      upperBound: (size.width * 5) - 2,
    );

    return Scaffold(
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerFailure) {
            return _buildPlayerFailure(state, context);
          } else if (state is PlayerInitial) {
            return BlocConsumer<MidiBloc, MidiState>(
              listener: (context, state) {
                if (state is MidiSuccess) {
                  _play(state);

                  animationController.animateTo(
                    (size.width * 5) - 2,
                    duration: _getTotalDuration(state.music.replics),
                  );
                }
              },
              builder: (context, state) {
                if (state is MidiLoading || state is MidiInitial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MidiFailure) {
                  return _buildMidiFailure(state, context);
                } else if (state is MidiSuccess) {
                  return _buildSuccess(state, animationController, size);
                }
                return const Void();
              },
            );
          }
          return const Void();
        },
      ),
    );
  }

  Column _buildSuccess(
      MidiSuccess state, AnimationController animationController, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('༼ つ ◕_◕ ༽つ'),
        const SizedBox(height: 25),
        VolumeSetter(
          volumeMusicStream: _volumeMusicStream,
          volumeReplicStream: _volumeReplicStream,
        ),
        const SizedBox(height: 25),
        GapSetter(
          replicGapStream: _replicGapStream,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _pause();

                _play(state);

                animationController.animateTo(0.0, duration: Duration.zero);

                animationController.animateTo(
                  (size.width * 5) - 2,
                  duration: _getTotalDuration(
                    state.music.replics,
                  ),
                );
              },
            ),
            CommonStreamBuilder<bool>(
              stream: _playButtonStream,
              onHasData: (bool value) {
                return IconButton(
                  icon: value
                      ? const Icon(Icons.play_arrow)
                      : const Icon(Icons.pause),
                  onPressed: value
                      ? () {
                          _resume(state);

                          animationController.animateTo(
                            (size.width * 5) - 2,
                            duration: _getTotalDuration(
                              state.music.replics,
                            ),
                          );
                        }
                      : () {
                          _pause();

                          animationController.stop();
                        },
                );
              },
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Stack(
            children: [
              Row(
                children: _getSongTrail(state.music.replics),
              ),
              Container(
                width: size.width * 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    state.music.bitAmount,
                    (index) => Container(
                      height: 75,
                      color: Colors.green,
                      width: 1,
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Positioned(
                    left: animationController.value,
                    child: Container(
                      width: 2,
                      height: 75,
                      color: Colors.blue,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMidiFailure(MidiFailure state, BuildContext context) {
    return AppErrorWidget(
      message: state.message,
      replicGap: _replicGapStream,
    );
  }

  Widget _buildPlayerFailure(PlayerFailure state, BuildContext context) {
    return AppErrorWidget(
      message: state.message,
      replicGap: _replicGapStream,
    );
  }

  Duration _getTotalDuration(List<Replic> replics) {
    Duration allDuration = Duration.zero;

    final replicG = _replicGapStream.value;

    for (final replic in replics) {
      allDuration += (replic.timeBefore * (replicG + 1)) +
          (replic.timeAfter * (replicG + 1));
    }

    return allDuration;
  }

  List<Widget> _getSongTrail(List<Replic> replics) {
    final screenSize = MediaQuery.of(context).size;

    final allDuration = _getTotalDuration(replics);

    final widthInOneMiliSecond =
        screenSize.width * 5 / allDuration.inMilliseconds;

    final List<Widget> result = [];

    for (int i = 0; i < replics.length; i++) {
      final replic = replics[i];

      result.add(
        Container(
          height: 75,
          color: Colors.red,
          width: replic.timeBefore.inMilliseconds * widthInOneMiliSecond,
        ),
      );

      result.add(
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 75,
              color: Colors.red,
              width: replic.timeAfter.inMilliseconds * widthInOneMiliSecond,
            ),
            Container(
              height: 75,
              color: Colors.black,
              width:
                  replic.replicDuration.inMilliseconds * widthInOneMiliSecond,
            ),
          ],
        ),
      );
    }

    return result;
  }
}

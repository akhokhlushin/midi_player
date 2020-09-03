import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/core/constants.dart';
import 'package:midi_player/core/widgets/common_stream_builder.dart';
import 'package:midi_player/core/widgets/void.dart';
import 'package:midi_player/features/player/domain/entities/music.dart';
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
  final BehaviorSubject<int> _replicGapStream = BehaviorSubject<int>.seeded(1);
  final BehaviorSubject<bool> _playButtonStream =
      BehaviorSubject<bool>.seeded(true);

  AnimationController _animationController;

  final int _view = 20;

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

  void _refresh(MidiSuccess state) {
    _playButtonStream.add(true);

    _pause();

    BlocProvider.of<MidiBloc>(context).add(
      InitialiseMidi(
        midiFilePath: midiFilePath,
        playButton: _playButtonStream,
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
    _animationController = AnimationController(
      vsync: this,
      value: 0,
    );

    BlocProvider.of<MidiBloc>(context).add(
      InitialiseMidi(
        midiFilePath: midiFilePath,
        playButton: _playButtonStream,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerFailure) {
            return _buildPlayerFailure(state, context);
          } else if (state is PlayerInitial) {
            return BlocConsumer<MidiBloc, MidiState>(
              listener: (context, state) {
                if (state is MidiSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _animationController.animateTo(
                      1,
                      duration: state.music.musicDuration *
                          (1 - _animationController.value),
                    ),
                  );

                  _play(state);
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
                  return _buildSuccess(state, _animationController, size);
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
                _refresh(state);

                animationController.animateTo(0.0, duration: Duration.zero);
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
                          animationController.animateTo(
                            1,
                            duration: state.music.musicDuration *
                                (1 - animationController.value),
                          );

                          _resume(state);
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
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: size.width * _view,
            height: 75,
            child: Stack(
              children: [
                Container(
                  width: size.width * _view,
                  height: 75,
                  color: Colors.red,
                ),
                CommonStreamBuilder<int>(
                  stream: _replicGapStream,
                  onHasData: (value) {
                    return Stack(
                      children: _getSongTrail(state.music),
                    );
                  },
                ),
                Container(
                  width: size.width * _view,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<Widget>.generate(
                      state.music.bitAmount,
                      (index) => Container(
                        height: 75,
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Positioned(
                      left: animationController.value *
                          ((size.width * _view) - 2),
                      top: 0,
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
        ),
      ],
    );
  }

  Widget _buildMidiFailure(MidiFailure state, BuildContext context) {
    return AppErrorWidget(
      message: state.message,
      playButton: _playButtonStream,
    );
  }

  Widget _buildPlayerFailure(PlayerFailure state, BuildContext context) {
    return AppErrorWidget(
      message: state.message,
      playButton: _playButtonStream,
    );
  }

  double widthLeft = 0;

  List<Widget> _getSongTrail(Music music) {
    final screenSize = MediaQuery.of(context).size;

    final allDuration = music.musicDuration;

    final widthInOneMiliSecond =
        (screenSize.width * _view) / allDuration.inMilliseconds;

    final List<Widget> result = [];

    int indexForFive = 0;

    widthLeft = 0;

    for (int i = 0; i < music.replics.length; i++) {
      final replic = music.replics[i];

      if (_replicGapStream.value != 5) {
        if (_replicGapStream.value == 1) {
          result.add(
            _buildEvent(
              replic.timeBefore,
              replic.timeAfter,
              widthInOneMiliSecond,
              false,
            ),
          );
        } else if ((i + 1) % _replicGapStream.value != 0) {
          result.add(
            _buildEvent(
              replic.timeBefore,
              replic.timeAfter,
              widthInOneMiliSecond,
              false,
            ),
          );
        } else {
          result.add(
            _buildEvent(
              replic.timeBefore,
              replic.timeAfter,
              widthInOneMiliSecond,
              true,
            ),
          );
        }
      } else {
        if ((i + 1) - (4 * indexForFive) == 1) {
          result.add(
            _buildEvent(
              replic.timeBefore,
              replic.timeAfter,
              widthInOneMiliSecond,
              false,
            ),
          );
          indexForFive++;
        } else {
          result.add(
            _buildEvent(
              replic.timeBefore,
              replic.timeAfter,
              widthInOneMiliSecond,
              true,
            ),
          );
        }
      }
    }

    return result;
  }

  Widget _buildEvent(Duration timeBefore, Duration timeAfter,
      double widthInOneMiliSecond, bool isHidden) {
    final left = timeBefore.inMilliseconds * widthInOneMiliSecond;
    final right = timeAfter.inMilliseconds * widthInOneMiliSecond;

    final widget = Positioned(
      left: left + widthLeft,
      top: 0,
      child: Container(
        height: 75,
        color: isHidden ? null : Colors.black,
        width: 5,
      ),
    );

    widthLeft += left + right;

    return widget;
  }
}

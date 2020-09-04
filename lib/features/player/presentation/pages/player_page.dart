import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/core/constants.dart';
import 'package:midi_player/core/widgets/common_stream_builder.dart';
import 'package:midi_player/core/widgets/void.dart';
import 'package:midi_player/features/player/domain/entities/music.dart';
import 'package:midi_player/features/player/presentation/bloc/midi/midi_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:midi_player/features/player/presentation/widgets/error.dart';
import 'package:midi_player/features/player/presentation/widgets/gap_setter.dart';
import 'package:midi_player/features/player/presentation/widgets/variation_setter.dart';
import 'package:midi_player/features/player/presentation/widgets/volume_setter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:midi_player/core/extensions/list.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with TickerProviderStateMixin {
  static const _initialVolume = .5;

  final BehaviorSubject<double> _volumeMusicStream =
      BehaviorSubject<double>.seeded(_initialVolume);
  final BehaviorSubject<double> _volumeReplicStream =
      BehaviorSubject<double>.seeded(_initialVolume);
  final BehaviorSubject<int> _replicGapStream = BehaviorSubject<int>.seeded(1);
  final BehaviorSubject<bool> _playButtonStream =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _playVariation =
      BehaviorSubject<bool>.seeded(true);

  AnimationController _animationController;

  final int _view = 20;

  void _playReplic(String replicPath) {
    BlocProvider.of<PlayerBloc>(context).add(
      PlayReplicE(
        replicPath: replicPath,
        variousOfPlay: _playVariation,
        volume: _volumeReplicStream,
      ),
    );
  }

  void _playMusic() {
    BlocProvider.of<PlayerBloc>(context).add(
      PlayMusicE(
        songPath: songPath,
        volume: _volumeMusicStream,
      ),
    );
  }

  void _pause() {
    BlocProvider.of<PlayerBloc>(context).add(PauseE());
  }

  void _resumeMusic() {
    BlocProvider.of<PlayerBloc>(context).add(
      ResumeMusicE(
        volume: _volumeMusicStream,
      ),
    );
  }

  void _resumeReplic() {
    BlocProvider.of<PlayerBloc>(context).add(
      ResumeReplicE(
        volume: _volumeMusicStream,
      ),
    );
  }

  void _stop() {
    BlocProvider.of<PlayerBloc>(context).add(StopE());
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      value: 0,
    );

    BlocProvider.of<MidiBloc>(context).add(
      const InitialiseMidi(
        midiFilePath: midiFilePath,
      ),
    );

    super.initState();
  }

  int replicIndex = 0;
  double lastValue;
  bool pass = true;

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
                  _animationController.addListener(() {
                    final borders =
                        state.music.getBordersByIndex(_replicGapStream.value);

                    if (borders.containsNearest(_animationController.value)) {
                      if (replicIndex < state.music.replics.length) {
                        _playReplic(
                            state.music.replics[replicIndex].replicPath);
                      } else {
                        _playReplic(state.music.replics.last.replicPath);
                      }

                      replicIndex++;
                    }
                  });
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      _playMusic();
                      _animationController.animateTo(
                        1,
                        duration: state.music.musicDuration *
                            (1 - _animationController.value),
                      );
                    },
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
                setState(() {
                  replicIndex = 0;
                });
                animationController.animateTo(0.0, duration: Duration.zero);

                _animationController.animateTo(
                  1,
                  duration: state.music.musicDuration *
                      (1 - _animationController.value),
                );

                _stop();

                _playMusic();

                _playButtonStream.add(false);
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

                          _resumeMusic();
                          _resumeReplic();

                          _playButtonStream.add(!value);
                        }
                      : () {
                          animationController.stop();

                          _pause();

                          _playButtonStream.add(!value);
                        },
                );
              },
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        VariationSetter(
          variation: _playVariation,
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
    );
  }

  Widget _buildPlayerFailure(PlayerFailure state, BuildContext context) {
    return AppErrorWidget(
      message: state.message,
    );
  }

  List<Widget> _getSongTrail(Music music) {
    final screenSize = MediaQuery.of(context).size;

    final List<Widget> result = [];

    final borders = music.getBordersByIndex(_replicGapStream.value);

    for (int i = 0; i < borders.length; i++) {
      final border = borders[i];

      result.add(
        _buildEvent(
          screenSize,
          border,
        ),
      );
    }

    return result;
  }

  Widget _buildEvent(Size size, double border) {
    final widget = Positioned(
      top: 0,
      left: (size.width * _view) * border,
      child: Container(
        height: 75,
        color: Colors.black,
        width: 5,
      ),
    );

    return widget;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:midi_player/core/widgets/void.dart';
import 'package:midi_player/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:midi_player/features/player/domain/entities/player_data.dart';
import 'package:midi_player/features/player/presentation/bloc/midi/midi_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:midi_player/features/player/presentation/widgets/error.dart';
import 'package:midi_player/features/player/presentation/widgets/gap_setter.dart';
import 'package:midi_player/features/player/presentation/widgets/play_button.dart';
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

  int replicIndex = 0;

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

  void _playMusic(String path) {
    BlocProvider.of<PlayerBloc>(context).add(
      PlayMusicE(
        songPath: path,
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

    super.initState();
  }

  void Function(Duration d) _postFrame(MidiSuccess success) {
    return (_) {
      _animationController.value = 0;

      _playMusic(success.song.path);

      _playButtonStream.add(false);

      _animationController.animateTo(
        1,
        duration:
            success.music.midiFileDuration * (1 - _animationController.value),
      );
    };
  }

  void Function() _func;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<CatalogBloc, CatalogState>(
          builder: (context, catalogState) {
            if (catalogState is CatalogInitial ||
                catalogState is CatalogLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (catalogState is CatalogFailure) {
            } else if (catalogState is CatalogSuccess) {
              return BlocBuilder<PlayerBloc, PlayerState>(
                builder: (context, state) {
                  if (state is PlayerFailure) {
                    return _buildFailure(
                      state.message,
                      () => BlocProvider.of<CatalogBloc>(context).add(
                        InitialiseCatalog(),
                      ),
                    );
                  } else if (state is PlayerInitial) {
                    return BlocConsumer<MidiBloc, MidiState>(
                      listener: (context, state) {
                        if (state is MidiSuccess) {
                          replicIndex = 0;

                          _animationController.removeListener(_func);

                          _func = () {
                            final borders = state.music
                                .getBordersByIndex(_replicGapStream.value);

                            if (borders
                                .containsNearest(_animationController.value)) {
                              if (replicIndex < state.music.replics.length) {
                                _playReplic(state
                                    .music.replics[replicIndex].replicPath);
                              } else {
                                _playReplic(
                                    state.music.replics.last.replicPath);
                              }

                              replicIndex++;
                            }
                          };

                          _animationController.addListener(_func);

                          WidgetsBinding.instance
                              .addPostFrameCallback(_postFrame(state));
                        }
                      },
                      builder: (context, state) {
                        if (state is MidiLoading || state is MidiInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is MidiFailure) {
                          return _buildFailure(
                            state.message,
                            () => BlocProvider.of<MidiBloc>(context).add(
                              InitialiseMidi(
                                song: catalogState.songs.first,
                                index: 0,
                              ),
                            ),
                          );
                        } else if (state is MidiSuccess) {
                          return _buildSuccess(
                              state, _animationController, size);
                        }
                        return const Void();
                      },
                    );
                  }
                  return const Void();
                },
              );
            }
            return const Void();
          },
          listener: (context, state) {
            if (state is CatalogSuccess) {
              BlocProvider.of<MidiBloc>(context).add(
                InitialiseMidi(
                  song: state.songs.first,
                  index: 0,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Column _buildSuccess(
      MidiSuccess state, AnimationController animationController, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 25),
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
                replicIndex = 0;

                _animationController.value = 0;

                _animationController.animateTo(
                  1,
                  duration: state.music.midiFileDuration *
                      (1 - _animationController.value),
                );

                _stop();

                _playMusic(state.song.path);

                _playButtonStream.add(false);
              },
            ),
            PlayButton(
              value: _playButtonStream,
              onPlay: () {
                animationController.animateTo(
                  1,
                  duration: state.music.midiFileDuration *
                      (1 - animationController.value),
                );

                _resumeMusic();
                _resumeReplic();

                _playButtonStream.add(false);
              },
              onPause: () {
                animationController.stop();

                _pause();

                _playButtonStream.add(true);
              },
              onLong: () {
                Navigator.of(context).pushNamed('/catalog');
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
          child: Stack(
            children: [
              Row(
                children: _getSongTrail(state.music),
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
                    left: animationController.value * ((size.width * 5) - 2),
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
        const SizedBox(
          height: 20,
        ),
        const Expanded(
          child: SizedBox(),
        ),
        Container(
          height: 50,
          child: Marquee(
            text: state.song.fullName,
            blankSpace: 50,
            style: const TextStyle(
              fontFamily: 'Terminal',
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _getSongTrail(PlayerData music) {
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

  Widget _buildFailure(String message, void Function() onError) {
    return AppErrorWidget(
      message: message,
      onError: onError,
    );
  }
}

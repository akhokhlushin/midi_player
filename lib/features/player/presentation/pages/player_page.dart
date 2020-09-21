import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:midi_player/core/widgets/common_stream_builder.dart';
import 'package:midi_player/core/widgets/loading.dart';
import 'package:midi_player/core/widgets/void.dart';
import 'package:midi_player/features/catalog/presentation/bloc/catalog_bloc.dart';
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

  int _view = 20;

  // void _playMusic(int index) {
  //   BlocProvider.of<PlayerBloc>(context).add(
  //     PlayMusicE(
  //       index: index,
  //       volume: _volumeMusicStream,
  //     ),
  //   );
  // }

  // void _playReplics() {
  //   BlocProvider.of<PlayerBloc>(context).add(
  //     PlayReplicE(),
  //   );
  // }

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

  void _resumeReplics() {
    BlocProvider.of<PlayerBloc>(context).add(
      ResumeReplicE(
        volume: _volumeReplicStream,
      ),
    );
  }

  void _reset(int index, Duration d) {
    _playButtonStream.add(false);

    _animationController.value = 0;

    _animationController.animateTo(
      1,
      duration: d,
    );

    BlocProvider.of<PlayerBloc>(context).add(
      ResetE(
        index,
        _volumeMusicStream,
      ),
    );
  }

  @override
  void initState() {
    _animationController = AnimationController.unbounded(
      vsync: this,
    );

    super.initState();
  }

  bool disable = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<CatalogBloc, CatalogState>(
          builder: (context, catalogState) {
            if (catalogState is CatalogInitial ||
                catalogState is CatalogLoading) {
              return Loading();
            } else if (catalogState is CatalogFailure) {
              return _buildFailure(
                catalogState.message,
                () {
                  BlocProvider.of<CatalogBloc>(context)
                      .add(InitialiseCatalog());
                },
              );
            } else if (catalogState is CatalogSuccess) {
              return BlocConsumer<MidiBloc, MidiState>(
                builder: (context, midiState) {
                  if (midiState is MidiInitial || midiState is MidiLoading) {
                    return Loading();
                  } else if (midiState is MidiFailure) {
                    return _buildFailure(
                      midiState.message,
                      () {
                        BlocProvider.of<MidiBloc>(context).add(
                          InitialiseMidi(
                            song: catalogState.songs.first,
                            index: 0,
                            gap: _replicGapStream,
                            playVariation: _playVariation,
                            volume: _volumeReplicStream,
                          ),
                        );
                      },
                    );
                  } else if (midiState is MidiSuccess) {
                    return BlocConsumer<PlayerBloc, PlayerState>(
                      builder: (context, state) {
                        if (state is PlayerFailure) {
                          return _buildFailure(
                            state.message,
                            () {
                              BlocProvider.of<CatalogBloc>(context)
                                  .add(InitialiseCatalog());
                            },
                          );
                        } else if (state is PlayerInitial ||
                            state is PlayerPlaying) {
                          return _buildSuccess(midiState, size);
                        }
                        return const Void();
                      },
                      listener: (context, state) {
                        if (state is PlayerPlaying) {
                          _playButtonStream.add(false);

                          _animationController.value = 0;

                          _animationController.animateTo(
                            1,
                            duration: midiState.song.songDuration,
                          );
                        }
                      },
                    );
                  }
                  return const Void();
                },
                listener: (context, state) {
                  if (state is MidiSuccess) {
                    catalogState.stream.listen((event) {
                      if (event == state.song.songDuration) {
                        setState(() {
                          disable = true;
                        });
                      }
                    });

                    _reset(state.index, state.song.songDuration);

                    setState(() {
                      _view = (state.music.bitAmount / 32).floor();
                    });
                  }
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
                  gap: _replicGapStream,
                  playVariation: _playVariation,
                  volume: _volumeReplicStream,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Column _buildSuccess(MidiSuccess state, Size size) {
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
                _reset(state.index, state.song.songDuration);
              },
            ),
            PlayButton(
              disable: disable,
              value: _playButtonStream,
              onPlay: () {
                _resumeMusic();

                _resumeReplics();

                _playButtonStream.add(false);

                _animationController.animateTo(
                  1,
                  duration: state.music.midiFileDuration *
                      (1 - _animationController.value),
                );
              },
              onPause: () {
                _pause();

                _animationController.stop();

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
        CommonStreamBuilder<int>(
          stream: _replicGapStream,
          onHasData: (value) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Stack(
                children: [
                  Container(
                    width: size.width * _view,
                    height: 75,
                    color: Colors.red,
                  ),
                  Container(
                    width: size.width * _view,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List<Widget>.generate(
                        state.music.bitAmount,
                        (index) => Container(
                          height: 75,
                          color: state.music.bordersForUI.containsBinary(index)
                              ? Colors.black
                              : Colors.green,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Positioned(
                        left: _animationController.value *
                            ((size.width * _view) - 2),
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
            );
          },
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

  Widget _buildFailure(String message, void Function() onError) {
    return AppErrorWidget(
      message: message,
      onError: onError,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/core/widgets/common_stream_builder.dart';
import 'package:midi_player/core/widgets/void.dart';
import 'package:midi_player/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:midi_player/features/catalog/presentation/widgets/song_tile.dart';
import 'package:midi_player/features/player/presentation/bloc/midi/midi_bloc.dart';
import 'package:midi_player/features/player/presentation/widgets/error.dart';

class CatalogPage extends StatefulWidget {
  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose other songs:'),
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, catalogState) {
          if (catalogState is CatalogLoading ||
              catalogState is CatalogInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (catalogState is CatalogFailure) {
            return _buildFailure(
              catalogState.message,
              () => BlocProvider.of<CatalogBloc>(context)
                  .add(InitialiseCatalog()),
            );
          } else if (catalogState is CatalogSuccess) {
            return BlocBuilder<MidiBloc, MidiState>(
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
                        index: 0,
                        song: catalogState.songs[0],
                      ),
                    ),
                  );
                } else if (state is MidiSuccess) {
                  return _buildSuccess(catalogState, state.index);
                } else {
                  return const SizedBox();
                }
              },
            );
          }
          return const Void();
        },
      ),
    );
  }

  Widget _buildFailure(String message, void Function() onError) {
    return AppErrorWidget(
      message: message,
      onError: onError,
    );
  }

  Widget _buildSuccess(CatalogSuccess state, int currentPlayingIndex) {
    final songs = state.songs;
    final Stream<Duration> stream = state.stream;

    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        CommonStreamBuilder<Duration>(
          stream: stream,
          onHasData: (value) {
            final percentage = value.inMilliseconds /
                songs[currentPlayingIndex].songDuration.inMilliseconds;
            return Container(
              height: 25,
              width: size.width,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      height: 25,
                      width: size.width * percentage,
                      color: Color.lerp(Colors.red, Colors.green, percentage),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.white,
              height: 3,
            );
          },
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                BlocProvider.of<MidiBloc>(context).add(
                  InitialiseMidi(
                    song: songs[index],
                    index: index,
                  ),
                );

                Navigator.of(context).pop();
              },
              child: SongTile(
                song: songs[index],
                current: index == currentPlayingIndex,
                key: UniqueKey(),
              ),
            );
          },
          itemCount: songs.length,
        ),
      ],
    );
  }
}

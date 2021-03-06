import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:midi_player/features/catalog/domain/entities/song.dart';
import 'package:midi_player/features/catalog/domain/usecases/get_on_duration_change_stream.dart';
import 'package:midi_player/features/catalog/domain/usecases/get_songs.dart';
import 'package:midi_player/features/catalog/domain/usecases/load_all_musics.dart';
import 'package:midi_player/features/catalog/domain/usecases/pause_music.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final GetSongs _getSongs;
  final LoadAllMusics _loadAllMusics;
  final GetOnDurationChangeStream _getOnDurationChangeStream;

  CatalogBloc(
      this._getSongs, this._getOnDurationChangeStream, this._loadAllMusics);

  @override
  Stream<CatalogState> mapEventToState(
    CatalogEvent event,
  ) async* {
    if (event is InitialiseCatalog) {
      yield const CatalogLoading();

      final songsOrFailure = await _getSongs(NoParams());

      yield await songsOrFailure.fold(
        (failure) => CatalogFailure(failure.message),
        (songs) async {
          return await songsOrFailure.fold(
            (failure) => CatalogFailure(failure.message),
            (stream) async {
              final streamOrFailure =
                  await _getOnDurationChangeStream(NoParams());

              return await streamOrFailure.fold(
                (failure) => CatalogFailure(failure.message),
                (stream) async {
                  final loadOrFailure = await _loadAllMusics(songs);

                  return loadOrFailure.fold(
                    (failure) => CatalogFailure(failure.message),
                    (_) => CatalogSuccess(songs, stream),
                  );
                },
              );
            },
          );
        },
      );
    }
  }

  @override
  CatalogState get initialState => const CatalogInitial();
}

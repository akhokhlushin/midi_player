import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/features/player/data/datasources/audio_data_source.dart';
import 'package:midi_player/features/player/domain/entities/midi_event.dart';
import 'package:midi_player/features/player/domain/entities/music.dart';
import 'package:midi_player/features/player/domain/repositories/audio_data_repository.dart';
import 'package:rxdart/rxdart.dart';

class AudioDataRepositoryImpl extends AudioDataRepository {
  final AudioDataSource _dataSource;

  AudioDataRepositoryImpl(this._dataSource);

  Future<Either<Failure, T>> _handleCalls<T>(Future<T> Function() call) async {
    try {
      final result = await call();

      return Right(result);
    } catch (e) {
      return Left(
        Failure(
          message: 'Something went wrong! $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Music>> getMusic({int count}) {
    return _handleCalls<Music>(
      () => _dataSource.getMusic(count: count),
    );
  }

  @override
  Future<Either<Failure, Stream<MidiEventEntity>>> getMidiEventsStream(
      {String midiFilePath, BehaviorSubject<bool> playButton, bool refresh}) {
    return _handleCalls<Stream<MidiEventEntity>>(
      () => _dataSource.getMidiEventsStream(
        midiFilePath: midiFilePath,
        playButton: playButton,
        refresh: refresh,
      ),
    );
  }

  @override
  Future<Either<Failure, int>> getEventsAmount({String midiFilePath}) {
    return _handleCalls<int>(
      () => _dataSource.getEventsAmount(
        midiFilePath: midiFilePath,
      ),
    );
  }
}

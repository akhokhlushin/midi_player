import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/features/player/data/datasources/audio_data_source.dart';
import 'package:midi_player/features/player/domain/entities/player_data.dart';
import 'package:midi_player/features/player/domain/repositories/audio_data_repository.dart';

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
  Future<Either<Failure, PlayerData>> getMusic(
      {int count, String midiFilePath}) {
    return _handleCalls<PlayerData>(
      () => _dataSource.getMusic(
        count: count,
        midiFilePath: midiFilePath,
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

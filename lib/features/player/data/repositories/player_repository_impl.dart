import 'package:just_audio/just_audio.dart';
import 'package:midi_player/features/player/data/datasources/player_data_source.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';
import 'package:rxdart/rxdart.dart';

class PlayerRepositoryImpl extends PlayerRepository {
  final PlayerDataSource _dataSource;

  PlayerRepositoryImpl(this._dataSource);

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
  Future<Either<Failure, void>> pauseReplic() {
    return _handleCalls<void>(
      () => _dataSource.pauseReplic(),
    );
  }

  @override
  Future<Either<Failure, void>> playReplic(
      {int replicIndex, BehaviorSubject<double> volumeReplic}) {
    return _handleCalls<void>(
      () => _dataSource.playReplic(
        replicIndex: replicIndex,
        volumeReplic: volumeReplic,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> resumeReplic(
      {BehaviorSubject<double> volumeReplic}) {
    return _handleCalls<void>(
      () => _dataSource.resumeReplic(
        volumeReplic: volumeReplic,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> stopReplic() {
    return _handleCalls<void>(
      () => _dataSource.stopReplic(),
    );
  }

  @override
  Future<Either<Failure, PlayerState>> getAudioPlayerState() {
    return _handleCalls<PlayerState>(
      () => _dataSource.getAudioPlayerState(),
    );
  }

  @override
  Future<Either<Failure, void>> loadAllReplics({List<Replic> replics}) {
    return _handleCalls<void>(
      () => _dataSource.loadAllReplics(replics: replics),
    );
  }
}

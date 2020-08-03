import 'package:midi_player/features/player/data/datasources/player_data_source.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
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
  Future<Either<Failure, void>> playMusic(
      {String songPath,
      BehaviorSubject<double> volumeMusic,
      BehaviorSubject<bool> playButton}) {
    return _handleCalls<void>(
      () => _dataSource.playMusic(
        songPath: songPath,
        volumeMusic: volumeMusic,
        playButton: playButton,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> pause({
    BehaviorSubject<bool> playButton,
  }) {
    return _handleCalls<void>(
      () => _dataSource.pause(
        playButton: playButton,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> playReplics({
    List<Replic> replics,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<int> replicGap,
    BehaviorSubject<bool> playButton,
  }) async {
    try {
      final result = await _dataSource.playReplics(
        replicGap: replicGap,
        replics: replics,
        playButton: playButton,
        volumeReplic: volumeReplic,
      );

      return Right(result);
    } catch (e) {
      return Left(
        Failure(
          message: 'Something went wrong! $e',
        ),
      );
    }
  }
}

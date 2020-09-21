import 'package:midi_player/features/player/data/datasources/player_data_source.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/features/player/domain/entities/player_data.dart';
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
  Future<Either<Failure, void>> pause() {
    return _handleCalls<void>(
      () => _dataSource.pause(),
    );
  }

  @override
  Future<Either<Failure, void>> play() {
    return _handleCalls<void>(
      () => _dataSource.play(),
    );
  }

  @override
  Future<Either<Failure, void>> resume() {
    return _handleCalls<void>(
      () => _dataSource.resume(),
    );
  }

  @override
  Future<Either<Failure, void>> load({
    PlayerData data,
    BehaviorSubject<bool> playVariation,
    BehaviorSubject<int> gap,
    BehaviorSubject<double> volume,
  }) {
    return _handleCalls<void>(
      () => _dataSource.load(
        data: data,
        gap: gap,
        playVariation: playVariation,
        volume: volume,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> reset() {
    return _handleCalls<void>(
      () => _dataSource.reset(),
    );
  }
}

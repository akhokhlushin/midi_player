import 'package:flutter/cupertino.dart';
import 'package:midi_player/features/player/data/datasources/player_data_source.dart';
import 'package:midi_player/features/player/domain/entities/midi_event.dart';
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
  Future<Either<Failure, void>> play({
    List<Replic> replics,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<int> replicGap,
    BehaviorSubject<bool> playButton,
    String songPath,
    BehaviorSubject<double> volumeMusic,
    Stream<MidiEventEntity> onMidiEvents,
  }) async {
    return _handleCalls<void>(
      () => _dataSource.play(
        playButton: playButton,
        replicGap: replicGap,
        replics: replics,
        songPath: songPath,
        volumeMusic: volumeMusic,
        volumeReplic: volumeReplic,
        onMidiEvents: onMidiEvents,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> resume({
    @required String songPath,
    @required BehaviorSubject<double> volumeMusic,
    @required BehaviorSubject<bool> playButton,
    @required List<Replic> replics,
    @required BehaviorSubject<double> volumeReplic,
    @required BehaviorSubject<int> replicGap,
    @required Stream<MidiEventEntity> onMidiEvents,
  }) {
    return _handleCalls<void>(
      () => _dataSource.resume(
        playButton: playButton,
        replicGap: replicGap,
        replics: replics,
        songPath: songPath,
        volumeMusic: volumeMusic,
        volumeReplic: volumeReplic,
        onMidiEvents: onMidiEvents,
      ),
    );
  }
}

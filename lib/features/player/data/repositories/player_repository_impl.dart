
import 'package:midi_player/features/player/data/datasources/player_data_source.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';

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
  Future<Either<Failure, List<Duration>>> getTimeCodesFromMidiFile({String midiFilePath}) async {
    return _handleCalls<List<Duration>>(() => _dataSource.getTimeCodesFromMidiFile(midiFilePath: midiFilePath));
  }

  @override
  Future<Either<Failure, void>> playMusicAndReplics({List<Replic> replics, String songPath}) {
    return _handleCalls<void>(() => _dataSource.playMusicAndReplics(replics: replics, songPath: songPath));
  }
}

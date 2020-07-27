import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/features/player/data/datasources/midi_data_source.dart';
import 'package:midi_player/features/player/domain/repositories/midi_repository.dart';

class MidiRepositoryImpl extends MidiRepository {
  final MidiDataSource _dataSource;

  MidiRepositoryImpl(this._dataSource);

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
  Future<Either<Failure, List<Duration>>> getReplicDurations(
      {List<String> replicPaths}) {
    return _handleCalls<List<Duration>>(
      () => _dataSource.getReplicDurations(replicPaths: replicPaths),
    );
  }

  @override
  Future<Either<Failure, List<String>>> getReplicsPath({int count}) {
    return _handleCalls<List<String>>(
      () => _dataSource.getReplicsPath(count: count),
    );
  }

  @override
  Future<Either<Failure, List<List<Duration>>>> getTimeCodesFromMidiFile(
      {String midiFilePath}) {
    return _handleCalls<List<List<Duration>>>(
      () => _dataSource.getTimeCodesFromMidiFile(
        midiFilePath: midiFilePath,
      ),
    );
  }
}

import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/features/catalog/data/datasources/music_data_source.dart';
import 'package:midi_player/features/catalog/domain/entities/song.dart';
import 'package:midi_player/features/catalog/domain/repository/music_repository.dart';
import 'package:rxdart/rxdart.dart';

class MusicRepositoryImpl extends MusicRepository {
  final MusicDataSource _musicDataSource;

  MusicRepositoryImpl(this._musicDataSource);

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
  Future<Either<Failure, Stream<Duration>>> getOnDurationChangeStream() {
    return _handleCalls<Stream<Duration>>(
      () => _musicDataSource.getOnDurationChangeStream(),
    );
  }

  @override
  Future<Either<Failure, void>> pauseMusic() {
    return _handleCalls<void>(
      () => _musicDataSource.pauseMusic(),
    );
  }

  @override
  Future<Either<Failure, void>> playMusic({
    int songIndex,
    BehaviorSubject<double> volumeMusic,
  }) {
    return _handleCalls<void>(
      () => _musicDataSource.playMusic(
        songIndex: songIndex,
        volumeMusic: volumeMusic,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> resumeMusic(
      {BehaviorSubject<double> volumeMusic}) {
    return _handleCalls<void>(
      () => _musicDataSource.resumeMusic(
        volumeMusic: volumeMusic,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> stopMusic() {
    return _handleCalls<void>(
      () => _musicDataSource.stopMusic(),
    );
  }

  @override
  Future<Either<Failure, void>> loadAllMusics({List<Song> songs}) {
    return _handleCalls<void>(
      () => _musicDataSource.loadAllMusics(songs: songs),
    );
  }
}

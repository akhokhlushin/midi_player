import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/catalog/domain/repository/music_repository.dart';
import 'package:rxdart/rxdart.dart';

class ResumeMusic extends UseCase<void, ResumeMusicParams> {
  final MusicRepository _repository;

  ResumeMusic(this._repository);

  @override
  Future<Either<Failure, void>> call(ResumeMusicParams params) {
    return _repository.resumeMusic(
      volumeMusic: params.volume,
    );
  }
}

class ResumeMusicParams {
  final BehaviorSubject<double> volume;

  ResumeMusicParams({
    this.volume,
  });
}

import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/catalog/domain/repository/music_repository.dart';
import 'package:midi_player/features/catalog/domain/usecases/pause_music.dart';

class StopMusic extends UseCase<void, NoParams> {
  final MusicRepository _repository;

  StopMusic(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.stopMusic();
  }
}

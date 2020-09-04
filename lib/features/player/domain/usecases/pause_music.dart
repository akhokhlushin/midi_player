import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';

class PauseMusic extends UseCase<void, NoParams> {
  final PlayerRepository _repository;

  PauseMusic(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.pauseMusic();
  }
}

class NoParams {}

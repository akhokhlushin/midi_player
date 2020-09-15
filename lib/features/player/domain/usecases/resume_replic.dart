import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/catalog/domain/usecases/pause_music.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';

class ResumeReplic extends UseCase<void, NoParams> {
  final PlayerRepository _repository;

  ResumeReplic(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.resume();
  }
}

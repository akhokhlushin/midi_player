import 'package:just_audio/just_audio.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';
import 'package:midi_player/features/catalog/domain/usecases/pause_music.dart';

class GetAudioPlayerState extends UseCase<PlayerState, NoParams> {
  final PlayerRepository _repository;

  GetAudioPlayerState(this._repository);

  @override
  Future<Either<Failure, PlayerState>> call(NoParams params) {
    return _repository.getAudioPlayerState();
  }
}

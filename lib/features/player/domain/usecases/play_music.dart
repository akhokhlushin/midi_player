import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';
import 'package:rxdart/rxdart.dart';

class PlayMusic extends UseCase<void, PlayMusicParams> {
  final PlayerRepository _repository;

  PlayMusic(this._repository);

  @override
  Future<Either<Failure, void>> call(PlayMusicParams params) {
    return _repository.playMusic(
        songPath: params.songPath, volumeMusic: params.volume);
  }
}

class PlayMusicParams {
  final String songPath;
  final BehaviorSubject<double> volume;

  PlayMusicParams({this.songPath, this.volume});
}

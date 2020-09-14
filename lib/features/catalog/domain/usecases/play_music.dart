import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/catalog/domain/repository/music_repository.dart';
import 'package:rxdart/rxdart.dart';

class PlayMusic extends UseCase<void, PlayMusicParams> {
  final MusicRepository _repository;

  PlayMusic(this._repository);

  @override
  Future<Either<Failure, void>> call(PlayMusicParams params) {
    return _repository.playMusic(
      songIndex: params.songIndex,
      volumeMusic: params.volume,
    );
  }
}

class PlayMusicParams {
  final int songIndex;
  final BehaviorSubject<double> volume;

  PlayMusicParams({
    this.songIndex,
    this.volume,
  });
}

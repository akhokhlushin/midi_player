import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/entities/music.dart';
import 'package:midi_player/features/player/domain/repositories/audio_data_repository.dart';

class GetMusic extends UseCase<Music, GetMusicParams> {
  final AudioDataRepository _repository;

  GetMusic(this._repository);

  @override
  Future<Either<Failure, Music>> call(GetMusicParams params) {
    return _repository.getMusic(
      count: params.count,
    );
  }
}

class GetMusicParams {
  final int count;

  GetMusicParams({this.count});
}

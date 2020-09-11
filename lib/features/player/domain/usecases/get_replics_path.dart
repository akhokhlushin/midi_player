import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/entities/player_data.dart';
import 'package:midi_player/features/player/domain/repositories/audio_data_repository.dart';

class GetMusic extends UseCase<PlayerData, GetMusicParams> {
  final AudioDataRepository _repository;

  GetMusic(this._repository);

  @override
  Future<Either<Failure, PlayerData>> call(GetMusicParams params) {
    return _repository.getMusic(
      count: params.count,
      midiFilePath: params.midiFilePath,
    );
  }
}

class GetMusicParams {
  final int count;
  final String midiFilePath;

  GetMusicParams({this.count, this.midiFilePath});
}

import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';

class GetTimeCodesFromMidiFile extends UseCase<List<Duration>, GetTimeCodesFromMidiFileParams> {

  final PlayerRepository _repository;

  GetTimeCodesFromMidiFile(this._repository);

  @override
  Future<Either<Failure, List<Duration>>> call(GetTimeCodesFromMidiFileParams params) {
    return _repository.getTimeCodesFromMidiFile(midiFilePath: params.midiFilePath, songPath: params.songPath, songP: params.songP);
  }

}

class GetTimeCodesFromMidiFileParams {
  final String midiFilePath;
  final String songPath;
  final String songP;

  GetTimeCodesFromMidiFileParams({this.midiFilePath, this.songPath, this.songP});
}
import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';

class GetTimeCodesFromMidiFile extends UseCase<List<Duration>, String> {

  final PlayerRepository _repository;

  GetTimeCodesFromMidiFile(this._repository);

  @override
  Future<Either<Failure, List<Duration>>> call(String params) {
    return _repository.getTimeCodesFromMidiFile(midiFilePath: params);
  }

}
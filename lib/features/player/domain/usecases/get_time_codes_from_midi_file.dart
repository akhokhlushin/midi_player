import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/repositories/audio_data_repository.dart';

class GetTimeCodesFromMidiFile extends UseCase<List<List<Duration>>, String> {
  final AudioDataRepository _repository;

  GetTimeCodesFromMidiFile(this._repository);

  @override
  Future<Either<Failure, List<List<Duration>>>> call(String params) {
    return _repository.getTimeCodesFromMidiFile(midiFilePath: params);
  }
}

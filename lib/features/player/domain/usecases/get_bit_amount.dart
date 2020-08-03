import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/repositories/audio_data_repository.dart';

class GetBitAmount extends UseCase<int, String> {
  final AudioDataRepository _repository;

  GetBitAmount(this._repository);

  @override
  Future<Either<Failure, int>> call(String params) {
    return _repository.getBitAmount(midiFilePath: params);
  }
}

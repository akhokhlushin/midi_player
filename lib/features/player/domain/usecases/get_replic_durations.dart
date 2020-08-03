import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/repositories/audio_data_repository.dart';

class GetReplicsDurations extends UseCase<List<Duration>, List<String>> {
  final AudioDataRepository _repository;

  GetReplicsDurations(this._repository);

  @override
  Future<Either<Failure, List<Duration>>> call(List<String> params) {
    return _repository.getReplicDurations(replicPaths: params);
  }
}

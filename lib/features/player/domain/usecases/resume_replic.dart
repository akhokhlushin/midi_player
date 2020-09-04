import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';
import 'package:rxdart/rxdart.dart';

class ResumeReplic extends UseCase<void, BehaviorSubject<double>> {
  final PlayerRepository _repository;

  ResumeReplic(this._repository);

  @override
  Future<Either<Failure, void>> call(BehaviorSubject<double> params) {
    return _repository.resumeReplic(volumeReplic: params);
  }
}

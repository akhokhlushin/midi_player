import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';
import 'package:rxdart/rxdart.dart';

class PlayReplic extends UseCase<void, PlayReplicParams> {
  final PlayerRepository _repository;

  PlayReplic(this._repository);

  @override
  Future<Either<Failure, void>> call(PlayReplicParams params) {
    return _repository.playReplic(
        replicIndex: params.replicIndex, volumeReplic: params.volume);
  }
}

class PlayReplicParams {
  final int replicIndex;
  final BehaviorSubject<double> volume;

  PlayReplicParams({this.replicIndex, this.volume});
}

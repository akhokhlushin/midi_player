import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';

class LoadAllReplics extends UseCase<void, List<Replic>> {
  final PlayerRepository _playerRepository;

  LoadAllReplics(this._playerRepository);

  @override
  Future<Either<Failure, void>> call(List<Replic> params) async {
    return _playerRepository.loadAllReplics(replics: params);
  }
}

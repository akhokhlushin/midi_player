import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/entities/player_data.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';
import 'package:rxdart/rxdart.dart';

class Load extends UseCase<void, LoadParams> {
  final PlayerRepository _playerRepository;

  Load(this._playerRepository);

  @override
  Future<Either<Failure, void>> call(LoadParams params) async {
    return _playerRepository.load(
      data: params.data,
      gap: params.gap,
      playVariation: params.playVariation,
      volume: params.volume,
    );
  }
}

class LoadParams {
  final PlayerData data;
  final BehaviorSubject<bool> playVariation;
  final BehaviorSubject<int> gap;
  final BehaviorSubject<double> volume;

  LoadParams({this.data, this.playVariation, this.gap, this.volume});
}

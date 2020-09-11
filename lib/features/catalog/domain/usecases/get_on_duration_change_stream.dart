import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/catalog/domain/repository/music_repository.dart';
import 'package:midi_player/features/catalog/domain/usecases/pause_music.dart';

class GetOnDurationChangeStream extends UseCase<Stream<Duration>, NoParams> {
  final MusicRepository _catalogRepository;

  GetOnDurationChangeStream(this._catalogRepository);

  @override
  Future<Either<Failure, Stream<Duration>>> call(NoParams params) {
    return _catalogRepository.getOnDurationChangeStream();
  }
}

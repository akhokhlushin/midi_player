import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/catalog/domain/entities/song.dart';
import 'package:midi_player/features/catalog/domain/repository/catalog_repository.dart';
import 'package:midi_player/features/catalog/domain/usecases/pause_music.dart';

class GetSongs extends UseCase<List<Song>, NoParams> {
  final CatalogRepository _catalogRepository;

  GetSongs(this._catalogRepository);

  @override
  Future<Either<Failure, List<Song>>> call(NoParams params) {
    return _catalogRepository.getSongs();
  }
}

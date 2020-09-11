import 'package:dartz/dartz.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:midi_player/features/catalog/domain/entities/song.dart';

abstract class CatalogRepository {
  Future<Either<Failure, List<Song>>> getSongs();
}

import 'package:dartz/dartz.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:midi_player/features/catalog/data/datasources/catalog_data_source.dart';
import 'package:midi_player/features/catalog/domain/entities/song.dart';
import 'package:midi_player/features/catalog/domain/repository/catalog_repository.dart';

class CatalogRepositoryImpl extends CatalogRepository {
  final CatalogDataSource _catalogDataSource;

  CatalogRepositoryImpl(this._catalogDataSource);

  Future<Either<Failure, T>> _handleCalls<T>(Future<T> Function() call) async {
    try {
      final result = await call();

      return Right(result);
    } catch (e) {
      return Left(
        Failure(
          message: 'Something went wrong! $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Song>>> getSongs() {
    return _handleCalls<List<Song>>(() => _catalogDataSource.getSongs());
  }
}

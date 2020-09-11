part of 'catalog_bloc.dart';

abstract class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object> get props => [];
}

class CatalogInitial extends CatalogState {
  const CatalogInitial();
}

class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

class CatalogFailure extends CatalogState {
  final String message;

  const CatalogFailure(this.message);
}

class CatalogSuccess extends CatalogState {
  final List<Song> songs;
  final Stream<Duration> stream;

  const CatalogSuccess(this.songs, this.stream);
}

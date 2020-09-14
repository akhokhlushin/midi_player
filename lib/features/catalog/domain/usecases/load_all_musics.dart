import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/catalog/domain/entities/song.dart';
import 'package:midi_player/features/catalog/domain/repository/music_repository.dart';

class LoadAllMusics extends UseCase<void, List<Song>> {
  final MusicRepository _musicRepository;

  LoadAllMusics(this._musicRepository);

  @override
  Future<Either<Failure, void>> call(List<Song> params) async {
    return _musicRepository.loadAllMusics(songs: params);
  }
}

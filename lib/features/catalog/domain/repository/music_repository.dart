import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:midi_player/features/catalog/domain/entities/song.dart';
import 'package:rxdart/rxdart.dart';

abstract class MusicRepository {
  Future<Either<Failure, Stream<Duration>>> getOnDurationChangeStream();

  Future<Either<Failure, void>> stopMusic();

  Future<Either<Failure, void>> resumeMusic({
    @required BehaviorSubject<double> volumeMusic,
  });

  Future<Either<Failure, void>> playMusic({
    @required int songIndex,
    @required BehaviorSubject<double> volumeMusic,
  });

  Future<Either<Failure, void>> pauseMusic();

  Future<Either<Failure, void>> loadAllMusics({@required List<Song> songs});
}

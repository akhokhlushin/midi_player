import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:rxdart/rxdart.dart';

abstract class PlayerRepository {
  Future<Either<Failure, void>> playReplic({
    @required int replicIndex,
    @required BehaviorSubject<double> volumeReplic,
  });

  Future<Either<Failure, void>> pauseReplic();

  Future<Either<Failure, void>> resumeReplic({
    @required BehaviorSubject<double> volumeReplic,
  });

  Future<Either<Failure, void>> stopReplic();

  Future<Either<Failure, PlayerState>> getAudioPlayerState();

  Future<Either<Failure, void>> loadAllReplics(
      {@required List<Replic> replics});
}

import 'package:audioplayers/audioplayers.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:rxdart/rxdart.dart';

abstract class PlayerRepository {
  // Future<Either<Failure, void>> playMusic({
  //   @required String songPath,
  //   @required BehaviorSubject<double> volumeMusic,
  // });

  // Future<Either<Failure, void>> pauseMusic();

  // Future<Either<Failure, void>> resumeMusic({
  //   @required BehaviorSubject<double> volumeMusic,
  // });

  Future<Either<Failure, void>> playReplic({
    @required String replicPath,
    @required BehaviorSubject<double> volumeReplic,
  });

  Future<Either<Failure, void>> pauseReplic();

  Future<Either<Failure, void>> resumeReplic({
    @required BehaviorSubject<double> volumeReplic,
  });

  Future<Either<Failure, void>> stopReplic();

  // Future<Either<Failure, void>> stopMusic();

  Future<Either<Failure, AudioPlayerState>> getAudioPlayerState();
}

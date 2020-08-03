import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:rxdart/rxdart.dart';

abstract class PlayerRepository {
  Future<Either<Failure, void>> playMusic({
    @required String songPath,
    @required BehaviorSubject<double> volumeMusic,
    @required BehaviorSubject<bool> playButton,
  });

  Future<Either<Failure, void>> playReplics({
    @required List<Replic> replics,
    @required BehaviorSubject<double> volumeReplic,
    @required BehaviorSubject<int> replicGap,
    @required BehaviorSubject<bool> playButton,
  });

  Future<Either<Failure, void>> pause({
    @required BehaviorSubject<bool> playButton,
  });
}

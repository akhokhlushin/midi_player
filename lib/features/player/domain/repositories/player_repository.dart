import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:midi_player/features/player/domain/entities/player_data.dart';
import 'package:rxdart/rxdart.dart';

abstract class PlayerRepository {
  Future<Either<Failure, void>> play();

  Future<Either<Failure, void>> pause();

  Future<Either<Failure, void>> resume();

  Future<Either<Failure, void>> stop();

  Future<Either<Failure, void>> reset();

  Future<Either<Failure, void>> load({
    @required PlayerData data,
    @required BehaviorSubject<bool> playVariation,
    @required BehaviorSubject<int> gap,
    @required BehaviorSubject<double> volume,
  });
}

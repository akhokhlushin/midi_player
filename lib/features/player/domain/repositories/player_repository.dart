import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:midi_player/features/player/domain/entities/midi_event.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:rxdart/rxdart.dart';

abstract class PlayerRepository {
  Future<Either<Failure, void>> play({
    @required String songPath,
    @required BehaviorSubject<double> volumeMusic,
    @required BehaviorSubject<bool> playButton,
    @required List<Replic> replics,
    @required Stream<MidiEventEntity> onMidiEvents,
    @required BehaviorSubject<double> volumeReplic,
    @required BehaviorSubject<int> replicGap,
  });

  Future<Either<Failure, void>> pause({
    @required BehaviorSubject<bool> playButton,
  });

  Future<Either<Failure, void>> resume({
    @required String songPath,
    @required BehaviorSubject<double> volumeMusic,
    @required BehaviorSubject<bool> playButton,
    @required List<Replic> replics,
    @required Stream<MidiEventEntity> onMidiEvents,
    @required BehaviorSubject<double> volumeReplic,
    @required BehaviorSubject<int> replicGap,
  });
}

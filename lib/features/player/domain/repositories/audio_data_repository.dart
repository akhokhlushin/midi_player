import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:midi_player/features/player/domain/entities/midi_event.dart';
import 'package:midi_player/features/player/domain/entities/music.dart';
import 'package:rxdart/rxdart.dart';

abstract class AudioDataRepository {
  Future<Either<Failure, Stream<MidiEventEntity>>> getMidiEventsStream({
    @required String midiFilePath,
    @required BehaviorSubject<int> replicGap,
    @required BehaviorSubject<bool> playButton,
  });

  Future<Either<Failure, int>> getEventsAmount({
    @required String midiFilePath,
  });

  Future<Either<Failure, Music>> getMusic({
    @required int count,
    @required String midiFilePath,
  });
}

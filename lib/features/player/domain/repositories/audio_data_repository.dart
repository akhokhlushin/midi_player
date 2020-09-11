import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:midi_player/features/player/domain/entities/player_data.dart';

abstract class AudioDataRepository {
  Future<Either<Failure, int>> getEventsAmount({
    @required String midiFilePath,
  });

  Future<Either<Failure, PlayerData>> getMusic({
    @required int count,
    @required String midiFilePath,
  });
}

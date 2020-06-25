import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';

abstract class PlayerRepository {
  Future<Either<Failure, List<Duration>>> getTimeCodesFromMidiFile({
    @required String midiFilePath,
  });

  Future<Either<Failure, void>> playMusicAndReplics({
    @required List<Replic> replics,
    @required String songPath,
  });
}
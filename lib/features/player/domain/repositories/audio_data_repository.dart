import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:midi_player/core/errors/failures.dart';

abstract class AudioDataRepository {
  Future<Either<Failure, List<List<Duration>>>> getTimeCodesFromMidiFile({
    @required String midiFilePath,
  });

  Future<Either<Failure, int>> getBitAmount({
    @required String midiFilePath,
  });

  Future<Either<Failure, List<String>>> getReplicsPath({
    @required int count,
  });

  Future<Either<Failure, List<Duration>>> getReplicDurations({
    @required List<String> replicPaths,
  });
}

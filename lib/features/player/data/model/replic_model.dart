import 'package:flutter/material.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';

class ReplicModel extends Replic {
  final String replicPath;
  final Duration timeBefore;
  final Duration timeAfter;
  final Duration replicDuration;

  const ReplicModel({
    @required this.replicPath,
    @required this.timeBefore,
    @required this.timeAfter,
    @required this.replicDuration,
  }) : super(
          replicPath: replicPath,
          timeBefore: timeBefore,
          timeAfter: timeAfter,
          replicDuration: replicDuration,
        );
}

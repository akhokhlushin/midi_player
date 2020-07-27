import 'package:flutter/material.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';

class ReplicModel extends Replic {
  const ReplicModel({
    @required String replicPath,
    @required Duration timeBefore,
    @required Duration timeAfter,
    @required Duration replicDuration,
  }) : super(
          replicPath: replicPath,
          timeBefore: timeBefore,
          timeAfter: timeAfter,
          replicDuration: replicDuration,
        );
}

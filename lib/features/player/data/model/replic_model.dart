import 'package:flutter/material.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';

class ReplicModel extends Replic {
  final String replicPath;
  final Duration time;

  const ReplicModel({ @required this.replicPath, @required this.time }) : super(replicPath: replicPath, time: time);
}
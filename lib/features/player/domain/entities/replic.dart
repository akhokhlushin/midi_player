
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Replic extends Equatable {
  final String replicPath;
  final Duration time;

  const Replic({ @required this.replicPath, @required this.time });

  @override
  List<Object> get props => [replicPath, time];
}

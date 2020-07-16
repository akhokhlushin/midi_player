import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Replic extends Equatable {
  final String replicPath;
  final Duration timeBefore;
  final Duration timeAfter;

  const Replic(
      {@required this.replicPath,
      @required this.timeBefore,
      @required this.timeAfter});

  @override
  List<Object> get props => [replicPath, timeBefore, timeAfter];
}

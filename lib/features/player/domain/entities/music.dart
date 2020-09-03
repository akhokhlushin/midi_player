import 'package:equatable/equatable.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';

class Music extends Equatable {
  final List<Replic> replics;
  final int bitAmount;
  final Duration musicDuration;

  const Music({this.replics, this.bitAmount, this.musicDuration});

  @override
  List<Object> get props => [replics, bitAmount, musicDuration];
}

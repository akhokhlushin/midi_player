part of 'midi_bloc.dart';

abstract class MidiEvent extends Equatable {
  const MidiEvent();
}

class InitialiseMidi extends MidiEvent {
  final Song song;
  final BehaviorSubject<bool> playVariation;
  final BehaviorSubject<int> gap;
  final BehaviorSubject<double> volume;
  final int index;

  const InitialiseMidi({
    this.playVariation,
    this.gap,
    this.song,
    this.index,
    this.volume,
  });

  @override
  List<Object> get props => [
        song,
        index,
        playVariation,
        gap,
        volume,
      ];
}

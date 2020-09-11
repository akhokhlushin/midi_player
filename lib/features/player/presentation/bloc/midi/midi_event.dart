part of 'midi_bloc.dart';

abstract class MidiEvent extends Equatable {
  const MidiEvent();
}

class InitialiseMidi extends MidiEvent {
  final Song song;
  final int index;

  const InitialiseMidi({this.song, this.index});

  @override
  List<Object> get props => [song, index];
}

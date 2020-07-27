part of 'midi_bloc.dart';

abstract class MidiEvent extends Equatable {
  const MidiEvent();
}

class InitialiseMidi extends MidiEvent {
  final String midiFilePath;

  const InitialiseMidi(this.midiFilePath);

  @override
  List<Object> get props => [midiFilePath];
}

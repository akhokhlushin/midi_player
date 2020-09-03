part of 'midi_bloc.dart';

abstract class MidiEvent extends Equatable {
  const MidiEvent();
}

class InitialiseMidi extends MidiEvent {
  final String midiFilePath;
  final BehaviorSubject<bool> playButton;

  const InitialiseMidi({this.midiFilePath, this.playButton});

  @override
  List<Object> get props => [midiFilePath, playButton];
}

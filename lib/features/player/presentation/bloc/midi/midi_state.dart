part of 'midi_bloc.dart';

abstract class MidiState extends Equatable {
  const MidiState();
}

class MidiInitial extends MidiState {
  @override
  List<Object> get props => [];
}

class MidiLoading extends MidiState {
  @override
  List<Object> get props => [];
}

class MidiFailure extends MidiState {
  final String message;

  const MidiFailure(this.message);

  @override
  List<Object> get props => [message];
}

@immutable
class MidiSuccess extends MidiState {
  final PlayerData music;
  final Song song;
  final int index;

  const MidiSuccess(this.music, this.song, this.index);

  @override
  List<Object> get props => [music, song, index];
}

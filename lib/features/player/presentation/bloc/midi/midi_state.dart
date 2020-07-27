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

class MidiSuccess extends MidiState {
  final List<Replic> replics;

  const MidiSuccess(this.replics);

  @override
  List<Object> get props => [replics];
}

part of 'pause_bloc.dart';

abstract class PauseEvent extends Equatable {
  const PauseEvent();
}

class PauseE extends PauseEvent {
  final BehaviorSubject<bool> pause;

  const PauseE(this.pause);

  @override
  List<Object> get props => [pause];
}

class Restart extends PauseEvent {
  const Restart();

  @override
  List<Object> get props => [];
}

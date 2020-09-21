part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object> get props => [];
}

class PlayMusicE extends PlayerEvent {
  final int index;
  final BehaviorSubject<double> volume;

  const PlayMusicE({
    this.index,
    this.volume,
  });
}

class PlayReplicE extends PlayerEvent {}

class PauseE extends PlayerEvent {}

class ResumeMusicE extends PlayerEvent {
  final BehaviorSubject<double> volume;
  final void Function() afterPlaying;

  const ResumeMusicE({this.volume, this.afterPlaying});
}

class ResumeReplicE extends PlayerEvent {
  final BehaviorSubject<double> volume;

  const ResumeReplicE({this.volume});
}

class ResetE extends PlayerEvent {
  final int index;
  final BehaviorSubject<double> volume;

  const ResetE(this.index, this.volume);
}

part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object> get props => [];
}

class PlayMusicE extends PlayerEvent {
  final String songPath;
  final BehaviorSubject<double> volume;

  const PlayMusicE({this.songPath, this.volume});
}

class PlayReplicE extends PlayerEvent {
  final String replicPath;
  final BehaviorSubject<double> volume;
  final BehaviorSubject<bool> variousOfPlay;

  const PlayReplicE({this.replicPath, this.volume, this.variousOfPlay});
}

class PauseE extends PlayerEvent {}

class ResumeMusicE extends PlayerEvent {
  final BehaviorSubject<double> volume;

  const ResumeMusicE({this.volume});
}

class ResumeReplicE extends PlayerEvent {
  final BehaviorSubject<double> volume;

  const ResumeReplicE({this.volume});
}

class StopE extends PlayerEvent {}

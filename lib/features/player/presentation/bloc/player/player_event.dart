part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();
}

class Play extends PlayerEvent {
  final BehaviorSubject<double> volumeMusic;
  final BehaviorSubject<double> volumeReplic;
  final BehaviorSubject<int> replicGap;
  final BehaviorSubject<bool> player;
  final List<Replic> replics;
  final String songPath;

  const Play({
    this.volumeMusic,
    this.volumeReplic,
    this.replicGap,
    this.replics,
    this.songPath,
    this.player,
  });

  @override
  List<Object> get props => [
        volumeMusic,
        volumeReplic,
        replicGap,
        replics,
        songPath,
        player,
      ];
}

class PauseEvent extends PlayerEvent {
  final BehaviorSubject<bool> player;

  const PauseEvent({
    this.player,
  });

  @override
  List<Object> get props => [player];
}

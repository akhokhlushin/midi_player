part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();
}

class InitialisePlayer extends PlayerEvent {
  final String midiFilePath;
  final String songPath1;
  final String songPath2;
  final BehaviorSubject<double> volumeMusic;
  final BehaviorSubject<double> volumeReplic;
  final BehaviorSubject<double> replicGap;
  final BehaviorSubject<int> timeBeforeStream;
  final BehaviorSubject<int> timeAfterStream;

  const InitialisePlayer(
      {this.midiFilePath,
      this.songPath1,
      this.songPath2,
      this.volumeMusic,
      this.volumeReplic,
      this.replicGap,
      this.timeAfterStream,
      this.timeBeforeStream});

  @override
  List<Object> get props => [
        midiFilePath,
        songPath1,
        songPath2,
        volumeMusic,
        volumeReplic,
        replicGap,
        timeAfterStream,
        timeBeforeStream,
      ];
}

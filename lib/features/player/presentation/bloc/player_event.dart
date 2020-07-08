part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();
}

class InitialisePlayer extends PlayerEvent {

  final String midiFilePath;
  final String songPath1;
  final String songPath2;

  const InitialisePlayer(this.midiFilePath, this.songPath1, this.songPath2);

  @override
  List<Object> get props => [midiFilePath, songPath1, songPath2];
}

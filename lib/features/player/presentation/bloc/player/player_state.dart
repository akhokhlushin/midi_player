part of 'player_bloc.dart';

abstract class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object> get props => [];
}

class PlayerInitial extends PlayerState {}

class PlayerPlaying extends PlayerState {}

class PlayerFailure extends PlayerState {
  final String message;

  const PlayerFailure({this.message});

  @override
  List<Object> get props => [message];
}

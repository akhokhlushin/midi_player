part of 'player_bloc.dart';

abstract class PlayerState extends Equatable {
  const PlayerState();
}

class PlayerInitial extends PlayerState {
  @override
  List<Object> get props => [];
}

class PlayerFailure extends PlayerState {
  final String message;

  const PlayerFailure(this.message);

  @override
  List<Object> get props => [message];
}

part of 'refresh_bloc.dart';

abstract class RefreshState extends Equatable {
  const RefreshState();
  
  @override
  List<Object> get props => [];
}

class RefreshInitial extends RefreshState {}

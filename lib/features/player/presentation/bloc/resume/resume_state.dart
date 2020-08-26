part of 'resume_bloc.dart';

abstract class ResumeState extends Equatable {
  const ResumeState();
  
  @override
  List<Object> get props => [];
}

class ResumeInitial extends ResumeState {}

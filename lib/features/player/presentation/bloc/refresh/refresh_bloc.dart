import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'refresh_event.dart';
part 'refresh_state.dart';

class RefreshBloc extends Bloc<RefreshEvent, RefreshState> {
  RefreshBloc();

  @override
  Stream<RefreshState> mapEventToState(
    RefreshEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }

  @override
  RefreshState get initialState => RefreshInitial();
}

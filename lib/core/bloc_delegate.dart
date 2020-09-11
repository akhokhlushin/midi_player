import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    logger.d(event.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    logger.d(transition.toString());
    super.onTransition(bloc, transition);
  }
}

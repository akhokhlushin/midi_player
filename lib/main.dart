import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/midi/midi_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/pause/pause_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:midi_player/features/player/presentation/pages/player_page.dart';
import 'package:midi_player/injection_container.dart';

import 'features/player/presentation/bloc/resume/resume_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initialiseDependecies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PlayerBloc>(
          create: (context) => sl<PlayerBloc>(),
        ),
        BlocProvider<MidiBloc>(
          create: (context) => sl<MidiBloc>(),
        ),
        BlocProvider<PauseBloc>(
          create: (context) => sl<PauseBloc>(),
        ),
        BlocProvider<ResumeBloc>(
          create: (context) => sl<ResumeBloc>(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIDI Player',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PlayerPage(),
    );
  }
}

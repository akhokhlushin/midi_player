import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/midi/midi_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:midi_player/features/player/presentation/pages/player_page.dart';
import 'package:midi_player/injection_container.dart';

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

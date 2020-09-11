import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/core/bloc_delegate.dart';
import 'package:midi_player/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:midi_player/features/catalog/presentation/pages/catalog_page.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:midi_player/injection_container.dart';

import 'features/player/presentation/bloc/midi/midi_bloc.dart';
import 'features/player/presentation/pages/player_page.dart';

// Use of API
// TODO: Change code for getting and playing music from API
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  BlocSupervisor.delegate = SimpleBlocDelegate();

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
        BlocProvider<CatalogBloc>(
          create: (context) => sl<CatalogBloc>()..add(InitialiseCatalog()),
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
      theme: ThemeData.dark(),
      home: PlayerPage(),
      routes: {
        '/catalog': (context) => CatalogPage(),
      },
    );
  }
}

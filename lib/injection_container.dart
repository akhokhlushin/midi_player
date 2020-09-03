import 'package:audioplayers/audioplayers.dart';
import 'package:dart_midi/dart_midi.dart';
import 'package:get_it/get_it.dart';
import 'package:midi_player/features/player/data/datasources/audio_data_source.dart';
import 'package:midi_player/features/player/data/datasources/player_data_source.dart';
import 'package:midi_player/features/player/data/repositories/audio_data_repository_impl.dart';
import 'package:midi_player/features/player/data/repositories/player_repository_impl.dart';
import 'package:midi_player/features/player/domain/usecases/get_events_amount.dart';
import 'package:midi_player/features/player/domain/usecases/get_midi_events_stream.dart';
import 'package:midi_player/features/player/domain/usecases/get_replics_path.dart';
import 'package:midi_player/features/player/domain/usecases/pause.dart';
import 'package:midi_player/features/player/domain/usecases/play.dart';
import 'package:midi_player/features/player/domain/usecases/resume.dart';
import 'package:midi_player/features/player/presentation/bloc/pause/pause_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';

import 'features/player/presentation/bloc/midi/midi_bloc.dart';
import 'features/player/presentation/bloc/resume/resume_bloc.dart';

final GetIt sl = GetIt.instance;

void initialiseDependecies() {
  // Device permission
  sl.registerSingleton(AudioPlayer());
  sl.registerSingleton(MidiParser());

  sl.registerSingleton(
    PlayerDataSourceImpl(
      sl<AudioPlayer>(),
      sl<AudioPlayer>(),
    ),
  );

  sl.registerSingleton(
    AudioDataSourceImpl(
      sl<MidiParser>(),
    ),
  );

  sl.registerSingleton(
    PlayerRepositoryImpl(sl<PlayerDataSourceImpl>()),
  );

  sl.registerSingleton(
    AudioDataRepositoryImpl(sl<AudioDataSourceImpl>()),
  );

  sl.registerSingleton(Play(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(Pause(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(Resume(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(GetMidiEventsStream(sl<AudioDataRepositoryImpl>()));

  sl.registerSingleton(GetMusic(sl<AudioDataRepositoryImpl>()));

  sl.registerSingleton(GetMidiEventsAmount(sl<AudioDataRepositoryImpl>()));

  sl.registerSingleton(
    PlayerBloc(
      sl<Play>(),
    ),
  );

  sl.registerSingleton(
    PauseBloc(
      sl<Pause>(),
    ),
  );

  sl.registerSingleton(
    ResumeBloc(
      sl<Resume>(),
    ),
  );

  sl.registerSingleton(
    MidiBloc(
      sl<GetMusic>(),
      sl<GetMidiEventsStream>(),
      sl<GetMidiEventsAmount>(),
    ),
  );
}

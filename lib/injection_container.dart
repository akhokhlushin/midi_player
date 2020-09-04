import 'package:audioplayers/audioplayers.dart';
import 'package:dart_midi/dart_midi.dart';
import 'package:get_it/get_it.dart';
import 'package:midi_player/features/player/data/datasources/audio_data_source.dart';
import 'package:midi_player/features/player/data/datasources/player_data_source.dart';
import 'package:midi_player/features/player/data/repositories/audio_data_repository_impl.dart';
import 'package:midi_player/features/player/data/repositories/player_repository_impl.dart';
import 'package:midi_player/features/player/domain/usecases/get_audio_player_state.dart';
import 'package:midi_player/features/player/domain/usecases/get_events_amount.dart';
import 'package:midi_player/features/player/domain/usecases/get_replics_path.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';

import 'features/player/domain/usecases/pause_music.dart';
import 'features/player/domain/usecases/pause_replic.dart';
import 'features/player/domain/usecases/play_music.dart';
import 'features/player/domain/usecases/play_replic.dart';
import 'features/player/domain/usecases/resume_music.dart';
import 'features/player/domain/usecases/resume_replic.dart';
import 'features/player/domain/usecases/stop_music.dart';
import 'features/player/domain/usecases/stop_replic.dart';
import 'features/player/presentation/bloc/midi/midi_bloc.dart';

final GetIt sl = GetIt.instance;

void initialiseDependecies() {
  // Device permission
  sl.registerFactory(() => AudioPlayer());
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

  sl.registerSingleton(PlayMusic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(PauseMusic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(ResumeMusic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(PlayReplic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(PauseReplic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(ResumeReplic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(GetAudioPlayerState(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(StopReplic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(StopMusic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(GetMusic(sl<AudioDataRepositoryImpl>()));

  sl.registerSingleton(GetMidiEventsAmount(sl<AudioDataRepositoryImpl>()));

  sl.registerSingleton(
    PlayerBloc(
      sl<PlayMusic>(),
      sl<PlayReplic>(),
      sl<PauseMusic>(),
      sl<PauseReplic>(),
      sl<ResumeMusic>(),
      sl<ResumeReplic>(),
      sl<GetAudioPlayerState>(),
      sl<StopReplic>(),
      sl<StopMusic>(),
    ),
  );

  sl.registerSingleton(
    MidiBloc(
      sl<GetMusic>(),
      sl<GetMidiEventsAmount>(),
    ),
  );
}

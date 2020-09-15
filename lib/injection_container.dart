import 'package:dart_midi/dart_midi.dart';
import 'package:flutter_sound/flauto.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:midi_player/features/catalog/data/datasources/catalog_data_source.dart';
import 'package:midi_player/features/catalog/data/datasources/music_data_source.dart';
import 'package:midi_player/features/catalog/data/repositories/music_repository_impl.dart';
import 'package:midi_player/features/catalog/domain/usecases/get_on_duration_change_stream.dart';
import 'package:midi_player/features/catalog/domain/usecases/get_songs.dart';
import 'package:midi_player/features/catalog/domain/usecases/load_all_musics.dart';
import 'package:midi_player/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:midi_player/features/player/data/datasources/midi_controller.dart';
import 'package:midi_player/features/player/domain/usecases/load_all_replics.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';

import 'features/catalog/data/repositories/catalog_repository_impl.dart';
import 'features/catalog/domain/usecases/pause_music.dart';
import 'features/catalog/domain/usecases/play_music.dart';
import 'features/catalog/domain/usecases/resume_music.dart';
import 'features/catalog/domain/usecases/stop_music.dart';
import 'features/player/data/datasources/audio_data_source.dart';
import 'features/player/data/datasources/player_data_source.dart';
import 'features/player/data/repositories/audio_data_repository_impl.dart';
import 'features/player/data/repositories/player_repository_impl.dart';
import 'features/player/domain/usecases/get_events_amount.dart';
import 'features/player/domain/usecases/get_replics_path.dart';
import 'features/player/domain/usecases/pause_replic.dart';
import 'features/player/domain/usecases/play_replic.dart';
import 'features/player/domain/usecases/resume_replic.dart';
import 'features/player/domain/usecases/stop_replic.dart';
import 'features/player/presentation/bloc/midi/midi_bloc.dart';

final GetIt sl = GetIt.instance;

void initialiseDependecies() {
  // Device permission
  sl.registerSingleton(MidiParser());
  sl.registerSingleton(FlutterSoundHelper());
  sl.registerFactory(() => AudioPlayer());

  sl.registerSingleton(MidiController(
    sl<AudioPlayer>(),
  ));

  sl.registerSingleton(
    PlayerDataSourceImpl(
      sl<MidiController>(),
    ),
  );

  sl.registerSingleton(
    MusicDataSourceImpl(
      sl<AudioPlayer>(),
    ),
  );

  sl.registerSingleton(
    CatalogDataSourceImpl(
      sl<FlutterSoundHelper>(),
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
    CatalogRepositoryImpl(sl<CatalogDataSourceImpl>()),
  );

  sl.registerSingleton(
    AudioDataRepositoryImpl(sl<AudioDataSourceImpl>()),
  );

  sl.registerSingleton(
    MusicRepositoryImpl(
      sl<MusicDataSourceImpl>(),
    ),
  );

  sl.registerSingleton(LoadAllMusics(sl<MusicRepositoryImpl>()));

  sl.registerSingleton(Load(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(PlayMusic(sl<MusicRepositoryImpl>()));

  sl.registerSingleton(PauseMusic(sl<MusicRepositoryImpl>()));

  sl.registerSingleton(ResumeMusic(sl<MusicRepositoryImpl>()));

  sl.registerSingleton(PlayReplic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(PauseReplic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(ResumeReplic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(StopReplic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(StopMusic(sl<MusicRepositoryImpl>()));

  sl.registerSingleton(GetMusic(sl<AudioDataRepositoryImpl>()));

  sl.registerSingleton(GetMidiEventsAmount(sl<AudioDataRepositoryImpl>()));

  sl.registerSingleton(GetSongs(sl<CatalogRepositoryImpl>()));

  sl.registerSingleton(GetOnDurationChangeStream(sl<MusicRepositoryImpl>()));

  sl.registerSingleton(
    PlayerBloc(
      sl<PlayReplic>(),
      sl<PauseReplic>(),
      sl<ResumeReplic>(),
      sl<StopReplic>(),
      sl<PlayMusic>(),
      sl<PauseMusic>(),
      sl<ResumeMusic>(),
      sl<StopMusic>(),
    ),
  );

  sl.registerSingleton(
    MidiBloc(
      sl<GetMusic>(),
      sl<GetMidiEventsAmount>(),
      sl<Load>(),
    ),
  );

  sl.registerSingleton(
    CatalogBloc(
      sl<GetSongs>(),
      sl<GetOnDurationChangeStream>(),
      sl<LoadAllMusics>(),
    ),
  );
}

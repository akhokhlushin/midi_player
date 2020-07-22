import 'package:audioplayers/audioplayers.dart';
import 'package:dart_midi/dart_midi.dart';
import 'package:get_it/get_it.dart';
import 'package:midi_player/features/player/data/datasources/player_data_source.dart';
import 'package:midi_player/features/player/data/repositories/player_repository_impl.dart';
import 'package:midi_player/features/player/domain/usecases/get_replic_durations.dart';
import 'package:midi_player/features/player/domain/usecases/get_replics_path.dart';
import 'package:midi_player/features/player/domain/usecases/get_time_codes_from_midi_file.dart';
import 'package:midi_player/features/player/domain/usecases/play_music_and_replics.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:just_audio/just_audio.dart' as prefix;

final GetIt sl = GetIt.instance;

void initialiseDependecies() {
  // Device permission
  sl.registerFactory(() => AudioPlayer());
  sl.registerSingleton(MidiParser());
  sl.registerSingleton(prefix.AudioPlayer());

  sl.registerSingleton(
    PlayerDataSourceImpl(
      sl<MidiParser>(),
      sl<AudioPlayer>(),
      sl<AudioPlayer>(),
      sl<prefix.AudioPlayer>(),
    ),
  );

  sl.registerSingleton(
    PlayerRepositoryImpl(sl<PlayerDataSourceImpl>()),
  );

  sl.registerSingleton(GetTimeCodesFromMidiFile(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(PlayMusicAndReplics(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(GetReplicsPath(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(GetReplicsDurations(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(
    PlayerBloc(
      sl<GetTimeCodesFromMidiFile>(),
      sl<PlayMusicAndReplics>(),
      sl<GetReplicsPath>(),
      sl<GetReplicsDurations>(),
    ),
  );
}

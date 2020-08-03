import 'package:audioplayers/audioplayers.dart';
import 'package:dart_midi/dart_midi.dart';
import 'package:get_it/get_it.dart';
import 'package:midi_player/features/player/data/datasources/audio_data_source.dart';
import 'package:midi_player/features/player/data/datasources/player_data_source.dart';
import 'package:midi_player/features/player/data/repositories/audio_data_repository_impl.dart';
import 'package:midi_player/features/player/data/repositories/player_repository_impl.dart';
import 'package:midi_player/features/player/domain/usecases/get_bit_amount.dart';
import 'package:midi_player/features/player/domain/usecases/get_replic_durations.dart';
import 'package:midi_player/features/player/domain/usecases/get_replics_path.dart';
import 'package:midi_player/features/player/domain/usecases/get_time_codes_from_midi_file.dart';
import 'package:midi_player/features/player/domain/usecases/pause.dart';
import 'package:midi_player/features/player/domain/usecases/play_music.dart';
import 'package:midi_player/features/player/domain/usecases/play_replics.dart';
import 'package:midi_player/features/player/presentation/bloc/pause/pause_bloc.dart';
import 'package:midi_player/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:just_audio/just_audio.dart' as prefix;

import 'features/player/presentation/bloc/midi/midi_bloc.dart';

final GetIt sl = GetIt.instance;

void initialiseDependecies() {
  // Device permission
  sl.registerFactory(() => AudioPlayer());
  sl.registerSingleton(MidiParser());
  sl.registerSingleton(prefix.AudioPlayer());

  sl.registerSingleton(
    PlayerDataSourceImpl(
      sl<AudioPlayer>(),
      sl<AudioPlayer>(),
    ),
  );

  sl.registerSingleton(
    AudioDataSourceImpl(
      sl<MidiParser>(),
      sl<prefix.AudioPlayer>(),
    ),
  );

  sl.registerSingleton(
    PlayerRepositoryImpl(sl<PlayerDataSourceImpl>()),
  );

  sl.registerSingleton(
    AudioDataRepositoryImpl(sl<AudioDataSourceImpl>()),
  );

  sl.registerSingleton(PlayMusic(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(PlayReplics(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(Pause(sl<PlayerRepositoryImpl>()));

  sl.registerSingleton(GetTimeCodesFromMidiFile(sl<AudioDataRepositoryImpl>()));

  sl.registerSingleton(GetReplicsPath(sl<AudioDataRepositoryImpl>()));

  sl.registerSingleton(GetReplicsDurations(sl<AudioDataRepositoryImpl>()));

  sl.registerSingleton(GetBitAmount(sl<AudioDataRepositoryImpl>()));

  sl.registerSingleton(
    PlayerBloc(
      sl<PlayMusic>(),
      sl<PlayReplics>(),
    ),
  );

  sl.registerSingleton(
    PauseBloc(
      sl<Pause>(),
    ),
  );

  sl.registerSingleton(
    MidiBloc(
      sl<GetReplicsDurations>(),
      sl<GetReplicsPath>(),
      sl<GetTimeCodesFromMidiFile>(),
      sl<GetBitAmount>(),
    ),
  );
}

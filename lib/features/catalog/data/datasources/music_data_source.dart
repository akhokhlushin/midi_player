import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:midi_player/features/catalog/domain/entities/song.dart';
import 'package:rxdart/rxdart.dart';

abstract class MusicDataSource {
  // Starts playing music from assets (or from NOT IMPLEMENTED API)
  Future<void> playMusic({
    int songIndex,
    BehaviorSubject<double> volumeMusic,
  });

  // Pauses music in current location

  Future<void> pauseMusic();

  // Resumes music

  Future<void> resumeMusic({
    BehaviorSubject<double> volumeMusic,
  });

// Stops playing music

  Future<void> stopMusic();

  // Gets state of playing music

  Future<Stream<Duration>> getOnDurationChangeStream();

  Future<void> loadAllMusics({List<Song> songs});
}

class MusicDataSourceImpl extends MusicDataSource {
  final AudioPlayer _audioPlayer;

  // Use of API
  // TODO: Change code for getting and playing music from API

  MusicDataSourceImpl(
    this._audioPlayer,
  );

  @override
  Future<void> pauseMusic() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> playMusic({
    int songIndex,
    BehaviorSubject<double> volumeMusic,
  }) async {
    volumeMusic.listen((value) async {
      await _audioPlayer.setVolume(value);
    });

    final volume = volumeMusic.value;

    await _audioPlayer.seek(Duration.zero, index: songIndex);

    _audioPlayer.play();

    await _audioPlayer.setVolume(volume);
  }

  @override
  Future<void> resumeMusic({
    BehaviorSubject<double> volumeMusic,
  }) async {
    volumeMusic.listen((value) async {
      await _audioPlayer.setVolume(value);
    });

    _audioPlayer.play();
  }

  @override
  Future<void> stopMusic() async {
    await _audioPlayer.stop();
  }

  @override
  Future<Stream<Duration>> getOnDurationChangeStream() async {
    return _audioPlayer.durationStream;
  }

  @override
  Future<void> loadAllMusics({List<Song> songs}) async {
    await _audioPlayer.load(
      ConcatenatingAudioSource(
        children: songs
            .map(
              (e) => AudioSource.uri(
                Uri.parse(
                  'asset:///${e.path}',
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

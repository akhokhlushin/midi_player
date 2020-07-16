import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_midi/dart_midi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:rxdart/rxdart.dart';

abstract class PlayerDataSource {
  /// Gets time codes of every note from MIDI file
  Future<List<Duration>> getTimeCodesFromMidiFile(
      {String midiFilePath, String songPath});

  /// Playes all of replics in provided time
  /// Also sets volume which we get from stream
  Future<void> playMusicAndReplics({
    List<Replic> replics,
    String songPath,
    BehaviorSubject<double> volumeMusic,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<double> replicGap,
  });
}

class PlayerDataSourceImpl extends PlayerDataSource {
  final AudioPlayer _audioPlayer1;
  final AudioPlayer _audioPlayer2;
  final MidiParser _midiParser;
  AudioCache _audioCache1;
  AudioCache _audioCache2;

  PlayerDataSourceImpl(
      this._midiParser, this._audioPlayer1, this._audioPlayer2) {
    _audioCache1 = AudioCache(fixedPlayer: _audioPlayer1);
    _audioCache2 = AudioCache(fixedPlayer: _audioPlayer2);
  }

  @override
  Future<List<Duration>> getTimeCodesFromMidiFile(
      {String midiFilePath, String songPath}) async {
    final ByteData data = await rootBundle.load(midiFilePath);
    final List<int> buffer =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    final MidiFile midiFile = _midiParser.parseMidiFromBuffer(buffer);

    final List<Duration> durations = [];

    final List<MidiEvent> track = midiFile.tracks[midiFile.tracks.length - 1];

    int allTime = 0;

    for (int i = 0; i < track.length; i++) {
      final event = track[i];
      debugPrint(event.type);
      debugPrint(event.deltaTime.toString());

      if (event.type == 'noteOn' || event.type == 'noteOff') {
        allTime += event.deltaTime * 5;
        durations.add(
          Duration(
            milliseconds: event.deltaTime * 5,
          ),
        );
      }
    }

    print('------ All time of MIDI file: $allTime ------');

    return durations;
  }

  @override
  Future<void> playMusicAndReplics({
    List<Replic> replics,
    String songPath,
    BehaviorSubject<double> volumeMusic,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<double> replicGap,
  }) async {
    final streamMusic = volumeMusic.stream.listen((value) {
      _audioPlayer1.setVolume(value);
    });

    final streamReplic = volumeReplic.stream.listen((value) {
      _audioPlayer2.setVolume(value);
    });

    await _audioCache1.play(songPath);

    for (int i = 0; i < replics.length; i++) {
      final replic = replics[i];
      await Future.delayed(replic.timeBefore);
      await Future.delayed(
          Duration(milliseconds: (replicGap.value * 1000).toInt()));
      final volume = volumeReplic.value;
      await _audioCache2.play(replic.replicPath);
      await _audioPlayer2.setVolume(volume);
      await Future.delayed(replic.timeAfter);
    }

    await streamMusic.cancel();
    await streamReplic.cancel();
    return _audioPlayer1.stop();
  }
}

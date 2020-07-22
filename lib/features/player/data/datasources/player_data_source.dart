import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_midi/dart_midi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart' as prefix;

abstract class PlayerDataSource {
  /// Gets time codes of every note from MIDI file
  Future<List<List<Duration>>> getTimeCodesFromMidiFile(
      {String midiFilePath, String songPath});

  /// Playes all of replics in provided time
  /// Also sets volume which we get from stream
  /// And sets avaliable replic duration
  Future<void> playMusicAndReplics({
    List<Replic> replics,
    String songPath,
    BehaviorSubject<double> volumeMusic,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<double> replicGap,
    BehaviorSubject<int> timeBeforeStream,
    BehaviorSubject<int> timeAfterStream,
  });

  /// Gets replics paths from APIs
  Future<List<String>> getReplicsPath({
    int count,
  });

  /// Gets replic duration via its paths
  Future<List<Duration>> getReplicDurations({
    @required List<String> replicPaths,
  });
}

class PlayerDataSourceImpl extends PlayerDataSource {
  final AudioPlayer _audioPlayer1;
  final AudioPlayer _audioPlayer2;
  final MidiParser _midiParser;
  final prefix.AudioPlayer _duration;
  AudioCache _audioCache1;
  AudioCache _audioCache2;

  PlayerDataSourceImpl(
    this._midiParser,
    this._audioPlayer1,
    this._audioPlayer2,
    this._duration,
  ) {
    _audioCache1 = AudioCache(fixedPlayer: _audioPlayer1);
    _audioCache2 = AudioCache(fixedPlayer: _audioPlayer2);
  }

  @override
  Future<List<List<Duration>>> getTimeCodesFromMidiFile(
      {String midiFilePath, String songPath}) async {
    final ByteData data = await rootBundle.load(midiFilePath);
    final List<int> buffer =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    final MidiFile midiFile = _midiParser.parseMidiFromBuffer(buffer);

    final List<List<Duration>> durations = [];

    final List<MidiEvent> track = midiFile.tracks[midiFile.tracks.length - 1];

    for (int i = 0; i < track.length - 1; i++) {
      final eventNoteOn = track[i];
      final eventNoteOff = track[i + 1];
      if (eventNoteOn.type == 'noteOn') {
        durations.add(
          [
            Duration(milliseconds: eventNoteOn.deltaTime * 5),
            Duration(milliseconds: eventNoteOff.deltaTime * 5),
          ],
        );
      }
    }

    return durations;
  }

  @override
  Future<void> playMusicAndReplics({
    List<Replic> replics,
    String songPath,
    BehaviorSubject<double> volumeMusic,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<double> replicGap,
    BehaviorSubject<int> timeBeforeStream,
    BehaviorSubject<int> timeAfterStream,
  }) async {
    final streamMusic = volumeMusic.stream.listen((value) {
      _audioPlayer1.setVolume(value);
    });

    final streamReplic = volumeReplic.stream.listen((value) {
      _audioPlayer2.setVolume(value);
    });

    await _audioCache1.loop(songPath);

    print('play');

    for (int i = 0; i < replics.length; i++) {
      final replic = replics[i];

      timeBeforeStream.add(replic.timeBefore.inMilliseconds);

      timeAfterStream.add(replic.timeAfter.inMilliseconds);

      for (int count = 0; count <= replicGap.value; count++) {
        if (count == replicGap.value) {
          print(count);
          await Future.delayed(replic.timeBefore);

          final volume = volumeReplic.value;

          await _audioCache2.play(replic.replicPath);

          await _audioPlayer2.setVolume(volume);
          await Future.delayed(replic.timeAfter);

          break;
        } else {
          print(count);
          await Future.delayed(replic.timeBefore);
          await Future.delayed(replic.replicDuration);
          await Future.delayed(replic.timeAfter);
        }
      }
    }

    await streamMusic.cancel();
    await streamReplic.cancel();
    return _audioPlayer1.stop();
  }

  @override
  Future<List<Duration>> getReplicDurations({List<String> replicPaths}) async {
    final List<Duration> durations = [];

    for (int i = 0; i < replicPaths.length; i++) {
      final duration = await _duration.setAsset('assets/${replicPaths[i]}');

      print(duration);

      durations.add(duration);
    }

    return durations;
  }

  @override
  Future<List<String>> getReplicsPath({int count}) async {
    // Fake API
    return List.generate(count, (index) => 'replics/replic.mp3');
  }
}

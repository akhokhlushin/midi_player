import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_midi/dart_midi.dart';
import 'package:flutter/services.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';

abstract class PlayerDataSource {
  /// Gets time codes of every note from MIDI file
  Future<List<Duration>> getTimeCodesFromMidiFile(
      {String midiFilePath, String songPath});

  /// Playes all of replics in provided time
  Future<void> playMusicAndReplics({List<Replic> replics, String songPath});
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

    final MidiHeader header = midiFile.header;

    final List<Duration> durations = [Duration.zero];

    final List<MidiEvent> track = midiFile.tracks[midiFile.tracks.length - 1];

    for (int i = 0; i < track.length; i++) {
      final event = track[i];

      int time = 0;

      if (event.type == 'noteOn') {
        time = event.deltaTime * 10;
      } else if (event.type == 'noteOff') {
        durations.add(
          Duration(
            milliseconds:
                ((header.ticksPerBeat * 10) + (event.deltaTime * 10) + time) *
                    5,
          ),
        );
      }
    }

    return durations;
  }

  @override
  Future<void> playMusicAndReplics(
      {List<Replic> replics, String songPath}) async {
    _audioCache1.play(songPath);

    for (int i = 0; i < replics.length; i++) {
      final replic = replics[i];
      await Future.delayed(replic.time, () async {
        await _audioPlayer1.setVolume(.6);
        await _audioCache2.play(replic.replicPath);
        await _audioPlayer1.setVolume(1);
      });
    }

    _audioPlayer1.stop();
  }
}

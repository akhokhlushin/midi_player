
import 'package:audioplayers/audio_cache.dart';
import 'package:dart_midi/dart_midi.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';

abstract class PlayerDataSource {
  /// Gets time codes of every note from MIDI file
  Future<List<Duration>> getTimeCodesFromMidiFile({String midiFilePath, String songPath, String songP});
  /// Playes all of replics in provided time
  Future<void> playMusicAndReplics({List<Replic> replics, String songPath});
}


class PlayerDataSourceImpl extends PlayerDataSource {

  final AudioCache _audioPlayer1;
  final AudioCache _audioPlayer2;
  final MidiParser _midiParser;
  final AudioPlayer _duration;

  PlayerDataSourceImpl(this._midiParser, this._audioPlayer1, this._audioPlayer2, this._duration);

  @override
  Future<List<Duration>> getTimeCodesFromMidiFile({String midiFilePath, String songPath, String songP}) async {

    final duration = await _duration.setAsset(songPath);

    final ByteData data = await rootBundle.load(midiFilePath);
    final List<int> buffer = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // final File file = File(midiFilePath);

    final MidiFile midiFile = _midiParser.parseMidiFromBuffer(buffer);

    final List<Duration> durations = [ Duration.zero ];

    final tracks = midiFile.tracks[0];


    for(int i = 0; i < tracks.length; i++) {
      durations.add(
        Duration(milliseconds: (duration.inMilliseconds / tracks.length).floor()),
      );
    }

    return durations;

  }

  @override
  Future<void> playMusicAndReplics({List<Replic> replics, String songPath}) async {
    _audioPlayer1.play(songPath);
    
    for (int i = 0; i < replics.length; i++) {
      final replic = replics[i];
      await Future.delayed(replic.time, () {
        _audioPlayer2.play(replic.replicPath);
      });
    }
  }

}


import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dart_midi/dart_midi.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';

abstract class PlayerDataSource {
  /// Gets time codes of every note from MIDI file
  Future<List<Duration>> getTimeCodesFromMidiFile({String midiFilePath});
  /// Playes all of replics in provided time
  Future<void> playMusicAndReplics({List<Replic> replics, String songPath});
}


class PlayerDataSourceImpl extends PlayerDataSource {

  final AudioPlayer _audioPlayer1;
  final AudioPlayer _audioPlayer2;
  final MidiParser _midiParser;

  PlayerDataSourceImpl(this._midiParser, this._audioPlayer1, this._audioPlayer2);

  @override
  Future<List<Duration>> getTimeCodesFromMidiFile({String midiFilePath}) async {

    final File file = File(midiFilePath);

    final MidiFile midiFile = _midiParser.parseMidiFromFile(file);

    List<Duration> durations = [];

    final tracks = midiFile.tracks[0];


    for(int i = 0; i < tracks.length; i++) {
      final track = tracks[i];

      durations.add(
        Duration(milliseconds: track.deltaTime),
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
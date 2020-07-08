import 'package:audioplayers/audio_cache.dart';
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
  final AudioCache _audioPlayer1;
  final AudioCache _audioPlayer2;
  final MidiParser _midiParser;

  PlayerDataSourceImpl(
      this._midiParser, this._audioPlayer1, this._audioPlayer2);

  @override
  Future<List<Duration>> getTimeCodesFromMidiFile(
      {String midiFilePath, String songPath}) async {
    final ByteData data = await rootBundle.load(midiFilePath);
    final List<int> buffer =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    final MidiFile midiFile = _midiParser.parseMidiFromBuffer(buffer);

    final MidiHeader header = midiFile.header;

    print(header.format);
    print(header.framesPerSecond);
    print(header.numTracks);
    print(header.ticksPerBeat);
    print(header.ticksPerFrame);
    print(header.timeDivision);

    final List<Duration> durations = [];

    final List<MidiEvent> track = midiFile.tracks[midiFile.tracks.length - 1];

    for (int i = 0; i < track.length; i++) {
      final event = track[i];

      print(event.deltaTime);
      print(event.lastEventTypeByte);
      print(event.meta);
      print(event.running);
      print(event.type);
      print(event.useByte9ForNoteOff);

      if (event.type == 'noteOn') {
        durations.add(
          Duration(
            milliseconds: header.ticksPerBeat * 10,
          ),
        );
      }
    }

    return durations;
  }

  @override
  Future<void> playMusicAndReplics(
      {List<Replic> replics, String songPath}) async {
    _audioPlayer1.play(songPath);

    for (int i = 0; i < replics.length; i++) {
      final replic = replics[i];
      await Future.delayed(replic.time, () {
        _audioPlayer2.play(replic.replicPath);
      });
    }
  }
}

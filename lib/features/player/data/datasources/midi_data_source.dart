import 'package:dart_midi/dart_midi.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

abstract class MidiDataSource {
  /// Gets time codes of every note from MIDI file
  Future<List<List<Duration>>> getTimeCodesFromMidiFile({String midiFilePath});

  /// Gets replics paths from APIs
  Future<List<String>> getReplicsPath({
    int count,
  });

  /// Gets replic duration via its paths
  Future<List<Duration>> getReplicDurations({
    List<String> replicPaths,
  });
}

class MidiDataSourceImpl extends MidiDataSource {
  final MidiParser _midiParser;
  final AudioPlayer _duration;

  MidiDataSourceImpl(this._midiParser, this._duration);

  @override
  Future<List<Duration>> getReplicDurations({List<String> replicPaths}) async {
    final List<Duration> durations = [];

    for (int i = 0; i < replicPaths.length; i++) {
      final duration = await _duration.setAsset('assets/${replicPaths[i]}');

      durations.add(duration);
    }

    return durations;
  }

  @override
  Future<List<String>> getReplicsPath({int count}) async {
    // Fake API
    return List.generate(count, (index) => 'replics/replic.mp3');
  }

  @override
  Future<List<List<Duration>>> getTimeCodesFromMidiFile(
      {String midiFilePath}) async {
    final ByteData data = await rootBundle.load(midiFilePath);
    final List<int> buffer =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    final MidiFile midiFile = _midiParser.parseMidiFromBuffer(buffer);

    final MidiHeader header = midiFile.header;

    final List<List<Duration>> durations = [];

    final List<MidiEvent> track = midiFile.tracks[midiFile.tracks.length - 1];

    for (int i = 0; i < track.length - 1; i++) {
      final eventNoteOn = track[i];
      final eventNoteOff = track[i + 1];
      if (eventNoteOn.type == 'noteOn') {
        durations.add(
          [
            Duration(
                milliseconds:
                    (eventNoteOn.deltaTime * 5 / (header.ticksPerBeat / 100))
                        .floor()),
            Duration(
                milliseconds:
                    (eventNoteOff.deltaTime * 5 / (header.ticksPerBeat / 100))
                        .floor()),
          ],
        );
      }
    }

    return durations;
  }
}

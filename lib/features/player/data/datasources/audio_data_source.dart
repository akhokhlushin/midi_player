import 'package:dart_midi/dart_midi.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

abstract class AudioDataSource {
  /// Gets time codes of every note from MIDI file
  Future<List<List<Duration>>> getTimeCodesFromMidiFile({String midiFilePath});

  /// Gets replics paths from APIs
  Future<List<String>> getReplicsPath({
    int count,
  });

  /// Gets [List] of [Duration] of music
  Future<List<Duration>> getReplicDurations({
    List<String> replicPaths,
  });

  /// Gets amount of bit from MIDI file
  Future<int> getBitAmount({String midiFilePath});
}

class AudioDataSourceImpl extends AudioDataSource {
  final MidiParser _midiParser;
  final AudioPlayer _duration;

  AudioDataSourceImpl(this._midiParser, this._duration);

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
    final MidiFile midiFile = await _readMIDIFile(midiFilePath);

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

  @override
  Future<int> getBitAmount({String midiFilePath}) async {
    final MidiFile midiFile = await _readMIDIFile(midiFilePath);

    final MidiHeader header = midiFile.header;

    final List<MidiEvent> track = midiFile.tracks[midiFile.tracks.length - 1];

    int tickAmount = 0;

    for (int i = 0; i < track.length - 1; i++) {
      final eventNoteOn = track[i];
      final eventNoteOff = track[i + 1];
      if (eventNoteOn.type == 'noteOn') {
        tickAmount += eventNoteOn.deltaTime + eventNoteOff.deltaTime;
      }
    }

    return (tickAmount / header.ticksPerBeat).floor();
  }

  Future<MidiFile> _readMIDIFile(String midiFilePath) async {
    final ByteData data = await rootBundle.load(midiFilePath);
    final List<int> buffer =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    final MidiFile midiFile = _midiParser.parseMidiFromBuffer(buffer);

    return midiFile;
  }
}

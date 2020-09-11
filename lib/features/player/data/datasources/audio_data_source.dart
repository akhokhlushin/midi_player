import 'dart:async';

import 'package:dart_midi/dart_midi.dart';
import 'package:flutter/services.dart';
import 'package:midi_player/core/constants.dart';
import 'package:midi_player/features/player/domain/entities/player_data.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';

abstract class AudioDataSource {
  /// Gets amount of MIDI events from MIDI file
  Future<int> getEventsAmount({
    String midiFilePath,
  });

  /// Gets all proper info about music from MIDI file and replics mp3 files
  Future<PlayerData> getMusic({
    int count,
    String midiFilePath,
  });
}

class AudioDataSourceImpl extends AudioDataSource {
  final MidiParser _midiParser;
  AudioDataSourceImpl(this._midiParser);

  // Use of API
  // TODO: Change code for getting and playing music from API

  @override
  Future<int> getEventsAmount({String midiFilePath}) async {
    final MidiFile midiFile = await _readMIDIFile(midiFilePath);

    final List<MidiEvent> track = midiFile.tracks.last;

    int result = 0;

    for (int i = 0; i < track.length - 1; i++) {
      final eventNoteOn = track[i];
      if (eventNoteOn.type == 'noteOn') {
        result++;
      }
    }

    return result;
  }

  @override
  Future<PlayerData> getMusic({int count, String midiFilePath}) async {
    final MidiFile midiFile = await _readMIDIFile(midiFilePath);

    final List<List<Duration>> durations = _getTimeCodesList(midiFile);

    Duration allMidiDuration = Duration.zero;

    for (final duration in durations) {
      allMidiDuration += duration[0] + duration[1];
    }

    final List<String> paths = await _getReplicsPath(count: count);

    final bitAmount = await _getBitAmount(midiFilePath: midiFilePath);

    final List<Replic> replics = List.generate(
      count,
      (index) => Replic(
        replicPath: paths[index],
        timeBefore: durations[index][0],
        timeAfter: durations[index][1],
      ),
    );

    final PlayerData music = PlayerData(
      bitAmount: bitAmount,
      replics: replics,
      midiFileDuration: allMidiDuration,
    );

    return music;
  }

  int lastReplic = 0;

  Future<List<String>> _getReplicsPath({int count}) async {
    // Fake API
    return List.generate(count, (index) => tReplicPath);
  }

  Future<int> _getBitAmount({String midiFilePath}) async {
    final MidiFile midiFile = await _readMIDIFile(midiFilePath);

    final MidiHeader header = midiFile.header;

    final List<MidiEvent> track = midiFile.tracks.last;

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
    // Use of API
    // TODO: Change code for getting and playing music from API
    final ByteData data = await rootBundle.load(midiFilePath);
    final List<int> buffer =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    final MidiFile midiFile = _midiParser.parseMidiFromBuffer(buffer);

    return midiFile;
  }

  List<List<Duration>> _getTimeCodesList(MidiFile midiFile) {
    final MidiHeader header = midiFile.header;

    final List<List<Duration>> durations = [];

    final List<MidiEvent> track = midiFile.tracks.last;

    for (int i = 0; i < track.length - 1; i++) {
      final eventNoteOn = track[i];
      final eventNoteOff = track[i + 1];
      if (eventNoteOn.type == 'noteOn') {
        final timeBefore = Duration(
            milliseconds:
                (eventNoteOn.deltaTime * 5 / (header.ticksPerBeat / 100))
                    .floor());

        final timeAfter = Duration(
            milliseconds:
                (eventNoteOff.deltaTime * 5 / (header.ticksPerBeat / 100))
                    .floor());

        durations.add([timeBefore, timeAfter]);
      }
    }

    return durations;
  }
}

import 'dart:async';

import 'package:dart_midi/dart_midi.dart';
import 'package:flutter/services.dart';
import 'package:midi_player/core/constants.dart';
import 'package:midi_player/features/player/domain/entities/midi_event.dart';
import 'package:midi_player/features/player/domain/entities/music.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:rxdart/rxdart.dart';

abstract class AudioDataSource {
  /// Gets stream, which reacts on midi event
  /// If refresh == true, its starts stream again
  Future<Stream<MidiEventEntity>> getMidiEventsStream(
      {String midiFilePath, BehaviorSubject<bool> playButton, bool refresh});

  /// Gets amount of MIDI events from MIDI file
  Future<int> getEventsAmount({
    String midiFilePath,
  });

  /// Gets all proper info about music from MIDI file and replics mp3 files
  Future<Music> getMusic({
    int count,
  });
}

class AudioDataSourceImpl extends AudioDataSource {
  final MidiParser _midiParser;

  AudioDataSourceImpl(this._midiParser);

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
  Future<Music> getMusic({int count}) async {
    final MidiFile midiFile = await _readMIDIFile(midiFilePath);

    final List<List<Duration>> durations = _getTimeCodesList(midiFile);

    Duration allDuration = Duration.zero;

    for (final duration in durations) {
      allDuration += duration[0] + duration[1];
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

    final Music music = Music(
      bitAmount: bitAmount,
      replics: replics,
      musicDuration: allDuration,
    );

    return music;
  }

  int lastReplic = 0;

  @override
  Future<Stream<MidiEventEntity>> getMidiEventsStream(
      {String midiFilePath,
      BehaviorSubject<bool> playButton,
      bool refresh}) async {
    final MidiFile midiFile = await _readMIDIFile(midiFilePath);

    final List<List<Duration>> durations = _getTimeCodesList(midiFile);

    if (refresh) {
      lastReplic = 0;
    }

    return _getOnEventStream(durations, playButton, refresh);
  }

  Stream<MidiEventEntity> _getOnEventStream(List<List<Duration>> durations,
      BehaviorSubject<bool> playButton, bool refresh) async* {
    bool restart = true;
    for (int i = lastReplic; i < durations.length; i++) {
      lastReplic = i;

      if (playButton.value) {
        break;
      }

      await Future.delayed(durations[i][0]);

      if (playButton.value) {
        break;
      }

      yield MidiEventEntity();

      if (playButton.value) {
        break;
      }

      await Future.delayed(durations[i][1]);

      if (playButton.value) {
        break;
      }

      if (i == durations.length - 1) {
        restart = false;
        lastReplic = 0;
      }
    }

    if (restart && !refresh) {
      await _waitForValueChange(playButton);
      yield* _getOnEventStream(durations, playButton, false);
    }
  }

  Future<void> _waitForValueChange(BehaviorSubject<bool> playButton) async {
    final Completer completer = Completer();

    playButton.listen((value) {
      if (!value) {
        completer.complete();
      }
    });

    return completer.future;
  }

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

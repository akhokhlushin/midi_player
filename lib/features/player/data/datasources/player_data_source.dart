import 'dart:async';

import 'package:midi_player/features/player/data/datasources/midi_controller.dart';
import 'package:midi_player/features/player/domain/entities/player_data.dart';
import 'package:rxdart/rxdart.dart';

abstract class PlayerDataSource {
  /// Starts playing replic from assets
  Future<void> play();

  /// Pauses replic in current location
  Future<void> pause();

  /// Resumes replic
  Future<void> resume();

  /// Stops playing replic
  Future<void> stop();

  /// Resets all position and start playing from start
  Future<void> reset();

  /// Set ups all ready to play
  Future<void> load({
    PlayerData data,
    BehaviorSubject<bool> playVariation,
    BehaviorSubject<int> gap,
    BehaviorSubject<double> volume,
  });
}

class PlayerDataSourceImpl extends PlayerDataSource {
  final MidiController _midiController;

  // Use of API
  // TODO: Change code for getting and playing music from API

  PlayerDataSourceImpl(
    this._midiController,
  );

  @override
  Future<void> pause() async {
    await _midiController.pause();
  }

  @override
  Future<void> play() async {
    await _midiController.play();
  }

  @override
  Future<void> resume() async {
    await _midiController.resume();
  }

  @override
  Future<void> stop() async {
    await _midiController.pause();
  }

  @override
  Future<void> load({
    PlayerData data,
    BehaviorSubject<bool> playVariation,
    BehaviorSubject<int> gap,
    BehaviorSubject<double> volume,
  }) async {
    return _midiController.setup(
      data: data,
      playVariation: playVariation,
      gap: gap,
      volume: volume,
    );
  }

  @override
  Future<void> reset() async {
    await _midiController.reset();
  }
}

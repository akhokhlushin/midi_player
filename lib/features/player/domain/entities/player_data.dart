import 'package:equatable/equatable.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';

// ignore: must_be_immutable
class PlayerData extends Equatable {
  final List<Replic> replics;
  final int bitAmount;
  final Duration midiFileDuration;
  List<int> _borders = [];
  List<int> bordersForUI = [];
  List<int> _borders2 = [];
  List<int> _borders4 = [];
  List<int> _borders5 = [];

  PlayerData({
    this.replics,
    this.bitAmount,
    this.midiFileDuration,
  }) {
    _borders = List<int>.generate(replics.length, (index) => index);

    Duration d = Duration.zero;

    for (int i = 0; i < replics.length; i++) {
      if (i == 0) {
        d += replics[i].timeBefore;
      } else {
        d += replics[i - 1].timeAfter + replics[i].timeBefore;
      }
      bordersForUI.add(
          (bitAmount * (d.inMilliseconds / midiFileDuration.inMilliseconds))
              .floor());
    }
    final listFor4 = [
      _borders[0],
    ];
    for (int i = 1; i < _borders.length; i++) {
      if ((i + 1) % 4 != 0) {
        listFor4.add(_borders[i]);
      }
    }

    final listFor2 = [
      _borders[0],
    ];
    for (int i = 0; i < _borders.length; i++) {
      if ((i + 1) % 2 != 0) {
        listFor2.add(_borders[i]);
      }
    }

    final List<int> listFor5 = [
      _borders[0],
    ];
    for (int i = 0; i < _borders.length; i++) {
      if ((i + 1) % 5 == 0) {
        listFor5.add(_borders[i]);
      }
    }

    _borders2 = listFor2;

    _borders4 = listFor4;

    _borders5 = listFor5;
  }

  List<int> getBordersByIndex(int index) {
    switch (index) {
      case 1:
        return _borders;
        break;
      case 4:
        return _borders4;
        break;
      case 2:
        return _borders2;
        break;
      case 5:
        return _borders5;

        break;
      default:
        return _borders;
    }
  }

  @override
  List<Object> get props => [replics, bitAmount, midiFileDuration, _borders];
}

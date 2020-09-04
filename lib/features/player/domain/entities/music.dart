import 'package:equatable/equatable.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';

// ignore: must_be_immutable
class Music extends Equatable {
  final List<Replic> replics;
  final int bitAmount;
  final Duration musicDuration;
  final List<double> borders = [];
  List<double> _borders2 = [];
  List<double> _borders4 = [];
  List<double> _borders5 = [];

  Music({this.replics, this.bitAmount, this.musicDuration}) {
    Duration d = Duration.zero;

    for (int i = 0; i < replics.length; i++) {
      if (i == 0) {
        d += replics[i].timeBefore;

        borders.add(d.inMilliseconds / musicDuration.inMilliseconds);
      } else {
        final replic1 = replics[i - 1], replic2 = replics[i];

        d += replic1.timeAfter + replic2.timeBefore;

        borders.add(d.inMilliseconds / musicDuration.inMilliseconds);
      }
    }

    final listFor4 = [
      borders[0],
    ];
    for (int i = 1; i < borders.length; i++) {
      if ((i + 1) % 4 != 0) {
        listFor4.add(borders[i]);
      }
    }

    final listFor2 = [
      borders[0],
    ];
    for (int i = 0; i < borders.length; i++) {
      if ((i + 1) % 2 != 0) {
        listFor2.add(borders[i]);
      }
    }

    final List<double> listFor5 = [
      borders[0],
    ];
    for (int i = 0; i < borders.length; i++) {
      if ((i + 1) % 5 == 0) {
        listFor5.add(borders[i]);
      }
    }

    _borders2 = listFor2;

    _borders4 = listFor4;

    _borders5 = listFor5;
  }

  List<double> getBordersByIndex(int index) {
    switch (index) {
      case 1:
        return borders;
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
        return borders;
    }
  }

  @override
  List<Object> get props => [replics, bitAmount, musicDuration, borders];
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class VolumeSetter extends StatefulWidget {
  final BehaviorSubject<double> volumeMusicStream;
  final BehaviorSubject<double> volumeReplicStream;

  const VolumeSetter({Key key, this.volumeMusicStream, this.volumeReplicStream})
      : super(key: key);

  @override
  _VolumeSetterState createState() => _VolumeSetterState();
}

class _VolumeSetterState extends State<VolumeSetter> {
  double volumeMusic = 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const <Widget>[
            Text('Replic'),
            Text('Music'),
          ],
        ),
        const SizedBox(height: 24),
        Slider(
          value: volumeMusic,
          onChanged: (value) {
            setState(() {
              volumeMusic = value;
            });

            widget.volumeMusicStream.add(value);
            widget.volumeReplicStream.add(1 - value);
          },
          label: '${volumeMusic * 100}%',
          inactiveColor: Colors.red,
        ),
      ],
    );
  }
}

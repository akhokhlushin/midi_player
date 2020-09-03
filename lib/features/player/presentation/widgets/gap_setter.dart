import 'package:flutter/material.dart';
import 'package:midi_player/core/constants.dart';
import 'package:rxdart/rxdart.dart';

class GapSetter extends StatefulWidget {
  final BehaviorSubject<int> replicGapStream;

  const GapSetter({Key key, this.replicGapStream}) : super(key: key);

  @override
  _GapSetterState createState() => _GapSetterState();
}

class _GapSetterState extends State<GapSetter> {
  int replicGap = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$replicGap% of replics would bypassed',
        ),
        const SizedBox(height: 24),
        Slider(
          value: replicGap.toDouble(),
          onChanged: (value) {
            final v = value.toInt();
            setState(() {
              replicGap = v;
            });
            widget.replicGapStream
                .add((v == 75 ? 5 : v == 0 ? 1 : 100 / v).toInt());
            logger.d(widget.replicGapStream.value);
          },
          max: 75,
          divisions: 3,
          label: '$replicGap%',
        ),
      ],
    );
  }
}

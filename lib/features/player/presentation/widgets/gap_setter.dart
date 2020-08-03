import 'package:flutter/material.dart';
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
          "${replicGap.toStringAsFixed(2)} replics 'durations' which would bypassed before next replic",
        ),
        const SizedBox(height: 24),
        Slider(
          value: replicGap.toDouble(),
          onChanged: (value) {
            setState(() {
              replicGap = value.toInt();
            });

            widget.replicGapStream.add(value.toInt());
          },
          max: 3.0,
          divisions: 3,
          label: '$replicGap',
        ),
      ],
    );
  }
}

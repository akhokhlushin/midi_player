import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class VariationSetter extends StatefulWidget {
  final BehaviorSubject<bool> variation;

  const VariationSetter({Key key, this.variation}) : super(key: key);

  @override
  _VariationSetterState createState() => _VariationSetterState();
}

class _VariationSetterState extends State<VariationSetter> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
            'Sets if you want to continue playing replic when other are there'),
        Switch(
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
              widget.variation.add(value);
            });
          },
        ),
      ],
    );
  }
}

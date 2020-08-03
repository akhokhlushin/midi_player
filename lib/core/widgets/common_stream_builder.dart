import 'package:flutter/material.dart';
import 'package:midi_player/core/widgets/void.dart';

class CommonStreamBuilder<T> extends StatefulWidget {
  final Stream<T> stream;
  final Widget Function(T value) onHasData;
  const CommonStreamBuilder({Key key, this.stream, this.onHasData})
      : super(key: key);

  @override
  _CommonStreamBuilderState createState() => _CommonStreamBuilderState<T>();
}

class _CommonStreamBuilderState<T> extends State<CommonStreamBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: widget.stream,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          return widget.onHasData(snapshot.data);
        }
        return const Void();
      },
    );
  }
}

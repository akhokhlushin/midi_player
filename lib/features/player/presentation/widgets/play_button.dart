import 'package:flutter/material.dart';
import 'package:midi_player/core/widgets/common_stream_builder.dart';
import 'package:rxdart/rxdart.dart';

class PlayButton extends StatefulWidget {
  final BehaviorSubject<bool> value;
  final void Function() onPlay;
  final void Function() onPause;
  final void Function() onLong;
  final bool disable;

  const PlayButton(
      {Key key,
      this.value,
      this.onPlay,
      this.onPause,
      this.onLong,
      this.disable})
      : super(key: key);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  @override
  Widget build(BuildContext context) {
    return CommonStreamBuilder<bool>(
      stream: widget.value,
      onHasData: (value) {
        return InkWell(
          child: GestureDetector(
            onTap:
                widget.disable ? null : value ? widget.onPlay : widget.onPause,
            onLongPress: widget.onLong,
            child: Container(
              decoration: BoxDecoration(
                color: widget.disable ? Colors.grey : Colors.blue,
                borderRadius: BorderRadius.circular(25),
              ),
              width: 50,
              height: 50,
              child: Center(
                child: Icon(value ? Icons.play_arrow : Icons.pause),
              ),
            ),
          ),
        );
      },
    );
  }
}

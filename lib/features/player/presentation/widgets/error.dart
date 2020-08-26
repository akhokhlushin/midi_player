import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/core/constants.dart';
import 'package:midi_player/features/player/presentation/bloc/midi/midi_bloc.dart';
import 'package:rxdart/rxdart.dart';

class AppErrorWidget extends StatefulWidget {
  final String message;
  final BehaviorSubject<int> replicGap;

  const AppErrorWidget({Key key, this.message, this.replicGap})
      : super(key: key);

  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<AppErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          width: double.infinity,
        ),
        Text('Oops! ${widget.message}'),
        RaisedButton(
          onPressed: () {
            BlocProvider.of<MidiBloc>(context).add(
              InitialiseMidi(
                midiFilePath: midiFilePath,
                replicGap: widget.replicGap,
              ),
            );
          },
          child: const Text('Try again'),
        ),
      ],
    );
  }
}

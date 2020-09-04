import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midi_player/core/constants.dart';
import 'package:midi_player/features/player/presentation/bloc/midi/midi_bloc.dart';

class AppErrorWidget extends StatefulWidget {
  final String message;

  const AppErrorWidget({Key key, this.message}) : super(key: key);

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
              const InitialiseMidi(midiFilePath: midiFilePath),
            );
          },
          child: const Text('Try again'),
        ),
      ],
    );
  }
}

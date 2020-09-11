import 'package:flutter/material.dart';

class AppErrorWidget extends StatefulWidget {
  final String message;
  final void Function() onError;

  const AppErrorWidget({
    Key key,
    this.message,
    this.onError,
  }) : super(key: key);

  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<AppErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Oops! ${widget.message}'),
          RaisedButton(
            onPressed: () {
              widget.onError();
            },
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

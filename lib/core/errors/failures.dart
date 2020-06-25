import 'package:flutter/cupertino.dart';

abstract class Failure {
  final String message;

  Failure({ @required this.message });
}
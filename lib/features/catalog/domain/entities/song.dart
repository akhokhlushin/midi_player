import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Song extends Equatable {
  final ImageProvider image;
  final String author;
  final String album;
  final String songName;
  final Duration songDuration;
  final String path;
  final String midiFilePath;

  const Song({
    this.path,
    this.album,
    this.songName,
    this.image,
    this.author,
    this.songDuration,
    this.midiFilePath,
  });

  @override
  List<Object> get props => [image, songDuration, album, author, songName];

  String get fullName => '$author, $album - $songName';
}

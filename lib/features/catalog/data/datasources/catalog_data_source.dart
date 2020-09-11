import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flauto.dart';
import 'package:id3/id3.dart';
import 'package:midi_player/features/catalog/domain/entities/song.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class CatalogDataSource {
  /// Gets all songs and information about them.
  /// Throws [Exception] when something went wrong.
  Future<List<Song>> getSongs();
}

class CatalogDataSourceImpl extends CatalogDataSource {
  final FlutterSoundHelper _flutterSoundHelper;

  CatalogDataSourceImpl(this._flutterSoundHelper);

  @override
  Future<List<Song>> getSongs() async {
    // Use of API
    // TODO: Change code for getting and playing music from API

    final List<String> songsPaths = [
      'assets/music/music.mp3',
      'assets/music/muusic.mp3',
    ];

    final List<String> midiFilePaths = [
      'assets/midi/miidi.mid',
      'assets/midi/miidi.mid',
    ];

    final List<Song> songs = [];

    for (int i = 0; i < songsPaths.length; i++) {
      final songPath = songsPaths[i];
      final midiFilePath = midiFilePaths[i];

      final file = await _getSongFile(songPath);

      final rawSongData =
          await _flutterSoundHelper.FFmpegGetMediaInformation(file.path);

      final songData = rawSongData['metadata'];

      final mp3 = MP3Instance(file.path);

      Map<String, dynamic> rawImageData;

      if (mp3.parseTagsSync()) {
        rawImageData = mp3.getMetaTags();
      }

      final Map<String, dynamic> apic =
          rawImageData['APIC'] as Map<String, dynamic>;

      final base64String = apic == null ? null : apic['base64'];

      final rawImage =
          base64String == null ? null : base64Decode(base64String as String);

      final image = rawImage == null ? null : MemoryImage(rawImage);

      const unknown = 'Unkwown';

      final Song song = Song(
        album: songData['album'] as String ?? unknown,
        author: songData['artist'] as String ?? unknown,
        image: image,
        midiFilePath: midiFilePath,
        path: songPath,
        songDuration: Duration(milliseconds: rawSongData['duration'] as int),
        songName: songData['title'] as String ?? unknown,
      );

      songs.add(song);

      await file.delete();
    }

    return songs;
  }

  Future<File> _getSongFile(String songPath) async {
    // Use of API
    // TODO: Change code for getting and playing music from API

    final Directory directory = await getApplicationDocumentsDirectory();

    final fileName = songPath.split('/').last;

    final path = join(directory.path, fileName);
    final ByteData data = await rootBundle.load(songPath);
    final List<int> buffer =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    final File file = await File(path).writeAsBytes(buffer);

    return file;
  }
}

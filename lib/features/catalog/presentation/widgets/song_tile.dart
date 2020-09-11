import 'package:flutter/material.dart';
import 'package:midi_player/features/catalog/domain/entities/song.dart';

class SongTile extends StatefulWidget {
  final Song song;
  final bool current;

  const SongTile({Key key, this.song, this.current}) : super(key: key);

  @override
  _SongTileState createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  @override
  Widget build(BuildContext context) {
    final song = widget.song;

    return ListTile(
      leading: song.image != null
          ? CircleAvatar(backgroundImage: song.image)
          : const Icon(Icons.music_note),
      title: Text(song.songName),
      subtitle: Text('Album: ${song.album}, author: ${song.author}'),
      trailing: widget.current
          ? const Icon(
              Icons.check,
              color: Colors.orange,
            )
          : null,
    );
  }
}

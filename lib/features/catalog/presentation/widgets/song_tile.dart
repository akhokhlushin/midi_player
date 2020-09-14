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
      leading: Stack(
        alignment: Alignment.center,
        children: [
          if (song.image != null)
            Container(
              width: 50,
              height: 50,
              child: Image(
                image: song.image,
              ),
            )
          else
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              // child: const Icon(Icons.music_note),
            ),
          if (widget.current)
            const Icon(
              Icons.favorite_border,
              color: Colors.red,
            ),
        ],
      ),
      title: Text(song.songName),
      subtitle: Text('${song.author}: ${song.album}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${song.bpm} bpm'),
          Text(getDurStr(song.songDuration)),
        ],
      ),
    );
  }
}

String getDurStr(Duration d) {
  final hours = d.inHours;
  final minutes = d.inMinutes;
  final seconds = d.inSeconds - (minutes * 60);

  if (hours != 0) {
    return '$hours:$minutes:$seconds';
  }
  return '$minutes:$seconds';
}

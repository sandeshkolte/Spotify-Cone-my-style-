import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/drawer.dart';
import '../models/song.dart';
import '../providers/playlist.dart';
import 'song_page.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  late final dynamic playListProvider;
  late final dynamic audioInput;

  @override
  void initState() {
    super.initState();
    playListProvider = Provider.of<PlayListProvider>(context, listen: false);
  }

  void gotoSong(int songIndex) {
    playListProvider.currentSongIndex = songIndex;
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => const SongPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("P L A Y L I S T"),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: Consumer<PlayListProvider>(builder: (context, value, child) {
        final List<Song> playList = value.playList;
        final currentSong = playList[value.currentSongIndex ?? 0];

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: playList.length,
                  itemBuilder: (context, index) {
                    final Song song = playList[index];

                    return ListTile(
                      // trailing:
                      //     currentSong == song ? const Text("is Playing") : null,
                      selected: currentSong == song,
                      selectedColor: Colors.green,
                      selectedTileColor:
                          Theme.of(context).colorScheme.secondary,
                      title: Text(song.songName),
                      subtitle: Text(song.artistName),
                      leading: Image.asset(song.albumImagePath),
                      onTap: () => gotoSong(index),
                    );
                  }),
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.secondary),
                child: ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SongPage()));
                  },
                  leading: Image.asset(currentSong.albumImagePath),
                  title: Text(currentSong.songName),
                  subtitle: Text(currentSong.artistName),
                  trailing: IconButton(
                    icon:
                        Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: value.pauseOrResume,
                  ),
                )),
          ],
        );
      }),
    );
  }
}

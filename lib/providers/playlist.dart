// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter_audio_output/flutter_audio_output.dart';
// import 'package:logger/logger.dart';

import '../models/song.dart';

class PlayListProvider extends ChangeNotifier {
  final List<Song> _playList = [
    Song(
        songName: "Rela rela",
        artistName: "Gondi",
        albumImagePath: "assets/images/image1.png",
        audioPath: "audio/Rela_rela.mp3"),
    Song(
        songName: "Koyta Dhemsa",
        artistName: "Gondi",
        albumImagePath: "assets/images/image2.png",
        audioPath: "audio/Koyta_Dhemsa.mp3"),
    Song(
        songName: "Hua Main",
        artistName: "Raghav Chaitanya",
        albumImagePath: "assets/images/animal.png",
        audioPath: "audio/hua-main.mp3"),
    Song(
        songName: "Jab Tak",
        artistName: "Armaan Malik",
        albumImagePath: "assets/images/msdhoni.png",
        audioPath: "audio/jabtak.mp3"),
    Song(
        songName: "Satranga(From \"Animal\")",
        artistName: "Arijit Singh",
        albumImagePath: "assets/images/satranga-img.png",
        audioPath: "audio/satranga.mp3"),
    Song(
        songName: "One Love",
        artistName: "Shubh",
        albumImagePath: "assets/images/onelove-img.png",
        audioPath: "audio/onelove.mp3"),
  ];

//AUDIO PLAYER

  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  bool _isPlaying = false;

  void play() async {
    final String path = _playList[currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
    notifyListeners();
  }

  void playNextSong() async {
    if (currentSongIndex != null) {
      if (currentSongIndex! < _playList.length - 1) {
        currentSongIndex = currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  void playPreviousSong() async {
    if (currentSongIndex != null) {
      if (currentSongIndex! == 0) {
        currentSongIndex = playList.length - 1;
      } else {
        currentSongIndex = currentSongIndex! - 1;
      }
    }
  }

  PlayListProvider() {
    listenToDuration();
  }

  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
      notifyListeners();
    });
  }

  int? _currentSongIndex;

  List<Song> get playList => _playList;

  int? get currentSongIndex => _currentSongIndex;

  bool get isPlaying => _isPlaying;

  Duration get currentDuration => _currentDuration;

  Duration get totalDuration => _totalDuration;

  // AudioInput get currentInput => _currentInput;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }

    notifyListeners();
  }

  // AudioInput _currentInput = const AudioInput("", 0);

  // final logger = Logger();

  // getInput() async {
  //   _currentInput = await FlutterAudioOutput.getCurrentOutput();
  //   logger.w("current:$_currentInput");
  //   notifyListeners();
  // }

 
}

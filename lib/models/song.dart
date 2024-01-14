// class Song {
//   final String songName;
//   final String artistName;
//   final String albumImagePath;
//   final String audioPath;

//   Song(
//       {required this.songName,
//       required this.artistName,
//       required this.albumImagePath,
//       required this.audioPath});
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String songName;
  String artistName;
  String albumImagePath;
  String audioPath;

  Song({
    required this.songName,
    required this.artistName,
    required this.albumImagePath,
    required this.audioPath,
  });

  // Factory method to create a Song instance from a Firestore document snapshot
  factory Song.fromFirestore(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Song(
      songName: data['songName'] ?? '',
      artistName: data['artistName'] ?? '',
      albumImagePath: data['albumImagePath'] ?? '',
      audioPath: data['audioPath'] ?? '',
    );
  }
}

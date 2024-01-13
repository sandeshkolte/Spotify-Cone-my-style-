import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Music extends StatefulWidget {
  const Music({super.key});

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  String? url;

  PlatformFile? pickedFile;
  File? selectedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);

    pickedFile = result!.files.first;
    selectedFile = File(pickedFile!.path!);
    debugPrint("File is $pickedFile");
    _isSelected.value = true;
  }

  Future uploadAudio() async {
    _isUploaded.value = false;
    final Reference audioRef = FirebaseStorage.instance.ref().child("audio");
    var timeKey = DateTime.now();

    final UploadTask uploadTask =
        audioRef.child("$timeKey.mp3").putFile(selectedFile!);

    var audioUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    url = audioUrl.toString();
    // savetoDatabase(url);
    _isUploaded.value = true;
  }

  final ValueNotifier<bool> _isSelected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isUploaded = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload/Download"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: selectFile,
                child: _isSelected.value
                    ? const Text("Ok")
                    : const Text("Select")),
          ),
          Center(
            child: ElevatedButton(
                onPressed: uploadAudio,
                child: _isUploaded.value
                    ? const Text("Success")
                    : const Text("Upload")),
          ),
        ],
      ),
    );
  }
}

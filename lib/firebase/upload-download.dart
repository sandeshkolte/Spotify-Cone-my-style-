import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadDownload {
  final ValueNotifier<bool> isImageSelected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isImageUploaded = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isAudioSelected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isAudioUploaded = ValueNotifier<bool>(false);

  String? audioUrl;
  final fireStore = FirebaseFirestore.instance.collection("data");

  PlatformFile? pickedFile;
  File? selectedFile;
  UploadTask? uploadImageTask;
  UploadTask? uploadAudioTask;

  Future selectFile() async {
    try {
      isAudioSelected.value = false;
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result == null) return;
      pickedFile = result.files.first;
      selectedFile = File(pickedFile!.path!);
      debugPrint("FILE SELECTED: $pickedFile");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isAudioSelected.value = true;
    }
  }

  Future uploadAudio() async {
    try {
      isAudioUploaded.value = false;
      final Reference audioRef = FirebaseStorage.instance.ref().child("audio");
      var timeKey = DateTime.now();

      uploadAudioTask = audioRef.child("$timeKey.mp3").putFile(selectedFile!);

      var url = await (await uploadAudioTask!.whenComplete(() {}))
          .ref
          .getDownloadURL();
      audioUrl = url.toString();
      debugPrint("AUDIO: $audioUrl");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      // savetoDatabase(url);
      isAudioUploaded.value = true;
    }
  }

  String? imageUrl;
  File? selectedImage;

  Future picImageFromGallery() async {
    try {
      isImageSelected.value = false;
      var pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;
      selectedImage = File(pickedImage.path);
      debugPrint("IMAGE SELECTED :$selectedImage");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isImageSelected.value = true;
    }
  }

  Future uploadImage() async {
    try {
      isImageUploaded.value = false;
      final Reference postImageRef =
          FirebaseStorage.instance.ref().child("images");
      var timeKey = DateTime.now();

      uploadImageTask =
          postImageRef.child("$timeKey.jpg").putFile(selectedImage!);

      var ImageUrl = await (await uploadImageTask!.whenComplete(() {}))
          .ref
          .getDownloadURL();

      imageUrl = ImageUrl.toString();
      debugPrint("IMAGE: $imageUrl");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isImageUploaded.value = true;
    }
  }

  void savetoDatabase(
      String songName, String artistName, String audioUrl, String imageUrl) {
    try {
      DateTime dbTimekey = DateTime.now();

      String postDate =
          ("${dbTimekey.day}-${dbTimekey.month}-${dbTimekey.year}");
      String postTime = ("${dbTimekey.hour}:${dbTimekey.minute}");

      String id = DateTime.now().millisecondsSinceEpoch.toString();

      CollectionReference ref = FirebaseFirestore.instance.collection("data");
      ref.doc(id).set({
        'id': id,
        'songName': songName,
        'artistName': artistName,
        'albumImagePath': imageUrl,
        'audioPath': audioUrl,
        'postDate': postDate,
        'postTime': postTime
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      debugPrint("UPLOAD TO DATABASE SUCCESS");
    }
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadAudioTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          double progress = data!.bytesTransferred / data.totalBytes;

          return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    color: Colors.blueGrey,
                    backgroundColor: Colors.grey,
                  ),
                  Center(
                    child: Text(
                      '${(100 * progress).roundToDouble()}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ));
        } else {
          return const SizedBox();
        }
      });
}

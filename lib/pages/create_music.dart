// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/firebase/upload-download.dart';
import 'package:music_player_app/providers/playlist.dart';
import 'package:provider/provider.dart';

class CreateMusic extends StatefulWidget {
  const CreateMusic({super.key});

  @override
  State<CreateMusic> createState() => _CreateMusicState();
}

class _CreateMusicState extends State<CreateMusic> {
  final songNameController = TextEditingController();
  final artistNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void validationCheck(String songNametext, String artistNametext) async {
    try {
      debugPrint("INSIDE");
      if (formKey.currentState!.validate()) {
        final songName = songNametext;
        final artistName = artistNametext;
        final audioUrl = uploadDownload.audioUrl;
        final imageUrl = uploadDownload.imageUrl;
        debugPrint("Audio: $audioUrl");
        debugPrint("Image $imageUrl");

        if (audioUrl != null && imageUrl != null) {
          debugPrint("CHECKED");
          uploadDownload.savetoDatabase(
              songName, artistName, audioUrl, imageUrl);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistNameController.dispose();
    super.dispose();
  }

  final uploadDownload = UploadDownload();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(" C R E A T E"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: uploadDownload.isImageSelected,
            builder: (context, value, child) => Container(
              height: 350,
              width: 300,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.inversePrimary)),
              child: uploadDownload.isImageSelected.value &&
                      uploadDownload.selectedImage != null
                  ? Image.file(
                      uploadDownload.selectedImage!,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                    )
                  : const Center(child: Text("Select an Image")),
            ),
          )),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ValueListenableBuilder(
                  valueListenable: uploadDownload.isAudioSelected,
                  builder: (context, value, child) => ElevatedButton(
                      onPressed: uploadDownload.selectFile,
                      child: uploadDownload.isAudioSelected.value &&
                              uploadDownload.selectedFile != null
                          ? const Text(
                              "Change Song",
                              style: TextStyle(color: Colors.green),
                            )
                          : const Text("Select Song"))),
              ValueListenableBuilder(
                  valueListenable: uploadDownload.isImageSelected,
                  builder: (context, value, child) => ElevatedButton(
                      onPressed: () {
                        uploadDownload.picImageFromGallery();
                      },
                      child: uploadDownload.isImageSelected.value &&
                              uploadDownload.selectedImage != null
                          ? const Text(
                              "Change Image",
                              style: TextStyle(color: Colors.green),
                            )
                          : const Text("Select Image"))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ValueListenableBuilder(
                  valueListenable: uploadDownload.isAudioUploaded,
                  builder: (context, value, child) => ElevatedButton(
                      onPressed: uploadDownload.uploadAudio,
                      child: uploadDownload.isAudioUploaded.value
                          ? const Text(
                              "Success",
                              style: TextStyle(color: Colors.blueGrey),
                            )
                          : const Text("Upload Song"))),
              ValueListenableBuilder(
                  valueListenable: uploadDownload.isImageUploaded,
                  builder: (context, value, child) => ElevatedButton(
                      onPressed: uploadDownload.uploadImage,
                      child: uploadDownload.isImageUploaded.value
                          ? const Text(
                              "Success",
                              style: TextStyle(color: Colors.blueGrey),
                            )
                          : const Text("Upload Image"))),
            ],
          ),
          uploadDownload.buildProgress(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12)),
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(
                        validator: (value) {
                          return value!.length < 2 ? "Fill this" : null;
                        },
                        controller: songNameController,
                        decoration: const InputDecoration(
                          labelText: "Song Name",
                          prefixIcon: Icon(Icons.music_note_rounded),
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          return value!.length < 2 ? "Fill this" : null;
                        },
                        controller: artistNameController,
                        decoration: const InputDecoration(
                            labelText: "Artist Name",
                            prefixIcon: Icon(Icons.multitrack_audio_sharp)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            debugPrint("CLICKED");
                            validationCheck(songNameController.text,
                                artistNameController.text);
                            final PlayListProvider playListProvider;
                            playListProvider = Provider.of<PlayListProvider>(
                                context,
                                listen: false);
                            playListProvider.fetchFirestoreData();
                          },
                          child: const Text("Done"))
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

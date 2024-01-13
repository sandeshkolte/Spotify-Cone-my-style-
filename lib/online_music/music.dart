import 'package:flutter/material.dart';
import 'package:music_player_app/firebase/upload-download.dart';

class Music extends StatefulWidget {
  const Music({super.key});

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  final songNameController = TextEditingController();
  final artistNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void validationCheck(String songNametext, String artistNametext) async {
    debugPrint("INSIDE");
    // if (formKey.currentState!.validate()) {
    final songName = songNametext;
    final artistName = artistNametext;
    final audioUrl = uploadDownload.audioUrl;
    final imageUrl = uploadDownload.imageUrl;
    debugPrint("Audio: $audioUrl");
    debugPrint("Image $imageUrl");

    if (audioUrl != null && imageUrl != null) {
      debugPrint("CHECKED");
      uploadDownload.savetoDatabase(songName, artistName, audioUrl, imageUrl);
      // }
    }
  }

  final uploadDownload = UploadDownload();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
            child: Container(
              height: 350,
              width: 300,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.inversePrimary)),
              child: uploadDownload.selectedImage != null
                  ? Image.file(
                      uploadDownload.selectedImage!,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                    )
                  : const Center(child: Text("Select an Image")),
            ),
          ),
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
                      child: uploadDownload.isAudioSelected.value
                          ? const Text("Change Song")
                          : const Text("Select Song"))),
              ValueListenableBuilder(
                  valueListenable: uploadDownload.isImageSelected,
                  builder: (context, value, child) => ElevatedButton(
                      onPressed: () {
                        uploadDownload.picImageFromGallery();
                        setState(() {});
                      },
                      child: uploadDownload.isImageSelected.value
                          ? const Text("Change Image")
                          : const Text("Select Image"))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: uploadDownload.uploadAudio,
                  child: uploadDownload.isAudioUploaded.value
                      ? const Text("Success")
                      : const Text("Upload Song")),
              ElevatedButton(
                  onPressed: uploadDownload.uploadImage,
                  child: uploadDownload.isImageUploaded.value
                      ? const Text("Success")
                      : const Text("Upload Image")),
            ],
          ),
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
                        // validator: (value) {
                        //   return value!.length < 2 ? "Fill this" : null;
                        // },
                        controller: songNameController,
                        decoration: const InputDecoration(
                          labelText: "Song Name",
                          prefixIcon: Icon(Icons.music_note_rounded),
                        ),
                      ),
                      TextFormField(
                        // validator: (value) {
                        //   return value!.length < 2 ? "Fill this" : null;
                        // },
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

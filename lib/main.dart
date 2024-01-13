import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/online_music/music.dart';
// import 'package:music_player_app/online_music/music.dart';
import 'package:music_player_app/pages/playlist_page.dart';
import 'package:music_player_app/providers/playlist.dart';
import 'package:music_player_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
// import 'pages/playlist_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCMrieJIhvAQVtYGrKFLYRQovPyF1zn7Ng",
          appId: "1:427886693193:android:ae5b69d5d8e5f29f696898",
          messagingSenderId: "427886693193",
          projectId: "social-app-a6b82",
          storageBucket: "social-app-a6b82.appspot.com"));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => PlayListProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: const Music(),
    );
  }
}

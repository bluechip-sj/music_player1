import 'package:flutter/material.dart';
import 'package:music_player1/pages/audioplayer_with_local.dart';
import 'package:music_player1/pages/audioplayer_with_url.dart';
import 'package:music_player1/pages/circular_progressbar.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Music Player')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('URL Player'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AudioPlayerWithURL()));
                },
              ),
              ElevatedButton(
                child: Text('Local Player'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AudioPlayerWithLocal()));
                },
              ),
              ElevatedButton(
                child: Text('CircularProgressBar Player'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CircularProgressBar()));
                },
              ),
            ],
          ),
        ),
    );
  }
}

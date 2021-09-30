import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class CircularProgressBar extends StatefulWidget {
  @override
  _CircularProgressBarState createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar> {
  // AssetsAudioPlayerWebPlugin audioPlayer = AssetsAudioPlayerWebPlugin();
  PlayerState playerState = PlayerState.PAUSED;
  AudioCache? audioCache;

  int timeProgress = 0;
  int audioDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CircularProgressBar Player')),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('assets_audio_player: ^3.0.3+5'),
            const Text('설치가 안되고 있음'),
          ],
        ),
      ),
    );
  }
}

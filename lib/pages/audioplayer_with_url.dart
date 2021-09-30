import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWithURL extends StatefulWidget {
  @override
  _AudioPlayerWithURLState createState() => _AudioPlayerWithURLState();
}

class _AudioPlayerWithURLState extends State<AudioPlayerWithURL> {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState playerState = PlayerState.PAUSED;
  String url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';

  int timeProgress = 0;
  int audioDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('URL Player')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('주소로 음악 불러 오기'),
            IconButton(
              icon: Icon(playerState == PlayerState.PLAYING ? Icons.pause_rounded : Icons.play_arrow_rounded),
              iconSize: 100,
              onPressed: () {
                print('URL Play button');
                playerState == PlayerState.PLAYING ? pauseMusic() : playMusic();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getTimeString(timeProgress)),
                const SizedBox(width: 5),
                Container(width: 250, child: slider()),
                const SizedBox(width: 5),
                Text(getTimeString(audioDuration)),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        playerState = s;
      });
    });

    audioPlayer.setUrl(url);

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        audioDuration = d.inMilliseconds;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        timeProgress = p.inMilliseconds;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
  }

  // 플레이
  playMusic() async {
    await audioPlayer.play(url);
  }

  // 정지
  pauseMusic() async {
    await audioPlayer.pause();
  }

  Widget slider() {
    return Container(
      width: 300,
      child: Slider.adaptive(
          value: (timeProgress / 1000).floorToDouble(),
          max: (audioDuration / 1000).floorToDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  void seekToSec(int sec) {
    Duration newPosition = Duration(seconds: sec);
    audioPlayer.seek(newPosition);
  }

  // 분:초 로 변경하기
  String getTimeString(int milliseconds) {
    String minutes = '${(milliseconds / 6000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
    return '$minutes:$seconds';
  }
}

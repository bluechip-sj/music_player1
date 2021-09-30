import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWithLocal extends StatefulWidget {
  @override
  _AudioPlayerWithLocalState createState() => _AudioPlayerWithLocalState();
}

class _AudioPlayerWithLocalState extends State<AudioPlayerWithLocal> {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState playerState = PlayerState.PAUSED;
  AudioCache? audioCache;

  // 음악 주소
  String path1 = 'undergound1.mp3';
  String path2 = 'iloveyou_sgwannabe.mp3';

  int timeProgress = 0;
  int audioDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Player')),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('저장되어 있는 음악 불러 오기'),
            const Text('- 김지영 수면곡 : underground1 -'),
            IconButton(
              icon: Icon(playerState == PlayerState.PLAYING ? Icons.pause_rounded : Icons.play_arrow_rounded),
              iconSize: 100,
              onPressed: () {
                print('Local Play button');
                playerState == PlayerState.PLAYING ? pauseMusic() : playMusic();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getTimeString(timeProgress)),
                const SizedBox(width: 5),
                // Container(width: 250, child: slider()),
                slider(),
                const SizedBox(width: 5),
                // Text(getTimeString(audioDuration)),
                audioDuration == 0 ? getFileAudioDuration() : Text(getTimeString((audioDuration)))
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
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        playerState = s;
      });
    });

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
    audioCache!.clearAll();
  }

  playMusic() async {
    await audioCache!.play(path1);
  }

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
    if (milliseconds == null) milliseconds = 0;
    String minutes = '${(milliseconds / 6000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
    return '$minutes:$seconds';
  }

  Widget getFileAudioDuration() {
    return FutureBuilder(
        future: _getAudioDuration(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(getTimeString(snapshot.data!));
          }
          return Text('');
        });
  }

  Future<int> _getAudioDuration() async {
    Uri audioFile = await audioCache!.load(path1);
    await audioPlayer.setUrl(audioFile.path);
    audioDuration = await Future.delayed(Duration(seconds: 2), () => audioPlayer.getDuration());
    return audioDuration;
  }
}

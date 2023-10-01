import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import '../widgets/seek_bar.dart';

class Playing extends StatefulWidget {

  final ImageProvider image;
  final String label;
  final String musicUrl;
  //final bool favorite;
  const Playing(
      {Key? key,
        required this.image,
        required this.label,
        required this.musicUrl,
        //required this.favorite
      })
      : super(key: key);

  @override
  State<Playing> createState() => _PlayingState();
}

class _PlayingState extends State<Playing> {
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          AudioSource.uri(
            Uri.parse(
                widget.musicUrl),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          audioPlayer.positionStream, audioPlayer.durationStream, (
          Duration position,
          Duration? duration,
          ) {
        return SeekBarData(position, duration ?? Duration.zero);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image:widget.image,
            fit: BoxFit.cover,
          ),
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.0),
                ],
                stops: [0.0, 0.6, 0.8],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.pink.shade500,
                        Colors.black,
                      ])),
            ),
          ),
          _MusicPlayer(
            //song:song,
              seekBarDataStream: _seekBarDataStream,
              audioPlayer: audioPlayer)
        ],
      ),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  const _MusicPlayer({
    Key? key,
    // required this.song,
    required Stream<SeekBarData> seekBarDataStream,
    required this.audioPlayer,
  })  : _seekBarDataStream = seekBarDataStream,
        super(key: key);

  // final Song song;
  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<SeekBarData>(
              stream: _seekBarDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  position: positionData?.position ?? Duration.zero,
                  duration: positionData?.duration ?? Duration.zero,
                  onChangeEnd: audioPlayer.seek,
                );
              }),
          PlayerButtons(audioPlayer: audioPlayer)
        ],
      ),
    );
  }
}

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, index) {
              return IconButton(
                  onPressed: audioPlayer.hasPrevious
                      ? audioPlayer.seekToPrevious
                      : null,
                  iconSize: 45,
                  icon: Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                  ));
            }),
        StreamBuilder<PlayerState>(
            stream: audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final playerState = snapshot.data;
                final processingState = playerState!.processingState;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    width: 64.0,
                    height: 64.0,
                    margin: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (!audioPlayer.playing) {
                  return IconButton(
                      onPressed: audioPlayer.play,
                      iconSize: 75,
                      icon: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ));
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                      onPressed: audioPlayer.pause,
                      iconSize: 75,
                      icon: Icon(
                        Icons.pause,
                        color: Colors.white,
                      ));
                } else {
                  return IconButton(
                      onPressed: () => audioPlayer.seek(Duration.zero,
                          index: audioPlayer.effectiveIndices!.first),
                      iconSize: 75,
                      icon: Icon(
                        Icons.replay_circle_filled_outlined,
                        color: Colors.white,
                      ));
                }
              } else {
                return CircularProgressIndicator();
              }
            }),
        StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, index) {
              return IconButton(
                  onPressed:
                  audioPlayer.hasNext ? audioPlayer.seekToNext : null,
                  iconSize: 45,
                  icon: Icon(
                    Icons.skip_next,
                    color: Colors.white,
                  ));
            }),
      ],
    );
  }
}

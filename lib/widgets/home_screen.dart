import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../styles/app_color.dart';
import '../database/music_data.dart';
import '../model/music_model.dart';
import '../styles/app_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<MusicModel> musicData =
      $data.map((json) => MusicModel.fromJson(json)).toList();

  String musicName = "Hilola";

  Duration maxDuration = Duration.zero;

  String? currentMusicDuration;

  bool isPlaying = false;

  int n = 0;

  final player = AudioPlayer();

  String currentName(int a) {
    musicName = musicData[a].name!;
    currentMusicDuration = musicData[a].duration;

    setState(() {});
    return musicName;
  }

  void listTileMusic(int index) {
    if (isPlaying && currentName(n) == currentName(index)) {
      player.pause();
      isPlaying = false;
    } else {
      player.play(AssetSource(musicData[index].path!));

      isPlaying = true;
    }
    n = index;
    player.setSourceAsset(musicData[n].path!);
    player.onDurationChanged.listen((Duration duration) {
      setState(() {});
      maxDuration = duration;
    });

    setState(() {});
  }

  void nextMusic(int a) {
    a++;
    if (a == musicData.length) {
      a = 0;
    }
    player
      ..stop()
      ..play(AssetSource(musicData[a].path!));
    player.setSourceAsset(musicData[a].path!);
    player.onDurationChanged.listen((Duration duration) {
      maxDuration = duration;
      setState(() {});
    });
    n = a;
    isPlaying = true;
    setState(() {});
  }

  void lastMusic(int a) {
    a--;
    if (a == -1) {
      a = musicData.length - 1;
    }
    player
      ..stop()
      ..play(AssetSource(musicData[a].path!));
    player.setSourceAsset(musicData[a].path!);
    player.onDurationChanged.listen((Duration duration) {
      maxDuration = duration;
      setState(() {});
    });
    isPlaying = true;
    n = a;
    setState(() {});
  }

  void pause(int a) {
    player.pause();
    isPlaying = false;
    player.setSourceAsset(musicData[a].path!);
    player.onDurationChanged.listen((Duration duration) {
      maxDuration = duration;
    });
    setState(() {});
  }

  void play(int a) {
    player.play(AssetSource(musicData[a].path!));
    isPlaying = true;
    player.setSourceAsset(musicData[a].path!);
    player.onDurationChanged.listen((Duration duration) {
      maxDuration = duration;
    });
    setState(() {});
  }

  @override
  void initState() {
    player.setSourceAsset(musicData[n].path!);

    player.onDurationChanged.listen((Duration duration) {
      maxDuration = duration;
      setState(() {});
    });
    super.initState();
  }
@override
  void dispose() {
    player.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.background,
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Hilola G'ayratova",
                            style: TextStyle(
                              color: AppColors.appBarText,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 580,
                width: double.infinity,
                child: ListView(
                  children: List.generate(
                    musicData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: InkWell(
                        onTap: () => listTileMusic(index),
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.cards,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                            border: Border.all(
                              width: 2.5,
                              color: AppColors.border,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shade,
                                offset: Offset(5, 5),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 18,
                                  top: 3,
                                  bottom: 3,
                                ),
                                child: InkWell(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        content: const SizedBox(
                                          height: 250,
                                          width: 250,
                                          child: Image(
                                            fit: BoxFit.cover,
                                            image: AppIcon.avatar,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  child: const CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AppIcon.avatar,
                                  ),
                                ),
                              ),
                              Text(
                                currentName(index),
                                style: TextStyle(
                                    color:
                                        (currentName(n) == currentName(index))
                                            ? Colors.green
                                            : Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Text(
                                  "$currentMusicDuration",
                                  style: TextStyle(
                                      color:
                                          (currentName(n) == currentName(index))
                                              ? Colors.green
                                              : Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Text(
                    currentName(n),
                    style: const TextStyle(
                        fontSize: 23,
                        fontFamily: "Exo",
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder(
                  stream: player.onPositionChanged,
                  builder: (context, snapshot) => ProgressBar(
                    barHeight: 5,
                    barCapShape: BarCapShape.round,
                    timeLabelPadding: 7,
                    baseBarColor: AppColors.progressbarback,
                    progressBarColor: AppColors.appBarText,
                    thumbColor: AppColors.appBarText,
                    thumbRadius: 10,
                    thumbGlowRadius: 0,
                    progress: snapshot.data ?? Duration.zero,
                    total: maxDuration,
                    onSeek: (duration) {

                      player.seek(duration);
                      setState(() {});
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton.outlined(
                    icon: const Icon(
                      Icons.skip_previous_outlined,
                      size: 36,
                    ),
                    onPressed: () => lastMusic(n),
                  ),
                  Center(
                    child: isPlaying
                        ? IconButton.outlined(
                            icon: const Icon(
                              CupertinoIcons.pause,
                              size: 36,
                              color: Colors.black,
                            ),
                            onPressed: () => pause(n),
                          )
                        : IconButton.outlined(
                            icon: const Icon(
                              CupertinoIcons.play,
                              size: 36,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              play(n);
                            },
                          ),
                  ),
                  IconButton.outlined(
                    icon: const Icon(
                      Icons.skip_next_outlined,
                      size: 36,
                    ),
                    onPressed: () => nextMusic(n),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

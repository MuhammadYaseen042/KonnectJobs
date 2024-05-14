import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../widgets/widgets_components.dart';

/// Homepage
class YoutubePlayerDemoApp extends StatefulWidget {
  const YoutubePlayerDemoApp({Key? key}) : super(key: key);

  @override
  _YoutubePlayerDemoAppState createState() => _YoutubePlayerDemoAppState();
}

class _YoutubePlayerDemoAppState extends State<YoutubePlayerDemoApp> {
  late YoutubePlayerController _controller;
  late YoutubeMetaData _videoMetaData;
  late YoutubeMetaData _videoMetaData2;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    '_ZTq3bKMp4A',
    'vLAfUs0o9EA',
    'qJp9b3xi9oo',
    'XTMdSlwpPQo',
    'ge6_gthhEmI',
    'UCs_3dFoVSI',
    'JGl_avZn0nI',
    'nA1PPPUluYk',
    '-C-ic2H24OU',
    'hDjRFymXYPY',
    'Ff5FUoo2YZA',
    'HtJH2e2PWaE',
  ];

  final List<YoutubePlayerController> _controllers = [
    'nmTl96MgN8g',
    '_ZTq3bKMp4A',
    'qJp9b3xi9oo',
    'XTMdSlwpPQo',
    '6jZDSSZZxjQ',
    'UCs_3dFoVSI',
    'Xsm0ofBs5hk',
    'hDjRFymXYPY',
    '-C-ic2H24OU',
    'Ff5FUoo2YZA',
    'HtJH2e2PWaE',
  ].map<YoutubePlayerController>(
        (videoId) => YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    ),
  )
      .toList();

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    _videoMetaData = const YoutubeMetaData();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        onReady: () {
          setState(() {
            _isPlayerReady = true;
            _videoMetaData = _controller.metadata;
          });
        },
        onEnded: (data) {
          _controller.load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
        },
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: appBarWhiteTitle("Learning Skill"),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: const Color(0xff0077B5),
          elevation: 0.0,
        ),
        body: Column(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                leading: const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.video_collection_rounded,
                      color: Colors.red,
                    )),
                title: Text(
                  _videoMetaData.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _videoMetaData.author,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      YoutubePlayer(
                        key: ObjectKey(_controllers[index]),
                        controller: _controllers[index],
                        actionsPadding: const EdgeInsets.only(left: 16.0),
                        bottomActions: [
                          CurrentPosition(),
                          ProgressBar(isExpanded: true),
                          RemainingDuration(),
                          FullScreenButton(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          leading: const CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.video_collection_rounded,
                                color: Colors.red,
                              )),
                          title: Text(
                            _controllers[index].metadata.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            _controllers[index].metadata.author,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: _controllers.length,
                separatorBuilder: (context, _) => const SizedBox(height: 10.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}

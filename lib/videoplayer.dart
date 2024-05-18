import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cross_platform/logs_service.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../common/sources/sources.dart';
import '../common/widgets.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() =>
      _VideoPlayerState();
}

class _VideoPlayerState
    extends State<VideoPlayer> {
  late final Player player = Player();
  late final VideoController controller = VideoController(
    player,
    configuration: ValueNotifier<VideoControllerConfiguration>(const VideoControllerConfiguration(enableHardwareAcceleration: true)).value,
  );
  final LoggingService loggingService = LoggingService();

  @override
  void initState() {
    super.initState();
    MediaKit.ensureInitialized();
    player.open(Media('http://tedbryanrazonado.cmu-online.tech/uploads/what-most-schools-dont-teach.mp4'));
    player.stream.error.listen((error) => debugPrint(error));
    
    if (kIsWeb) {
      loggingService.startLogging('web', 'Using Video Player');
    } else {
      if (defaultTargetPlatform == TargetPlatform.android) {
        loggingService.startLogging('android', 'Using Video Player');
      } else if (defaultTargetPlatform == TargetPlatform.windows) {
        loggingService.startLogging('desktop', 'Using Video Player');
      }
    }
  }

  @override
  void dispose() {
    player.dispose();
    loggingService.stopLogging();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontal =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'file',
            tooltip: 'Open File',
            onPressed: () => showFilePicker(context, player),
            child: const Icon(Icons.file_open),
          ),
          const SizedBox(width: 16.0),
          FloatingActionButton(
            heroTag: 'uri',
            tooltip: 'Open Uri',
            onPressed: () => showURIPicker(context, player),
            child: const Icon(Icons.link),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: horizontal
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 8.0,
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.all(32.0),
                              child: Video(
                                controller: controller,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32.0),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : ListView(
                children: [
                  Video(
                    controller: controller,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 9.0 / 16.0,
                  ),
                ],
              ),
      ),
    );
  }
}
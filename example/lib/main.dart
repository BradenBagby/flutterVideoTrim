import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trim/video_trim.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  XFile? video;
  VideoPlayerController? controller;
  final startMillisecondsController = TextEditingController(text: "0");
  final endMillisecondsController = TextEditingController(text: "0");
  bool trimmed = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> changeVideo(String path) async {
    final file = File(path);
    controller = VideoPlayerController.file(file);
    await controller!.initialize();
    await controller!.setLooping(true);
    await controller!.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: SafeArea(
            child: controller == null
                ? ElevatedButton(
                    onPressed: () async {
                      final xfile = await ImagePicker()
                          .pickVideo(source: ImageSource.gallery);
                      if (xfile != null) {
                        setState(() {
                          video = xfile;
                        });
                        changeVideo(xfile.path);
                      }
                    },
                    child: const Text("Select Video"))
                : Column(
                    children: [
                      Expanded(
                        child: VideoPlayer(controller!),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (!trimmed)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                controller: startMillisecondsController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: "Start MS"),
                              ),
                            ),
                            const Text(" to "),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                controller: endMillisecondsController,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(labelText: "End MS"),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final newPath = await VideoTrim.trim(
                                    video!.path,
                                    startMilliseconds:
                                        _getInput(startMillisecondsController),
                                    endMilliseconds:
                                        _getInput(endMillisecondsController));
                                setState(() {
                                  trimmed = true;
                                });
                                changeVideo(newPath!);
                              },
                              child: const Text("Trim"),
                            ),
                          ],
                        )
                      else
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                controller = null;
                              });
                            },
                            child: const Text("Clear"))
                    ],
                  ),
          )),
    );
  }

  int _getInput(TextEditingController controller) =>
      int.tryParse(controller.text) ?? 0;
}

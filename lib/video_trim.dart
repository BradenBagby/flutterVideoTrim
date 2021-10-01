import 'dart:async';

import 'package:flutter/services.dart';

class VideoTrim {
  static const MethodChannel _channel = MethodChannel('video_trim');

  /// takes in a local path of the video file to trim, start milliseconds, end milliseconds
  /// returns path of the trimmed file
  static Future<String?> trim(String path,
      {required int startMilliseconds, int? endMilliseconds}) async {
    final String? trimmedPath = await _channel.invokeMethod('trim',
        {"path": path, "start": startMilliseconds, "end": endMilliseconds});
    return trimmedPath;
  }
}

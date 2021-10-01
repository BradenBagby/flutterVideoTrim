# video_trim

Very simple video trimming that uses native libraries on iOS for a much faster experience than FFmpeg. 
Not UI based, can only trim via code.

###  To trim
This library only has one api call
```dart
  static Future<String?> trim(String path,
      {required int startMilliseconds,
      required int endMilliseconds}) 
```

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


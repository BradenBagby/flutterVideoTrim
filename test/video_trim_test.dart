import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_trim/video_trim.dart';

void main() {
  const MethodChannel channel = MethodChannel('video_trim');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await VideoTrim.platformVersion, '42');
  });
}

#import "VideoTrimPlugin.h"
#if __has_include(<video_trim/video_trim-Swift.h>)
#import <video_trim/video_trim-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "video_trim-Swift.h"
#endif

@implementation VideoTrimPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVideoTrimPlugin registerWithRegistrar:registrar];
}
@end

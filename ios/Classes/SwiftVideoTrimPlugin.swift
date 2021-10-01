import Flutter
import UIKit
import AVFoundation
import MobileCoreServices

public class SwiftVideoTrimPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "video_trim", binaryMessenger: registrar.messenger())
    let instance = SwiftVideoTrimPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? Dictionary<String, Any>
    if let path = args?["path"] as? String, let start = args?["start"] as? Int{
        let end = args?["end"] as? Int
        cropVideo(sourceURL1: URL.init(fileURLWithPath: path), statTime: Float(start), endTime: end == nil ? nil :Float(end!), result: result)
    }
  
  }
    
    // basically taken from https://stackoverflow.com/questions/35696188/how-to-trim-a-video-in-swift-for-a-particular-time
    func cropVideo(sourceURL1: URL, statTime:Float, endTime:Float?, result: @escaping FlutterResult)
{
    let manager = FileManager.default

    guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
    let mediaType = "mp4"
    if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String {
        let asset = AVAsset(url: sourceURL1 as URL)
        let start = statTime
        let end = endTime

        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(UUID().uuidString).\(mediaType)")
        }catch let error {
            print(error)
        }

        //Remove existing file
        _ = try? manager.removeItem(at: outputURL)


        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4

        let startTime = CMTime(seconds: Double(start ) / 1000, preferredTimescale: 1000)
        let endTime = endTime == nil ? asset.duration : CMTime(seconds: Double(end!) / 1000, preferredTimescale: 1000)
        let timeRange = CMTimeRange(start: startTime, end: endTime)

        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously{
            switch exportSession.status {
            case .completed:
                print("exported at \(outputURL)")
                result(outputURL.path);
            case .failed:
                print("failed \(exportSession.error)")
                result(FlutterError.init(code: "failed", message: "failed \(exportSession.error)", details: nil))

            case .cancelled:
                print("cancelled \(exportSession.error)")
                result(FlutterError.init(code: "cancelled", message: "cancelled \(exportSession.error)", details: nil))

            default: break
            }
        }
    }
}
}

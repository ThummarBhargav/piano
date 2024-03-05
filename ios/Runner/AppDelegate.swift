import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "samples.flutter.dev/firebase", binaryMessenger: controller.binaryMessenger)

        methodChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "setId" {
                if let args = call.arguments as? [String: Any],
                   let googleAdsId = args["googleAdsId"] as? String {
                    self?.updateGoogleAdsId(googleAdsId: googleAdsId,result: result)

                } else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func updateGoogleAdsId(googleAdsId: String,result: FlutterResult) {
        if let infoPlistPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
           var infoDict = NSDictionary(contentsOfFile: infoPlistPath) as? [String: Any] {
           print(infoDict["GADApplicationIdentifier"])
            infoDict["GADApplicationIdentifier"] = googleAdsId
            let nsDictionary = NSDictionary(dictionary: infoDict)
            nsDictionary.write(toFile: infoPlistPath, atomically: true)
           print(infoDict["GADApplicationIdentifier"])
            result("Success")

        }
    }

}

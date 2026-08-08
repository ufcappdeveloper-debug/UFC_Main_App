import UIKit
import Flutter
import GoogleMaps
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCOxC2Mz4hct7u3DLW4BSEsMesoT_vsxwU")
    FirebaseApp.configure()
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let pipChannel = FlutterMethodChannel(name: "agora_pip", binaryMessenger: controller.binaryMessenger)
    
//    pipChannel.setMethodCallHandler { call, result in
//      switch call.method {
//        case "setupAgora":
//          let args = call.arguments as! [String: Any]
//          let appId = args["appId"] as! String
//          let channel = args["channel"] as! String
//          let token = args["token"] as? String
//          let uid = args["uid"] as! UInt
//          AgoraPiPManager.shared.setupAgora(appId: appId, channel: channel, token: token, uid: uid)
//          result(nil)
//        case "startPiP":
//          AgoraPiPManager.shared.startPiP()
//          result(nil)
//        case "stopPiP":
//          AgoraPiPManager.shared.stopPiP()
//          result(nil)
//        default:
//          result(FlutterMethodNotImplemented)
//      }
//    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

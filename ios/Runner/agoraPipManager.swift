//import UIKit
//import AgoraRtcKit
//import AVKit
//
//
//@objcMembers
//class AgoraPiPManager: NSObject {
//    static let shared = AgoraPiPManager()
//
//    var agoraEngine: AgoraRtcEngineKit!
//    var remoteVideoView: UIView!
//    var pipController: AVPictureInPictureController?
//
//    func setupAgora(appId: String, channel: String, token: String?, uid: UInt) {
//        agoraEngine = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: nil)
//        agoraEngine.setChannelProfile(.communication)
//        agoraEngine.enableVideo()
//
//        let videoCanvas = AgoraRtcVideoCanvas()
//        remoteVideoView = UIView(frame: UIScreen.main.bounds)
//        videoCanvas.view = remoteVideoView
//        videoCanvas.renderMode = .hidden
//        videoCanvas.uid = uid
//        agoraEngine.setupRemoteVideo(videoCanvas)
//
//        agoraEngine.joinChannel(byToken: token, channelId: channel, info: nil, uid: 0) { _, _, _ in
//            print("Joined channel")
//        }
//
//        setupPiP()
//    }
//
//    func setupPiP() {
//        guard AVPictureInPictureController.isPictureInPictureSupported(),
//              let layer = remoteVideoView.layer as? AVSampleBufferDisplayLayer else {
//            print("PiP not supported or incompatible layer")
//            return
//        }
//
//        let contentSource = AVPictureInPictureController.ContentSource(sampleBufferDisplayLayer: layer, playbackDelegate: DummyPlaybackDelegate())
//        pipController = AVPictureInPictureController(contentSource: contentSource)
//    }
//
//    func startPiP() {
//        pipController?.startPictureInPicture()
//    }
//
//    func stopPiP() {
//        pipController?.stopPictureInPicture()
//    }
//}
//
//
//
//
//
//
//
//

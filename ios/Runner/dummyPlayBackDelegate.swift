//import AVKit
//import CoreMedia
//import UIKit
//
//class DummyPlaybackDelegate: NSObject, AVPictureInPictureSampleBufferPlaybackDelegate {
//
//    func pictureInPictureControllerIsPlaybackPaused(_ pictureInPictureController: AVPictureInPictureController) -> Bool {
//        return false
//    }
//
//    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, setPlaying playing: Bool) {
//        // No-op
//    }
//
//    func pictureInPictureControllerTimeRangeForPlayback(_ pictureInPictureController: AVPictureInPictureController) -> CMTimeRange {
//        return CMTimeRange(start: .zero, duration: .positiveInfinity)
//    }
//
//    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
//                                     skipIntervalForSkipping forward: Bool) -> CMTime {
//        return CMTime.zero
//    }
//
//    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
//                                     shouldSkipAfterElapsedTime elapsedTime: CMTime,
//                                     forward: Bool) -> Bool {
//        return false
//    }
//
//    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
//                                     didTransitionToRenderSize newRenderSize: CGSize) {
//        // No-op
//    }
//    
//    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
//                                     didPausePlayback pausePlayback: Bool) {
//        // No-op
//    }
//}

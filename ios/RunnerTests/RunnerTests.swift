import Flutter
import UIKit
import XCTest

class RunnerTests: XCTestCase {

  @MainActor
  func testSceneLaunchRendersFlutter() throws {
    let appDelegate = try XCTUnwrap(UIApplication.shared.delegate as? FlutterAppDelegate)
    let window = try XCTUnwrap(appDelegate.window)
    XCTAssertNotNil(window.windowScene, "The app must launch using the UIScene lifecycle.")
    let controller = try XCTUnwrap(window.rootViewController as? FlutterViewController)
    let firstFrame = XCTNSPredicateExpectation(
      predicate: NSPredicate { _, _ in controller.isDisplayingFlutterUI }, object: nil)
    XCTAssertEqual(XCTWaiter.wait(for: [firstFrame], timeout: 45), .completed,
                   "The app must render a Flutter frame after a cold launch.")
  }

}

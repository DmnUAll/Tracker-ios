//
//  Tracker_iosTests.swift
//  Tracker-iosTests
//
//  Created by Илья Валито on 05.05.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker_ios

final class TrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewController() throws {
        let viewController = TrackersScreenController()
//        let viewModel = TrackersScreenViewModel()
        assertSnapshots(matching: viewController, as: [.image])
    }
}

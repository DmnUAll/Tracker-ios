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

    func testLaunchScreen() throws {
        let viewController = LaunchScreenController()
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .light))])
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }

    func testOnboardingScreen() throws {
        let viewController = OnboardingPageController()
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .light))])
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }

    func testTrackersScreen() throws {
        let viewController = TrackersScreenController()
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .light))])
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }

    func testTrackerChoosingScreen() throws {
        let viewController = TrackerChoosingScreenController()
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .light))])
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }

    func testHabitCreationScreen() throws {
        let viewController = HabitCreationScreenController()
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .light))])
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }

    func testTrackerCategoryScreen() throws {
        let viewController = TrackerCategoryScreenController()
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .light))])
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }

    func testCategoryCreationScreen() throws {
        let viewController = CategoryCreationScreenController()
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .light))])
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }

    func testScheduleConfigurationScreen() throws {
        let viewController = ScheduleConfigurationScreenController()
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .light))])
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }

    func testStatisticsScreen() throws {
        let viewController = StatisticsScreenController()
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .light))])
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
}

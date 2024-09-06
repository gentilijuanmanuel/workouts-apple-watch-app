/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout manager that interfaces with HealthKit.
*/

import XCTest
@testable import MyWorkouts_WatchKit_App

class ExponentialMovingAverageTests: XCTestCase {
    
    func test_exponentialMovingAverage_withDefaultAlpha_shouldReturnCorrectValues() {
        var ema = ExponentialMovingAverage()
        
        XCTAssertEqual(ema.smoothPace(10), 10)
        XCTAssertEqual(ema.smoothPace(20), 12)
        XCTAssertEqual(ema.smoothPace(30), 15.6, accuracy: 0.001)
        XCTAssertEqual(ema.smoothPace(40), 20.48, accuracy: 0.001)
        XCTAssertEqual(ema.smoothPace(50), 26.384, accuracy: 0.001)
    }
    
    func test_exponentialMovingAverage_withCustomAlpha_shouldReturnCorrectValues() {
        var ema = ExponentialMovingAverage(alpha: 0.5)
        
        XCTAssertEqual(ema.smoothPace(10), 10)
        XCTAssertEqual(ema.smoothPace(20), 15)
        XCTAssertEqual(ema.smoothPace(30), 22.5)
        XCTAssertEqual(ema.smoothPace(40), 31.25)
        XCTAssertEqual(ema.smoothPace(50), 40.625)
    }
    
    func test_exponentialMovingAverage_withLargeNumbers_shouldReturnCorrectValues() {
        var ema = ExponentialMovingAverage()
        
        XCTAssertEqual(ema.smoothPace(1000), 1000)
        XCTAssertEqual(ema.smoothPace(2000), 1200)
        XCTAssertEqual(ema.smoothPace(3000), 1560, accuracy: 0.001)
        XCTAssertEqual(ema.smoothPace(4000), 2048, accuracy: 0.001)
        XCTAssertEqual(ema.smoothPace(5000), 2638.4, accuracy: 0.001)
    }
    
    func test_exponentialMovingAverage_withNegativeNumbers_shouldReturnCorrectValues() {
        var ema = ExponentialMovingAverage()
        
        XCTAssertEqual(ema.smoothPace(-10), -10)
        XCTAssertEqual(ema.smoothPace(-20), -12)
        XCTAssertEqual(ema.smoothPace(-30), -15.6, accuracy: 0.001)
        XCTAssertEqual(ema.smoothPace(-40), -20.48, accuracy: 0.001)
        XCTAssertEqual(ema.smoothPace(-50), -26.384, accuracy: 0.001)
    }
}

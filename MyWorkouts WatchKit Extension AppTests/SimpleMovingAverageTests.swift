/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Simple Moving Average algorithm tests.
*/

import XCTest
@testable import MyWorkouts_WatchKit_App

final class SimpleMovingAverageTests: XCTestCase {
    
    func test_simpleMovingAverage_withDefaultBufferSize_shouldReturnCorrectValues() {
        var sma = SimpleMovingAverage()
        
        XCTAssertEqual(sma.smoothPace(10), 10)
        XCTAssertEqual(sma.smoothPace(20), 15)
        XCTAssertEqual(sma.smoothPace(30), 20)
        XCTAssertEqual(sma.smoothPace(40), 25)
        XCTAssertEqual(sma.smoothPace(50), 30)
        
        // Test that it maintains the last 5 values
        XCTAssertEqual(sma.smoothPace(60), 40)
    }
    
    func test_simpleMovingAverage_withCustomBufferSize_shouldReturnCorrectValues() {
        var sma = SimpleMovingAverage(bufferSize: 3)
        
        XCTAssertEqual(sma.smoothPace(10), 10)
        XCTAssertEqual(sma.smoothPace(20), 15)
        XCTAssertEqual(sma.smoothPace(30), 20)
        
        // Test that it maintains only the last 3 values
        XCTAssertEqual(sma.smoothPace(40), 30)
    }
    
    func test_simpleMovingAverage_withLargeNumbers_shouldReturnCorrectValues() {
        var sma = SimpleMovingAverage()
        
        XCTAssertEqual(sma.smoothPace(1000), 1000)
        XCTAssertEqual(sma.smoothPace(2000), 1500)
        XCTAssertEqual(sma.smoothPace(3000), 2000)
        XCTAssertEqual(sma.smoothPace(4000), 2500)
        XCTAssertEqual(sma.smoothPace(5000), 3000)
    }
    
    func test_simpleMovingAverage_withNegativeNumbers_shouldReturnCorrectValues() {
        var sma = SimpleMovingAverage()
        
        XCTAssertEqual(sma.smoothPace(-10), -10)
        XCTAssertEqual(sma.smoothPace(-20), -15)
        XCTAssertEqual(sma.smoothPace(-30), -20)
        XCTAssertEqual(sma.smoothPace(-40), -25)
        XCTAssertEqual(sma.smoothPace(-50), -30)
    }
}

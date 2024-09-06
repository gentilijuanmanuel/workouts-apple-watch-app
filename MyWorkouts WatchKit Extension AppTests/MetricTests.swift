/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Description about what the file includes goes here.
*/

import Foundation
import XCTest

@testable import MyWorkouts_WatchKit_App

final class MetricTests: XCTestCase {

    func test_metricInitialization_shouldReturnCorrectValues() {
        let metric = Metric(
            kind: .activeEnergy(.kilocalories, Metric.activeEnergyFormatter),
            value: 100,
            description: "Active Energy"
        )
        
        XCTAssertEqual(metric.description, "Active Energy")
        XCTAssertEqual(metric.value, 100)
    }

    func test_setNewValue() {
        var metric = Metric(
            kind: .activeEnergy(.kilocalories, Metric.activeEnergyFormatter),
            value: 100
        )
        metric.set(newValue: 150)
        XCTAssertEqual(metric.value, 150)
    }

    func test_activeEnergy_formattedValue_shouldReturnCorrectValue() {
        let customFormatter = MeasurementFormatter()
        customFormatter.locale = Locale(identifier: "en_AR")
        customFormatter.unitOptions = .providedUnit
        customFormatter.numberFormatter.maximumFractionDigits = 2
        let energyMetric = Metric(
            kind: .activeEnergy(.kilocalories, customFormatter),
            value: 100.5
        )
        XCTAssertEqual(energyMetric.formattedValue, "100,5 kcal")
    }

    func test_heartRate_formattedValue_shouldReturnCorrectValue() {
        let customFormatter = NumberFormatter()
        customFormatter.locale = Locale(identifier: "en_AR")
        customFormatter.numberStyle = .decimal
        customFormatter.maximumFractionDigits = 2

        let heartRateMetric = Metric(
            kind: .hearthRate(.bpm, customFormatter),
            value: 75.56
        )
        XCTAssertEqual(heartRateMetric.formattedValue, "75,56bpm")
    }

    func test_distance_formattedValue_shouldReturnCorrectValue() {
        let customFormatter = MeasurementFormatter()
        customFormatter.locale = Locale(identifier: "en_AR")
        customFormatter.unitOptions = .providedUnit
        customFormatter.numberFormatter.numberStyle = .decimal
        customFormatter.numberFormatter.maximumFractionDigits = 2
        let distanceMetricWithCustomFormatter = Metric(
            kind: .distance(.kilometers, customFormatter),
            value: 5.55
        )
        XCTAssertEqual(distanceMetricWithCustomFormatter.formattedValue, "5,55 km")
    }

    func test_speed_formattedValue_naturalScale_shouldReturnCorrectValue() {
        let customFormatter = MeasurementFormatter()
        customFormatter.locale = Locale(identifier: "en_AR")
        customFormatter.unitOptions = .naturalScale
        customFormatter.numberFormatter.maximumFractionDigits = 0
        let currentPaceMetric = Metric(
            kind: .currentPace(.metersPerSecond, customFormatter),
            value: 5.5
        )
        let averagePaceMetric = Metric(
            kind: .averagePace(.metersPerSecond, customFormatter),
            value: 5.5
        )
        XCTAssertEqual(currentPaceMetric.formattedValue, "20 km/h")
        XCTAssertEqual(averagePaceMetric.formattedValue, "20 km/h")
    }

    func test_speed_formattedValue_providedUnit_shouldReturnCorrectValue() {
        let customFormatter = MeasurementFormatter()
        customFormatter.locale = Locale(identifier: "en_AR")
        customFormatter.unitOptions = .providedUnit
        customFormatter.numberFormatter.maximumFractionDigits = 0
        let currentPaceMetric = Metric(
            kind: .currentPace(.metersPerSecond, customFormatter),
            value: 5.5
        )
        let averagePaceMetric = Metric(
            kind: .averagePace(.metersPerSecond, customFormatter),
            value: 5.5
        )
        XCTAssertEqual(currentPaceMetric.formattedValue, "6 m/s")
        XCTAssertEqual(averagePaceMetric.formattedValue, "6 m/s")
    }

    func test_cadence_formattedValue_shouldReturnCorrectValue() {
        let customFormatter = NumberFormatter()
        customFormatter.locale = Locale(identifier: "en_AR")
        customFormatter.numberStyle = .decimal
        customFormatter.maximumFractionDigits = 2

        let cadenceMetric = Metric(
            kind: .cadence(.spm, customFormatter),
            value: 75.56
        )
        XCTAssertEqual(cadenceMetric.formattedValue, "75,56spm")
    }
}


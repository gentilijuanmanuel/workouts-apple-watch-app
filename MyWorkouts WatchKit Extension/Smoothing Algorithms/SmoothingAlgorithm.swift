/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout manager that interfaces with HealthKit.
*/


// MARK: - Smoothing Algorithm Protocol

protocol SmoothingAlgorithm {
    mutating func smoothPace(_ newPace: Double) -> Double
}

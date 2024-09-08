/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The SmoothingAlgorithm protocol.
*/


// MARK: - Smoothing Algorithm Protocol

/// A protocol that defines the interface for smoothing algorithms used in workout pace calculations.
///
/// Smoothing algorithms are used to reduce noise and fluctuations in raw pace data,
/// providing a more stable and readable pace metric during workouts.
protocol SmoothingAlgorithm {
    /// Calculates a smoothed pace value based on a new pace input.
    ///
    /// This method takes a new pace value and returns a smoothed version of the pace.
    /// The exact smoothing behavior depends on the specific implementation of the algorithm.
    ///
    /// - Parameter newPace: The latest raw pace value to be smoothed.
    /// - Returns: The smoothed pace value after applying the algorithm.
    ///
    /// - Note: Implementations of this method may maintain internal state to perform smoothing across multiple calls.
    mutating func smoothPace(_ newPace: Double) -> Double
}

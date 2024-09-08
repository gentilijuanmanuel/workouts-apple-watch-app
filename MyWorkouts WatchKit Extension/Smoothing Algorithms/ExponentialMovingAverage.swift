/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout manager that interfaces with HealthKit.
*/

// MARK: - Exponential Moving Average (EMA)

/// A structure that implements the Exponential Moving Average (EMA) smoothing algorithm.
///
/// EMA is a type of moving average that gives more weight to recent data points. This makes it
/// more responsive to new information compared to a Simple Moving Average (SMA).
struct ExponentialMovingAverage: SmoothingAlgorithm {

    /// The previous EMA value. Initialized to 0.
    private var prevEMA: Double = 0
    
    /// The smoothing factor. Determines the weight given to the most recent data point.
    /// A higher alpha discounts older observations faster. The value should be between 0 and 1.
    private let alpha: Double
    
    /// Initializes a new instance of the Exponential Moving Average algorithm.
    ///
    /// - Parameter alpha: The smoothing factor. Default is 0.2.
    ///   - Must be between 0 and 1.
    ///   - A higher value makes the EMA more responsive to recent changes.
    ///   - A lower value makes the EMA more stable, smoothing out short-term fluctuations.
    init(alpha: Double = 0.2) {
        self.alpha = alpha
    }
    
    /// Calculates the smoothed pace using the Exponential Moving Average algorithm.
    ///
    /// - Parameter newPace: The new pace value to be incorporated into the average.
    /// - Returns: The smoothed pace value.
    ///
    /// This method updates the internal state (`prevEMA`) each time it's called.
    /// If it's the first call (`prevEMA` is 0), it sets `prevEMA` to the new pace.
    /// For subsequent calls, it calculates the EMA using the formula:
    /// EMA = α * newValue + (1 - α) * previousEMA
    mutating func smoothPace(_ newPace: Double) -> Double {
        if prevEMA == 0 {
            prevEMA = newPace
        } else {
            prevEMA = alpha * newPace + (1 - alpha) * prevEMA
        }
        return prevEMA
    }
}

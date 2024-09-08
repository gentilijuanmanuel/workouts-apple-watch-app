/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The Simple Moving Average (SMA) algorithm.
*/

// MARK: - Simple Moving Average (SMA)

/// A structure that implements the Simple Moving Average (SMA) smoothing algorithm.
///
/// SMA calculates the arithmetic mean of a given set of values over a specified period.
/// It's useful for smoothing out short-term fluctuations and highlighting longer-term trends or cycles.
struct SimpleMovingAverage: SmoothingAlgorithm {
    /// A buffer to store the most recent pace values.
    private var paceBuffer: [Double] = []
    
    /// The maximum number of values to consider in the moving average calculation.
    private let bufferSize: Int
    
    /// Initializes a new instance of the Simple Moving Average algorithm.
    ///
    /// - Parameter bufferSize: The number of recent values to consider when calculating the average.
    ///   Default is 5.
    ///   - A larger buffer size will result in a smoother average but will be less responsive to recent changes.
    ///   - A smaller buffer size will be more responsive to recent changes but may be more volatile.
    init(bufferSize: Int = 5) {
        self.bufferSize = bufferSize
    }
    
    /// Calculates the smoothed pace using the Simple Moving Average algorithm.
    ///
    /// - Parameter newPace: The new pace value to be incorporated into the average.
    /// - Returns: The smoothed pace value.
    ///
    /// This method updates the internal buffer (`paceBuffer`) each time it's called:
    /// 1. It appends the new pace value to the buffer.
    /// 2. If the buffer exceeds the specified size, it removes the oldest value.
    /// 3. It then calculates and returns the average of all values in the buffer.
    mutating func smoothPace(_ newPace: Double) -> Double {
        paceBuffer.append(newPace)
        
        if paceBuffer.count > bufferSize {
            paceBuffer.removeFirst()
        }
        
        let sum = paceBuffer.reduce(0, +)
        return sum / Double(paceBuffer.count)
    }
}

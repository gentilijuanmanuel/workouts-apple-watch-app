/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout manager that interfaces with HealthKit.
*/

// MARK: - Exponential Moving Average (EMA)

struct ExponentialMovingAverage: SmoothingAlgorithm {
    private var prevEMA: Double = 0
    private let alpha: Double
    
    init(alpha: Double = 0.2) {
        self.alpha = alpha
    }
    
    mutating func smoothPace(_ newPace: Double) -> Double {
        if prevEMA == 0 {
            prevEMA = newPace
        } else {
            prevEMA = alpha * newPace + (1 - alpha) * prevEMA
        }
        return prevEMA
    }
}

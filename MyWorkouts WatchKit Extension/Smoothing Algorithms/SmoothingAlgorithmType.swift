/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout manager that interfaces with HealthKit.
*/

// MARK: - Smoothing Algorithm Type Enum

enum SmoothingAlgorithmType {
    case simpleMovingAverage(bufferSize: Int)
    case exponentialMovingAverage(alpha: Double)
    
    func makeAlgorithm() -> SmoothingAlgorithm {
        switch self {
        case .simpleMovingAverage(let bufferSize):
            return SimpleMovingAverage(bufferSize: bufferSize)
        case .exponentialMovingAverage(let alpha):
            return ExponentialMovingAverage(alpha: alpha)
        }
    }
}

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout manager that interfaces with HealthKit.
*/

// MARK: - Simple Moving Average (SMA)

struct SimpleMovingAverage: SmoothingAlgorithm {
    private var paceBuffer: [Double] = []
    private let bufferSize: Int
    
    init(bufferSize: Int = 5) {
        self.bufferSize = bufferSize
    }
    
    mutating func smoothPace(_ newPace: Double) -> Double {
        paceBuffer.append(newPace)
        
        if paceBuffer.count > bufferSize {
            paceBuffer.removeFirst()
        }
        
        let sum = paceBuffer.reduce(0, +)
        return sum / Double(paceBuffer.count)
    }
}

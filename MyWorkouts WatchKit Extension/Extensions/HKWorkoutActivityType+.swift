/*
See LICENSE folder for this sample’s licensing information.

Abstract:
HKWorkoutActivityType extensions.
*/

import HealthKit

// MARK: - HKWorkoutActivityType+

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }

    var name: String {
        switch self {
        case .running:
            return "Run"
        case .cycling:
            return "Bike"
        case .walking:
            return "Walk"
        default:
            return ""
        }
    }
}

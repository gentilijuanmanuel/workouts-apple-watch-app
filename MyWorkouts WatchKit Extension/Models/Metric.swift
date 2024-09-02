/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout metric model.
*/

import Foundation

// MARK: - Metric

struct Metric: Identifiable {

    enum Kind {
        case activeEnergy(UnitEnergy)
        case hearthRate
        case distance(UnitLength)
        case currentPace(UnitSpeed)
        case averagePace(UnitSpeed)
        case cadence
    }

    let id = UUID()
    let description: String?
    private let kind: Kind
    private var value: Double

    var formattedValue: String {
        switch kind {
        case let .activeEnergy(unit):
            Measurement(value: value, unit: unit)
                .formatted(
                    .measurement(
                        width: .abbreviated,
                        usage: .workout,
                        numberFormatStyle: .number.precision(.fractionLength(0))
                    )
                )
        case .hearthRate:
            value.formatted(.number.precision(.fractionLength(0))) + " bpm"
        case let .distance(unit):
            Measurement(value: value, unit: unit)
                .formatted(
                    .measurement(
                        width: .abbreviated,
                        usage: .road
                    )
                )
        case let .currentPace(unit):
            Measurement( value: value, unit: unit)
                .formatted(.measurement(width: .abbreviated))
        case let .averagePace(unit):
            Measurement( value: value, unit: unit)
                .formatted(.measurement(width: .abbreviated))
        case .cadence:
            value.formatted(.number.precision(.fractionLength(0))) + " rpm"
        }
    }

    init(kind: Kind, value: Double, description: String? = nil) {
        self.kind = kind
        self.value = value
        self.description = description
    }

    mutating func set(newValue: Double) {
        self.value = newValue
    }
}

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout metric model.
*/

import Foundation
import HealthKit

// MARK: - Metric

struct Metric: Identifiable {

    enum Kind {
        case activeEnergy(UnitEnergy, MeasurementFormatter)
        case hearthRate(UnitHearthRate, NumberFormatter)
        case distance(UnitLength, MeasurementFormatter)
        case currentPace(UnitSpeed, MeasurementFormatter)
        case averagePace(UnitSpeed, MeasurementFormatter)
        case cadence(UnitCadence, NumberFormatter)

        enum UnitHearthRate: String {
            case bpm
        }

        enum UnitCadence: String {
            case rpm
            case spm
        }
    }

    let id = UUID()
    let description: String?
    let kind: Kind
    private(set) var value: Double

    var formattedValue: String {
        switch kind {
        case let .activeEnergy(unit, formatter):
            return formatter.string(from: Measurement(value: value, unit: unit))
        case let .hearthRate(unit, formatter):
            guard let formattedNumber = formatter.string(from: NSNumber(value: value)) else {
                return "\(Int(value))\(unit.rawValue)"
            }
            return "\(formattedNumber)\(unit.rawValue)"
        case let .distance(unit, formatter):
            return formatter.string(from: Measurement(value: value, unit: unit))
        case let .currentPace(unit, formatter):
            return formatter.string(from: Measurement(value: value, unit: unit))
        case let .averagePace(unit, formatter):
            return formatter.string(from: Measurement(value: value, unit: unit))
        case let .cadence(unit, formatter):
            guard let formattedNumber = formatter.string(from: NSNumber(value: value)) else {
                return "\(Int(value))\(unit.rawValue)"
            }
            return "\(formattedNumber)\(unit.rawValue)"
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

// MARK: - Available Formatters

extension Metric {
    static let activeEnergyFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .short
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }()
    
    static let distanceFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .short
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }()
    
    static let speedFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.unitStyle = .short
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }()

    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter
    }()
}

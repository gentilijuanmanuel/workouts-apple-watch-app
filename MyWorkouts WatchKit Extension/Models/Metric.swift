/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout metric model.
*/

import Foundation
import HealthKit

/// A structure representing a workout metric.
///
/// `Metric` encapsulates various types of measurements that can be tracked during a workout,
/// such as heart rate, energy expenditure, distance, pace, and cadence.
struct Metric: Identifiable {

    /// Enumeration representing different types of metrics and their associated units.
    enum Kind: Equatable {
        /// Active energy burned during the workout.
        case activeEnergy(UnitEnergy, MeasurementFormatter)
        
        /// Heart rate during the workout.
        case hearthRate(UnitHearthRate, NumberFormatter)
        
        /// Distance covered during the workout.
        case distance(UnitLength, MeasurementFormatter)
        
        /// Current pace of the workout.
        case currentPace(UnitSpeed, MeasurementFormatter)
        
        /// Average pace of the workout.
        case averagePace(UnitSpeed, MeasurementFormatter)
        
        /// Cadence during the workout.
        case cadence(UnitCadence, NumberFormatter)

        /// Enumeration representing units for heart rate measurement.
        enum UnitHearthRate: String {
            /// Beats per minute.
            case bpm
        }

        /// Enumeration representing units for cadence measurement.
        enum UnitCadence: String {
            /// Revolutions per minute.
            case rpm
            /// Steps per minute.
            case spm
        }
    }

    /// A unique identifier for the metric.
    let id = UUID()
    
    /// An optional description of the metric.
    let description: String?
    
    /// The kind of metric, including its unit and formatter.
    let kind: Kind
    
    /// The current value of the metric.
    private(set) var value: Double

    /// A formatted string representation of the metric's value.
    ///
    /// This property uses the appropriate formatter based on the metric's kind to create a
    /// human-readable string representation of the metric's value, including its unit.
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

    /// Initializes a new metric.
    ///
    /// - Parameters:
    ///   - kind: The kind of metric, including its unit and formatter.
    ///   - value: The initial value of the metric.
    ///   - description: An optional description of the metric.
    init(kind: Kind, value: Double, description: String? = nil) {
        self.kind = kind
        self.value = value
        self.description = description
    }

    /// Updates the value of the metric.
    ///
    /// - Parameter newValue: The new value to set for the metric.
    mutating func set(newValue: Double) {
        self.value = newValue
    }
}

// MARK: - Available Formatters

extension Metric {
    /// A formatter for active energy measurements.
    static let activeEnergyFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .short
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }()
    
    /// A formatter for distance measurements.
    static let distanceFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .short
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }()
    
    /// A formatter for speed measurements.
    static let speedFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.unitStyle = .short
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }()

    /// A formatter for number measurements.
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter
    }()
}

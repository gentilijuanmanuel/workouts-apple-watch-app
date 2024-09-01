/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout metrics view.
*/

import SwiftUI
import HealthKit
import Foundation

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

    init(kind: Kind, value: Double) {
        self.kind = kind
        self.value = value
    }

    mutating func set(newValue: Double) {
        self.value = newValue
    }
}

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager

    private let metrics: [Metric]
    
    var body: some View {
        TimelineView(
            MetricsTimelineSchedule(
                from: workoutManager.builder?.startDate ?? Date(),
                isPaused: workoutManager.session?.state == .paused
            )
        ) { context in
            ScrollView {
                VStack(alignment: .leading) {
                    ElapsedTimeView(
                        elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0,
                        showSubseconds: context.cadence == .live
                    )
                        .foregroundStyle(.yellow)

                    ForEach(metrics) { metric in
                        Text(metric.formattedValue)
                    }
                }
                .font(
                    .system(
                        .title,
                        design: .rounded
                    )
                    .monospacedDigit()
                    .lowercaseSmallCaps()
                )
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
        }
    }

    init(metrics: [Metric]) {
        self.metrics = metrics
    }
}

// MARK: - Previews

struct MetricsView_Previews: PreviewProvider {
    static let workoutManager = WorkoutManager()
    static var previews: some View {
        MetricsView(
            metrics: [
                Metric(kind: .activeEnergy(.kilocalories), value: 0)
            ]
        )
        .environmentObject(workoutManager)
    }
}

// MARK: - MetricsTimelineSchedule

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool

    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate,
                                                    by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
}

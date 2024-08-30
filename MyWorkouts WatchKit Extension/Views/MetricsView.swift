/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout metrics view.
*/

import SwiftUI
import HealthKit

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
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

                    // Active energy
                    Text(
                        Measurement(
                            value: workoutManager.activeEnergy,
                            unit: UnitEnergy.kilocalories
                        )
                            .formatted(
                                .measurement(
                                    width: .abbreviated,
                                    usage: .workout,
                                    numberFormatStyle: .number.precision(.fractionLength(0)
                                                                        )
                                )
                            )
                    )

                    // Hearth Rate
                    Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")

                    // Distance
                    Text(
                        Measurement(
                            value: workoutManager.distance,
                            unit: UnitLength.meters
                        )
                        .formatted(
                            .measurement(
                                width: .abbreviated,
                                usage: .road
                            )
                        )
                    )

                    // Current Pace
                    Text(
                        Measurement(
                            value: workoutManager.currentPace,
                            unit: UnitSpeed.metersPerSecond
                        )
                        .formatted(.measurement(width: .abbreviated))
                    )

                    // Average Pace
                    Text(
                        Measurement(
                            value: workoutManager.averagePace,
                            unit: UnitSpeed.metersPerSecond
                        )
                        .formatted(.measurement(width: .abbreviated))
                    )

                    // Cadence
                    Text(workoutManager.cadence.formatted(.number.precision(.fractionLength(0))) + " rpm")
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
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
            .environmentObject(WorkoutManager())
    }
}

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

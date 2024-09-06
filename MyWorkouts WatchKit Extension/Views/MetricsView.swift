/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout metrics view.
*/

import SwiftUI

// MARK: - MetricsView

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
                        MetricRowView(metric: metric)
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
                Metric(
                    kind: .activeEnergy(.kilocalories, Metric.activeEnergyFormatter),
                    value: 0
                )
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

// MARK: - MetricRowView

struct MetricRowView: View {
    private enum Layout {
        static let stackSpacing: CGFloat = -8
    }

    private let metric: Metric
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.stackSpacing) {
            if let description = metric.description {
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Text(metric.formattedValue)
        }
    }

    init(metric: Metric) {
        self.metric = metric
    }
}

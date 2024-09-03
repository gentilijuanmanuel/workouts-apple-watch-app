/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout summary view.
*/

import SwiftUI

// MARK: - SummaryView

struct SummaryView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) var dismiss
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        if workoutManager.workout == nil {
            ProgressView("Saving Workout")
                .navigationBarHidden(true)
        } else {
            ScrollView {
                VStack(alignment: .leading) {
                    SummaryMetricView(
                        title: "Total Time",
                        value: durationFormatter.string(from: workoutManager.workout?.duration ?? 0.0) ?? ""
                    )
                        .foregroundStyle(.yellow)
                    SummaryMetricView(
                        title: "Total Distance",
                        value: Measurement(
                            value: workoutManager.workout?.totalDistance?.doubleValue(for: .meter()) ?? 0,
                            unit: UnitLength.meters
                        )
                        .formatted(
                            .measurement(
                                width: .abbreviated,
                                usage: .road,
                                numberFormatStyle: .number.precision(.fractionLength(2))
                            )
                        )
                    )
                    .foregroundStyle(.green)
                    SummaryMetricView(
                        title: "Total Energy",
                        value: Measurement(
                            value: workoutManager.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                            unit: UnitEnergy.kilocalories
                        )
                        .formatted(
                            .measurement(
                                width: .abbreviated,
                                usage: .workout,
                                numberFormatStyle: .number.precision(.fractionLength(0))
                            )
                        )
                    )
                    .foregroundStyle(.pink)
                    SummaryMetricView(
                        title: "Avg. Heart Rate",
                        value: workoutManager.averageHeartRate.formattedValue
                    )
                    .foregroundStyle(.red)
                    if shouldShowAveragePaceView {
                        SummaryMetricView(
                            title: "Avg. Pace",
                            value: workoutManager.averagePace.formattedValue
                        )
                        .foregroundStyle(.cyan)
                    }
                    Text("Activity Rings")
                    ActivityRingsView(healthStore: workoutManager.healthStore)
                        .frame(width: 50, height: 50)
                    Button("Done") {
                        dismiss()
                    }
                }
                .scenePadding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var shouldShowAveragePaceView: Bool {
        guard let selectedWorkout = workoutManager.selectedWorkout else {
            return false
        }

        switch selectedWorkout {
        case .cycling:
            if #available(watchOS 10.0, *) {
                return true
            } else {
                return false
            }
        case .running:
            if #available(watchOS 9.0, *) {
                return true
            } else {
                return false
            }
        case .walking:
            return true
        default:
            return false
        }
    }
}

// MARK: - Previews

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView().environmentObject(WorkoutManager())
    }
}

// MARK: - SummaryMetricView

struct SummaryMetricView: View {
    var title: String
    var value: String

    var body: some View {
        Text(title)
            .foregroundStyle(.foreground)
        Text(value)
            .font(.system(.title2, design: .rounded).lowercaseSmallCaps())
        Divider()
    }
}

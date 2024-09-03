/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The paging view to switch between controls, metrics, and now playing views.
*/

import SwiftUI
import WatchKit
import HealthKit

// MARK: - SessionPagingView

struct SessionPagingView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection: Tab = .metrics

    enum Tab {
        case controls, metrics, moreMetrics, nowPlaying
    }

    var body: some View {
        TabView(selection: $selection) {
            ControlsView()
                .tag(Tab.controls)
            MetricsView(metrics: metrics())
                .tag(Tab.metrics)
            if let metrics = moreMetrics(for: workoutManager.selectedWorkout) {
                MetricsView(metrics: metrics)
                    .tag(Tab.moreMetrics)
            }
            NowPlayingView()
                .tag(Tab.nowPlaying)
        }
        .navigationTitle(workoutManager.selectedWorkout?.name ?? "")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(selection == .nowPlaying)
        .onChange(of: workoutManager.running) { _ in
            displayMetricsView()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .onChange(of: isLuminanceReduced) { _ in
            displayMetricsView()
        }
    }

    private func displayMetricsView() {
        withAnimation {
            selection = .metrics
        }
    }

    private func metrics() -> [Metric] {
        [
            workoutManager.activeEnergy,
            workoutManager.averageHeartRate,
            workoutManager.distance
        ]
    }

    private func moreMetrics(for workoutType: HKWorkoutActivityType?) -> [Metric]? {
        guard let workoutType = workoutType else { return nil }

        switch workoutType {
        case .cycling:
            if #available(watchOS 10.0, *) {
                return [
                    workoutManager.currentPace,
                    workoutManager.averagePace,
                    workoutManager.cyclingCadence
                ]
            } else {
                return nil
            }
        case .walking:
            return [
                workoutManager.currentPace,
                workoutManager.averagePace,
                workoutManager.walkingRunningCadence
            ]
        case .running:
            if #available(watchOS 9.0, *) {
                return [
                    workoutManager.currentPace,
                    workoutManager.averagePace,
                    workoutManager.walkingRunningCadence
                ]
            } else {
                return nil
            }
        default:
            return []
        }
    }
}

// MARK: - Previews

struct PagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView().environmentObject(WorkoutManager())
    }
}

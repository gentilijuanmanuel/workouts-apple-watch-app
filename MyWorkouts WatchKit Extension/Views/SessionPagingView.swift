/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The paging view to switch between controls, metrics, and now playing views.
*/

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection: Tab = .metrics

    enum Tab {
        case controls, metrics, moreMetrics, nowPlaying
    }

    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            MetricsView(
                metrics: [
                    .activeEnergy(workoutManager.activeEnergy, UnitEnergy.kilocalories),
                    .hearthRate(workoutManager.averageHeartRate),
                    .distance(workoutManager.distance, UnitLength.meters)
                ]
            )
            .tag(Tab.metrics)
            MetricsView(
                metrics: [
                    .currentPace(workoutManager.activeEnergy, UnitSpeed.metersPerSecond),
                    .averagePage(workoutManager.averagePace, UnitSpeed.metersPerSecond),
                    .cadence(workoutManager.cadence)
                ]
            )
            .tag(Tab.moreMetrics)
            NowPlayingView().tag(Tab.nowPlaying)
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
}

struct PagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView().environmentObject(WorkoutManager())
    }
}

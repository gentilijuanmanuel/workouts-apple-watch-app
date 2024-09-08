/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The metric row view.
*/
import SwiftUI

// MARK: - MetricRowView

struct MetricRowView: View {
    private enum Layout {
        static let stackSpacing: CGFloat = 0
        static let formattedValueStackSpacing: CGFloat = 4
    }

    private let metric: Metric
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.stackSpacing) {
            if let description = metric.description {
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            formattedValueView
        }
    }

    private var formattedValueView: some View {
        HStack(spacing: Layout.formattedValueStackSpacing) {
            Text(metric.formattedValue)
            if case .hearthRate(_, _) = metric.kind {
                AnimatedHeartView()
            }
        }
    }

    init(metric: Metric) {
        self.metric = metric
    }
}

// MARK: - Previews

#Preview {
    MetricRowView(
        metric: Metric(
            kind: .averagePace(.kilometersPerHour, Metric.speedFormatter),
            value: 15,
            description: "Avg. Pace"
        )
    )
}

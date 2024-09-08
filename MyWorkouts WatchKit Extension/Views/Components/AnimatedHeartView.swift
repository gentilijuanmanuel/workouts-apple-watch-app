/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A hearth animation view.
*/

import SwiftUI

// MARK: - AnimatedHeartView

struct AnimatedHeartView: View {

    private enum Layout {
        enum Animation {
            static let expanded: CGFloat = 1.2
            static let collapsed: CGFloat = 1
            static let duration: CGFloat = 0.5
        }
        static let iconName: String = "heart.fill"
        static let defaultSize: CGFloat = 10
    }

    @State private var isAnimating = false

    private let size: CGFloat
    
    var body: some View {
        Image(systemName: Layout.iconName)
            .resizable()
            .foregroundColor(.red)
            .frame(width: size, height: size)
            .scaleEffect(
                isAnimating
                ? Layout.Animation.expanded
                : Layout.Animation.collapsed
            )
            .animation(
                Animation.easeInOut(duration: Layout.Animation.duration)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }

    init(size: CGFloat = Layout.defaultSize) {
        self.size = size
    }
}

// MARK: - Previews

#Preview {
    AnimatedHeartView(size: 40)
}

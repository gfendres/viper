import Foundation
import UIKit

struct TrackViewModel {
    let title: String
    let color: UIColor
}

extension  TrackViewModel: Equatable {
    static func ==(lhs: TrackViewModel, rhs: TrackViewModel) -> Bool {
        return lhs.title == rhs.title && lhs.color == rhs.color
    }
}
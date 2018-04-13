import Foundation
import UIKit

protocol TrackColoring {
    func color(for track: Track) -> UIColor
}

class ColorResolver: TrackColoring {

    func color(for track: Track) -> UIColor {
        return UIColor(
            red: CGFloat(Double(track.id) / 10.0),
            green: CGFloat(Double(track.title.count) / 20.0),
            blue: CGFloat(Double(track.artist.count) / 20.0), alpha: 1)
    }
}

import Foundation
import UIKit
@testable import SampleViper

class MockTrackColoring: TrackColoring {

    var colorForTrackStub: UIColor = .red
    var colorForTrackCallCount = 0
    var colorForTrackSpy: Track?

    func color(for track: Track) -> UIColor {
        colorForTrackSpy = track
        colorForTrackCallCount += 1
        return colorForTrackStub
    }
}

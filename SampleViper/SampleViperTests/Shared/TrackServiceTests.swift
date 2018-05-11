import XCTest
@testable import SampleViper

class TrackServiceTests: XCTestCase {
    
    var subject: TrackService!
    var mockTracks: [Track] = MockTrackServicing.makeMockTracks()

    // MARK: - Setup / Tear down
        
    override func setUp() {
        super.setUp()
        subject = TrackService()
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_fetch_shouldCallCompletionWithTracks() {
        subject.fetch { tracks in
            XCTAssertNotNil(tracks)
        }
    }

    func test_addTrack_shouldAppendTrack() {
        let title = "mockTitle"
        let artist = "mockArtist"

        subject.addTrack(title: title, artist: artist) { result in
            guard case let Result.success(tracks) = result,
                let track = tracks.last else {
                XCTFail()
                return
            }
            XCTAssertEqual(track.title, title)
            XCTAssertEqual(track.artist, artist)
            XCTAssertEqual(track.id, tracks.count)
        }
    }
}

import Foundation
@testable import SampleViper

class MockTrackServicing: TrackServicing {

    var fetchCallCount = 0
    var fetchSpy: (([Track]) -> ())?
    var fetchStub = MockTrackServicing.makeMockTracks()

    func fetch(completion: @escaping ([Track]) -> ()) {
        fetchCallCount += 1
        fetchSpy = completion
        completion(fetchStub)
    }

    var addTrackTitleArtistCallCount = 0
    var addTrackTitleArtistSpy: (title: String, artist: String, completion: () -> Void)?

    func addTrack(title: String, artist: String, completion: @escaping () -> Void) {
        addTrackTitleArtistCallCount += 1
        addTrackTitleArtistSpy = (title: title, artist: artist, completion: completion)
        completion()
    }

    var deleteTrackCompletionCallCount = 0
    var deleteTrackCompletionSpy: (track: Track, completion: () -> Void)?

    func delete(track: Track, completion: @escaping () -> Void) {
        deleteTrackCompletionCallCount += 1
        deleteTrackCompletionSpy = (track: track, completion: completion)
        completion()
    }

    // MARK: - Static

    static func makeMockTracks() -> [Track] {
        return [
            Track(id: 0, title: "mockTitle", artist: "mockArtist"),
            Track(id: 1, title: "mockTitle2", artist: "mockArtist2")
        ]
    }
}

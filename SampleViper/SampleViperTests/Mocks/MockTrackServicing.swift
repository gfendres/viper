import Foundation
@testable import SampleViper

class MockTrackServicing: TrackServicing {

    var fetchCallCount = 0
    var fetchSpy: ((Result<[Track]>) -> ())?
    var fetchStub: Result<[Track]>?

    func fetch(completion: @escaping (Result<[Track]>) -> ()) {
        fetchCallCount += 1
        fetchSpy = completion
        completion(fetchStub!)
    }

    var addTrackTitleArtistCallCount = 0
    var addTrackTitleArtistSpy: (title: String, artist: String, completion: (Result<[Track]>) -> Void)?
    var addTrackTitleArtistStub: Result<[Track]>?

    func addTrack(title: String, artist: String, completion: @escaping (Result<[Track]>) -> Void) {
        addTrackTitleArtistCallCount += 1
        addTrackTitleArtistSpy = (title: title, artist: artist, completion: completion)
        completion(addTrackTitleArtistStub!)
    }

    var deleteTrackCompletionCallCount = 0
    var deleteTrackCompletionSpy: (track: Track, completion: (Result<[Track]>) -> Void)?
    var deleteTrackCompletionStub: Result<[Track]>?

    func delete(track: Track, completion: @escaping (Result<[Track]>) -> Void) {
        deleteTrackCompletionCallCount += 1
        deleteTrackCompletionSpy = (track: track, completion: completion)
        completion(deleteTrackCompletionStub!)
    }

    // MARK: - Static

    static func makeMockTracks() -> [Track] {
        return [
            Track(id: 0, title: "mockTitle", artist: "mockArtist"),
            Track(id: 1, title: "mockTitle2", artist: "mockArtist2")
        ]
    }
}

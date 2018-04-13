import Foundation
import UIKit
@testable import SampleViper

open class MockTracksInteracting: TracksInteracting {

    // MARK: - Variables

    public var delegate: TracksInteractorDelegate?

    // MARK: - Init

    public init() { }

    //MARK: - fetchTracks

    public var fetchTracksCallCount = 0

    public func fetchTracks() {
        fetchTracksCallCount += 1
    }

    //MARK: - addTrack

    public var addTrackTitleArtistCallCount = 0
    public var addTrackTitleArtistSpy: (title: String, artist: String)?

    public func addTrack(title: String, artist: String) {
        addTrackTitleArtistCallCount += 1
        addTrackTitleArtistSpy = (title: title, artist: artist)
    }

    //MARK: - delete

    public var deleteTrackCallCount = 0
    public var deleteTrackSpy: Track?

    public func delete(track: Track) {
        deleteTrackCallCount += 1
        deleteTrackSpy = track
    }

}

open class MockTracksInteractorDelegate: TracksInteractorDelegate {

    //MARK: - fetched

    public var fetchedTracksCallCount = 0
    public var fetchedTracksSpy: [Track]?

    public func fetched(tracks: [Track]) {
        fetchedTracksCallCount += 1
        fetchedTracksSpy = tracks
    }

}

open class MockTracksPresenting: TracksPresenting {
    // MARK: - Variables

    public var view: TracksViewing?

    // MARK: - Init

    public init() { }

    //MARK: - viewDidLoad

    public var viewDidLoadCallCount = 0

    public func viewDidLoad() {
        viewDidLoadCallCount += 1
    }

    //MARK: - didTapAdd

    public var didTapAddTitleArtistCallCount = 0
    public var didTapAddTitleArtistSpy: (title: String, artist: String)?

    public func didTapAdd(title: String, artist: String) {
        didTapAddTitleArtistCallCount += 1
        didTapAddTitleArtistSpy = (title: title, artist: artist)
    }

    //MARK: - didSwipeToDelete

    public var didSwipeToDeleteAtCallCount = 0
    public var didSwipeToDeleteAtSpy: Int?

    public func didSwipeToDelete(at row: Int) {
        didSwipeToDeleteAtCallCount += 1
        didSwipeToDeleteAtSpy = row
    }

}
open class MockTracksRouting: TracksRouting {
    // MARK: - Variables

    public var viewController: UIViewController?

    // MARK: - Init

    public init() { }

}
open class MockTracksViewing: TracksViewing {

    //MARK: - update

    public var updateViewModelsCallCount = 0
    public var updateViewModelsSpy: [TrackViewModel]?

    public func update(viewModels: [TrackViewModel]) {
        updateViewModelsCallCount += 1
        updateViewModelsSpy = viewModels
    }

}

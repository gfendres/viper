import XCTest
@testable import SampleViper

class TracksPresenterTests: XCTestCase {
    
    var subject: TracksPresenter!
    private var mockInteractor: MockTracksInteracting!
    private var mockRouter: MockTracksRouting!
    private var mockView: MockTracksViewing!
    private var mockTrackColoring: MockTrackColoring!

    // MARK: - Setup / Tear down


    override func setUp() {
        mockInteractor = MockTracksInteracting()
        mockRouter = MockTracksRouting()
        mockView = MockTracksViewing()
        mockTrackColoring = MockTrackColoring()
        subject = TracksPresenter(
            interactor: mockInteractor,
            router: mockRouter,
            trackColoring: mockTrackColoring)
        subject.view = mockView
        super.setUp()
    }
    
    override func tearDown() {
        subject = nil
        mockInteractor = nil
        mockRouter = nil
        mockView = nil
        mockTrackColoring = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_viewDidLoad_shouldFetchTracks() {
        subject.viewDidLoad()
        XCTAssertEqual(mockInteractor.fetchTracksCallCount, 1)
    }

    func test_didTapAdd_shouldAddTrack() {
        let artist = "mockArtist"
        let title = "mockTitle"

        subject.didTapAdd(title: title, artist: artist)

        XCTAssertEqual(mockInteractor.addTrackTitleArtistCallCount, 1)
        XCTAssertEqual(mockInteractor.addTrackTitleArtistSpy?.title, title)
        XCTAssertEqual(mockInteractor.addTrackTitleArtistSpy?.artist, artist)
    }

    func test_didSwipeToDelete_whenTracksAvailable_shouldDeleteTrack() {
        let tracks = MockTrackServicing.makeMockTracks()
        subject.fetched(tracks: tracks)
        subject.didSwipeToDelete(at: 1)

        XCTAssertEqual(mockInteractor.deleteTrackCallCount, 1)
        XCTAssertEqual(mockInteractor.deleteTrackSpy, tracks[1])
    }

    func test_didSwipeToDelete_whenNoTracksAvailable_shouldNotDeleteTrack() {
        subject.didSwipeToDelete(at: 1)

        XCTAssertEqual(mockInteractor.deleteTrackCallCount, 0)
    }

    func test_fetchedTracks_shouldUpdateViewModels() throws {
        let tracks = MockTrackServicing.makeMockTracks()
        subject.fetched(tracks: tracks)

        let viewModels = tracks.map { track in
            return TrackViewModel(
                title: "\(track.title) - \(track.artist)",
                color: mockTrackColoring.color(for: track))
         }

        XCTAssertEqual(mockView.updateViewModelsCallCount, 1)
        let updateViewModelsSpy = try AssertNotNil(mockView.updateViewModelsSpy)
        XCTAssertEqual(updateViewModelsSpy, viewModels)
    }

    func test_handleError_shouldShowErrorOnView() throws {
        subject.handleError(.notFound)
        XCTAssertEqual(mockView.showErrorDescriptionCallCount, 1)
        let errorDescription = try AssertNotNil(ServiceError.notFound.errorDescription)
        XCTAssertEqual(mockView.showErrorDescriptionSpy, errorDescription)

    }
}

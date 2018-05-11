import XCTest
@testable import SampleViper

class TracksInteractorTests: XCTestCase {

    private var subject: TracksInteractor!
    private var mockTrackServicing: MockTrackServicing!
    private var mockDelegate: MockTracksInteractorDelegate!

    // MARK: - Setup / Tear down
    
    override func setUp() {
        super.setUp()
        mockTrackServicing = MockTrackServicing()
        mockDelegate = MockTracksInteractorDelegate()
        subject = TracksInteractor(service: mockTrackServicing)
        subject.delegate = mockDelegate
    }
    
    override func tearDown() {
        subject = nil
        mockTrackServicing = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_fetchTracks_shouldFetchTracks() {
        let tracks = MockTrackServicing.makeMockTracks()
        mockTrackServicing.fetchStub = Result.success(tracks)

        subject.fetchTracks()

        XCTAssertEqual(mockTrackServicing.fetchCallCount, 1)
    }

    func test_fetchTracks_shouldDelegateTracks() throws {
        let tracks = MockTrackServicing.makeMockTracks()
        mockTrackServicing.fetchStub = Result.success(tracks)

        subject.fetchTracks()

        XCTAssertEqual(mockDelegate.fetchedTracksCallCount, 1)
        let spy = try AssertNotNil(mockDelegate.fetchedTracksSpy)
        XCTAssertEqual(spy, tracks)
    }

    func test_fetchTracks_whenFailure_handleError() throws {
        mockTrackServicing.fetchStub = Result.failure(.notFound)

        subject.fetchTracks()

        XCTAssertEqual(mockDelegate.handleErrorCallCount, 1)
        let spy = try AssertNotNil(mockDelegate.handleErrorSpy)
        XCTAssertEqual(spy, ServiceError.notFound)
    }

    // MARK: - addTrack

    func test_addTrack_shouldAddTrack() throws {
        let artist = "mockArtist"
        let title = "mockTitle"
        mockTrackServicing.addTrackTitleArtistStub = Result.success(MockTrackServicing.makeMockTracks())

        subject.addTrack(title: title, artist: artist)

        XCTAssertEqual(mockTrackServicing.addTrackTitleArtistCallCount, 1)
        let spy = try AssertNotNil(mockTrackServicing.addTrackTitleArtistSpy)
        XCTAssertEqual(spy.title, title)
        XCTAssertEqual(spy.artist, artist)
    }

    func test_addTrack_shouldDelegateTracksWithAddedTrack() throws {
        let artist = "mockArtist"
        let title = "mockTitle"
        mockTrackServicing.addTrackTitleArtistStub = Result.success(MockTrackServicing.makeMockTracks())

        subject.addTrack(title: title, artist: artist)

        let spy = try AssertNotNil(mockDelegate.fetchedTracksSpy)
        let containsTrack = spy.contains { track in
            return track.title == title && track.artist == artist
        }
        XCTAssertTrue(containsTrack)
    }

    func test_addTrack_whenFailure_handleError() throws {
        let artist = "mockArtist"
        let title = "mockTitle"

        mockTrackServicing.addTrackTitleArtistStub = Result.failure(.notFound)
        subject.addTrack(title: title, artist: artist)

        XCTAssertEqual(mockDelegate.handleErrorCallCount, 1)
        let spy = try AssertNotNil(mockDelegate.handleErrorSpy)
        XCTAssertEqual(spy, ServiceError.notFound)
    }

    // MARK: - deleteTrack

    func test_deleteTrack_shouldDeleteTrack() throws {
        let mockTracks = MockTrackServicing.makeMockTracks()
        let track = try AssertNotNil(mockTracks.first)

        mockTrackServicing.deleteTrackCompletionStub = Result.success(mockTracks)

        subject.delete(track: track)

        XCTAssertEqual(mockTrackServicing.deleteTrackCompletionCallCount, 1)

        let spy = try AssertNotNil(mockTrackServicing.deleteTrackCompletionSpy)
        XCTAssertEqual(spy.track, track)
    }

    func test_deleteTrack_shouldDelegateFetchedTracks() throws {
        let mockTracks = MockTrackServicing.makeMockTracks()
        let track = try AssertNotNil(mockTracks.first)

        mockTrackServicing.deleteTrackCompletionStub = Result.success(mockTracks)

        subject.delete(track: track)

        XCTAssertEqual(mockDelegate.fetchedTracksCallCount, 1)
    }

    func test_deleteTrack_whenFailure_handleError() throws {
        let mockTracks = MockTrackServicing.makeMockTracks()
        let track = try AssertNotNil(mockTracks.first)

        mockTrackServicing.deleteTrackCompletionStub = Result.failure(.notFound)

        subject.delete(track: track)

        XCTAssertEqual(mockDelegate.handleErrorCallCount, 1)
        let spy = try AssertNotNil(mockDelegate.handleErrorSpy)
        XCTAssertEqual(spy, ServiceError.notFound)
    }
}

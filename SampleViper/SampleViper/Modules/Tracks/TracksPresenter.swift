import UIKit

class TracksPresenter: TracksPresenting {
    
    // MARK: - Variables
    
    weak var view: TracksViewing?
    private let router: TracksRouting
    private let interactor: TracksInteracting
    private var tracks: [Track] = []
    private var trackColoring: TrackColoring

    // MARK: - Init


    init(
        interactor: TracksInteracting,
        router: TracksRouting,
        trackColoring: TrackColoring = ColorResolver()
    ) {
        self.interactor = interactor
        self.router = router
        self.trackColoring = trackColoring
    }
    
    // MARK: - Public
    
    func viewDidLoad() {
        interactor.fetchTracks()
    }
    
    func didTapAdd(title: String, artist: String) {
        interactor.addTrack(title: title, artist: artist)
    }
    
    func didSwipeToDelete(at row: Int) {
        guard row < tracks.count else { return }
        interactor.delete(track: tracks[row])
    }
    
    // MARK: - Private
    
    private func toViewModel(track: Track) -> TrackViewModel {
        return TrackViewModel(
            title: "\(track.title) - \(track.artist)",
            color: trackColoring.color(for: track))
    }

}

extension TracksPresenter: TracksInteractorDelegate {
    func didFetch(tracks: [Track]) {
        self.tracks = tracks
        view?.update(viewModels: tracks.map(toViewModel))
    }

    func handleError(_ error: ServiceError) {
        view?.showError(error.errorDescription ?? "Generic Error")
    }
}

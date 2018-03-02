import UIKit

class TracksPresenter: TracksPresenting {
    
    // MARK: - Variables
    
    weak var view: TracksViewing?
    private let router: TracksRouting
    private let interactor: TracksInteracting
    private var tracks: [Track] = []
    
    // MARK: - Init
    
    init(interactor: TracksInteracting, router: TracksRouting) {
        self.interactor = interactor
        self.router = router
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
            color: color(for: track))
    }
    
    private func color(for track: Track) -> UIColor {
        return UIColor(
            red: CGFloat(Double(track.id) / 10.0),
            green: CGFloat(Double(track.title.count) / 20.0),
            blue: CGFloat(Double(track.artist.count) / 20.0), alpha: 1)
    }
}

extension TracksPresenter: TracksInteractorDelegate {
    func fetched(tracks: [Track]) {
        self.tracks = tracks
        view?.update(with: tracks.map(toViewModel))
    }
}

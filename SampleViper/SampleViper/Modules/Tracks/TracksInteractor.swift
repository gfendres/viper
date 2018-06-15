import UIKit

class TracksInteractor: TracksInteracting {

    weak var delegate: TracksInteractorDelegate?
    private let service: TrackServicing
    
    // MARK: Initializers
    
    init(service: TrackServicing) {
        self.service = service
    }
    
    // MARK: Business logic

    func fetchTracks() {
        service.fetch(completion: handleResult)
    }
    
    func addTrack(title: String, artist: String) {
        service.addTrack(title: title, artist: artist, completion: handleResult)
    }
    
    func delete(track: Track) {
        service.delete(track: track, completion: handleResult)
    }

    // MARK: - Private

    private func handleResult(_ result: Result<[Track]>) {
        switch result {
        case .success(let tracks):
            delegate?.didFetch(tracks: tracks)
        case .failure(let error):
            delegate?.handleError(error)
        }
    }
}

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
        service.fetch { [weak self] tracks in
            self?.delegate?.fetched(tracks: tracks)
        }
    }
    
    func addTrack(title: String, artist: String) {
        service.addTrack(title: title, artist: artist) { [weak self] in
            self?.fetchTracks()
        }
    }
    
    func delete(track: Track) {
        service.delete(track: track) { [weak self] in
            self?.fetchTracks()
        }
    }
}

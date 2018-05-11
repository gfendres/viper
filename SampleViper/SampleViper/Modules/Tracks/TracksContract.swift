import UIKit

protocol TracksPresenting: class {
    var view: TracksViewing? { get set }

    func viewDidLoad()
    func didTapAdd(title: String, artist: String)
    func didSwipeToDelete(at row: Int)
}

protocol TracksViewing: class {
    func update(viewModels: [TrackViewModel])
    func showError(_ description: String)
}

protocol TracksInteracting: class {
    var delegate: TracksInteractorDelegate? { get set }
    
    func fetchTracks()
    func addTrack(title: String, artist: String)
    func delete(track: Track)
}

protocol TracksInteractorDelegate: class {
    func fetched(tracks: [Track])
    func handleError(_ error: ServiceError)
}

protocol TracksRouting: class {
    var viewController: UIViewController? { get set }
}

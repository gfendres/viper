import UIKit

protocol TracksPresenting: class {
    weak var view: TracksViewing? { get set }
    func viewDidLoad()
    func didTapAdd(title: String, artist: String)
    func didSwipeToDelete(at row: Int)
}

protocol TracksViewing: class {
    func update(viewModels: [TrackViewModel])
}

protocol TracksInteracting: class {
    weak var delegate: TracksInteractorDelegate? { get set }
    
    func fetchTracks()
    func addTrack(title: String, artist: String)
    func delete(track: Track)
}

protocol TracksInteractorDelegate: class {
    func fetched(tracks: [Track])
}

protocol TracksRouting: class {
    weak var viewController: UIViewController? { get set }
}

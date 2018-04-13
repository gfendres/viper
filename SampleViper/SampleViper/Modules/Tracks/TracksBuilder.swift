import UIKit

class TracksBuilder {
    
    static func makeModule(service: TrackServicing = TrackService()) -> UIViewController {
        
        let router = TracksRouter()
        let interactor = TracksInteractor(service: service)
        let presenter = TracksPresenter(interactor: interactor, router: router)
        let viewController = TracksViewController(presenter: presenter)
        
        router.viewController = viewController
        presenter.view = viewController
        interactor.delegate = presenter
        
        return viewController
    }
}

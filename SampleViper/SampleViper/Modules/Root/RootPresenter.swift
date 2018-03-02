import UIKit

class RootPresenter {
    
    // MARK: - Variables
    
    private let router: RootRouting
    
    // MARK: - Init
    
    init(router: RootRouting) {
        self.router = router
    }
    
    func start() {
        router.presentListScreen()
    }
}

import UIKit

class RootBuilder {
    
    static func makeModule(in window: UIWindow?) {
        
        let router = RootRouter()
        router.window = window
        let presenter = RootPresenter(router: router)
        presenter.start()
    }
}

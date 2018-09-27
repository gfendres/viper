import UIKit

class RootRouter: RootRouting {
    weak var window: UIWindow?
    
    func presentListScreen() {
        window?.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: TracksModuleFactory.makeModule())
        navigationController.navigationBar.isTranslucent = true
        window?.rootViewController = navigationController
    }
}

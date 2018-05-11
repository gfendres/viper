import UIKit

protocol RootRouting: class {
    var window: UIWindow? { get set }
    func presentListScreen()
}

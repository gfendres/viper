import UIKit

protocol RootRouting: class {
    weak var window: UIWindow? { get set }
    func presentListScreen()
}

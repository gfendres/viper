import Foundation
import UIKit

class AlertFactory {
    static func makeAddAlertViewController(addActionBlock: @escaping (_ title: String, _ artist: String) -> Void) -> UIAlertController {
        let alertViewController = UIAlertController(title: "Add Track", message: nil, preferredStyle: .alert)

        let titlePlaceholder = "Title"
        let artistPlaceholder = "Artist"

        let addTitleAction = UIAlertAction(title: "Add", style: .default) { action in
            guard
                let titleTextField = alertViewController.textFields?.first(where: { textField -> Bool in
                    return textField.placeholder == titlePlaceholder
                }),
                let artistTextField = alertViewController.textFields?.first(where: { (textField) -> Bool in
                    return textField.placeholder == artistPlaceholder
                }),
                let title = titleTextField.text,
                let artist = artistTextField.text else { return }
            addActionBlock(title, artist)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertViewController.addTextField { titleTextField in
            titleTextField.placeholder = titlePlaceholder
        }

        alertViewController.addTextField { artistTextField in
            artistTextField.placeholder = artistPlaceholder
        }

        alertViewController.addAction(addTitleAction)
        alertViewController.addAction(cancel)

        return alertViewController
    }
}
import UIKit

class TracksViewController: UIViewController {
    
    // MARK: - Constants
    
    private let cellIdentifier = "trackCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tracksTableView: UITableView!
    
    // MARK: - Variables
    
    private let presenter: TracksPresenting
    private var trackViewModels: [TrackViewModel] = []
    
    // MARK: - Init
    
    init(presenter: TracksPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton))
        navigationItem.setRightBarButton(addButton, animated: true)
        
        tracksTableView.dataSource = self
        tracksTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tracksTableView.allowsSelectionDuringEditing = true
        presenter.viewDidLoad()
    }
    
    // MARK: - Private
    
    // MARK: - IBActions
    
    @IBAction private func didTapAddButton() {
        let alert = UIAlertController(title: "Add Track", message: nil, preferredStyle: .alert)
        
        let titlePlaceholder = "Title"
        let artistPlaceholder = "Artist"
        
        let addTitleAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            guard
                let titleTextField = alert.textFields?.first(where: { textField -> Bool in
                    return textField.placeholder == titlePlaceholder
                }),
                let artistTextField = alert.textFields?.first(where: { (textField) -> Bool in
                    return textField.placeholder == artistPlaceholder
                }),
                let title = titleTextField.text,
                let artist = artistTextField.text else { return }
            
            self?.presenter.didTapAdd(title: title, artist: artist)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { titleTextField in
            titleTextField.placeholder = titlePlaceholder
        }
        
        alert.addTextField { artistTextField in
            artistTextField.placeholder = artistPlaceholder
        }
        
        alert.addAction(addTitleAction)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension TracksViewController: TracksViewing {
    func update(with viewModels: [TrackViewModel]) {
        trackViewModels = viewModels
        tracksTableView.reloadData()
    }
}

extension TracksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let viewModel = trackViewModels[indexPath.row]
        cell.textLabel?.text = viewModel.title
        cell.backgroundColor = viewModel.color
        return cell
    }
}

extension TracksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.didSwipeToDelete(at: indexPath.row)
        }
    }
}

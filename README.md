# VIPER

It does not matter what name you are going to use, VIPER, RIBs, Clean Swift. The idea behind all of the ideas is to follow Clean Architecture and making the life of the developers better :D.

VIPER is followed by: 

![module](https://github.com/gfendres/viper/blob/master/images/module.jpeg)

## V: View

- Dumb and passive.
- Communicate the events to the Presenter
- Never ask for data
- Deal with animation
- Deal with UI only
- Access only ViewModels with the needed data already formatted

## I: Interactor

- Business logic
- Has Services to perform requests
- Communicate back to Presenter via delegate

## P: Presenter

- Receives the View events
- Convert Models to ViewModels
- Interact with Interactor
- Interact with Router
- Is the center of the Module

## E: Entity (Models)

## R: Router

- Navigate to other Modules

# We also have:

## C: Contract

- Protocols
- Define the communication between the `VIPER` parts (`Interactor`, `Presenter` ...)
- It is the **FIRST** file to code.

## B: Builder

- Create the Module

## View Model

- `Struct`
- Data formatted 
    - `String`
    - `UIImage`
    - `Url` 
- For instance if you have a `cell` with title which has a `name` and `lastName` combined, The `ViewModel` should have a `title: String = name + lastName`.

----

# Module

All the files and structure is called a `Module` which will be one per `screen/ ViewController / View`. We never use the same component (`Interactor`, `Presenter` ...) in a different `Module`.

If there is something that needs to be shared between `Modules`, it should be in a `Protocol` extension or `Class`, such as `Services`.

The `Modules` not necessary needs all the components. Maybe the `View` does not require any request for data, so the Interactor is not needed, but every `View` needs at least a `Presenter`.

## View

One important thing about the `View` is that it needs to be **passive** and **NEVER** ask for something like `presenter.tracks()`.
The communication should always be passive, using the `Presenter` as an event handler. Some *Clean Architectures* have a `"Presenter"` with the name of `EventHandler`. We decided to keep `Presenter` to simplify and be easier to understand and avoid over-engineering by having both.

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
```

```swift
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.didSwipeToDelete(at: indexPath.row)
        }
    }
```

## Presenter

The `Presenter` is the centralized part of the VIPER architecture. It will receive the UI events and redirect it to `Interactor` or `Router` and implement the `Interactor` delegate converting `Models` to `ViewModel` presenting the data to the `View`.
Most of the `Presenter` public methods are `View` events, with that said testing the `Presenter` is almost like a UI test and so much faster and less prone to flakiness than `XCUI`.

```swift
    func viewDidLoad() {
        interactor.fetchTracks()
    }
```

```swift
    func didFetch(tracks: [Track]) {
        self.tracks = tracks
        view?.update(with: tracks.map(toViewModel))
    }
```

You can choose to have a initializer on `ViewModel` that receives a `model` or do it on the `presenter`.

```swift
    private func toViewModel(track: Track) -> TrackViewModel {
        return TrackViewModel(
            title: "\(track.title) - \(track.artist)",
            color: color(for: track))
    }
```

## Interactor

`Interactor` will have most of the business logic and handle the retrieving data from `Services`. The `Interactor` is usually initialized with a `Service` `Protocol` to do request and handle data. 

```swift
    func fetchTracks() {
        service.fetch { [weak self] tracks in
            self?.delegate?.fetched(tracks: tracks)
        }
    }
```

## Router

The `Router` is responsible for redirecting to new `Modules` using their `Builders`. Usually, It has a weak reference to the `View Controller` to be able to push to a new `Module`.

```swift
   func openTrackScreen(track: Track) {
       viewController?.push(trackBuilder.makeModule(track: track), animated: true)
   }
```

## Contract

The `Contract` is a file which will have the `Protocols` which each part will communicate with each other. All the communication is based on `Protocols`, following the `Protocol Oriented Programming`. 
The exciting part of the `Contract` is that you have all the `Protocols` here, having a big picture of how it behaves. 

**It is the first file to code, defining what the components will implement and how the will be related.**

*Following the Protocol Oriented Proggramming which says that you first have to think about the `Protocols` and later the `classes`*

```swift
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
    func didFetch(tracks: [Track])
    func handleError(_ error: ServiceError)
}

protocol TracksRouting: class {
    var viewController: UIViewController? { get set }
}
```

## Builder

Creates the `Module` injecting the dependencies and returns the `View`.
It usually has only one method to assemble the entire `Module`.

```swift
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
```

# Testing

One of the best thing about VIPER is Testing. When we get the `Presenter` as example, we can see that it looks like an `UI` test. it is very clear what is should do. 

```swift
    func test_viewDidLoad_shouldFetchTracks() {
        subject.viewDidLoad()
        XCTAssertEqual(mockInteractor.fetchTracksCallCount, 1)
    }
    
    func test_didTapAdd_shouldAddTrack() {
        let artist = "mockArtist"
        let title = "mockTitle"

        subject.didTapAdd(title: title, artist: artist)

        XCTAssertEqual(mockInteractor.addTrackTitleArtistCallCount, 1)
        XCTAssertEqual(mockInteractor.addTrackTitleArtistSpy?.title, title)
        XCTAssertEqual(mockInteractor.addTrackTitleArtistSpy?.artist, artist)
    }
    
    func test_didSwipeToDelete_whenTracksAvailable_shouldDeleteTrack() {
        let tracks = MockTrackServicing.makeMockTracks()
        subject.didFetch(tracks: tracks)
        subject.didSwipeToDelete(at: 1)

        XCTAssertEqual(mockInteractor.deleteTrackCallCount, 1)
        XCTAssertEqual(mockInteractor.deleteTrackSpy, tracks[1])
    }
```

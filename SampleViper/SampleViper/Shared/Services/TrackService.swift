import Foundation

protocol TrackServicing {
    func fetch(completion: (_ tracks: [Track]) -> ())
    func addTrack(title: String, artist: String, completion: () -> Void)
    func delete(track: Track, completion: () -> Void)
}

final class TrackService: TrackServicing {

    private var tracks = [Track(id: 0, title: "Hey Joe", artist: "Jimi Hendrix"),
                          Track(id: 1, title: "Valerie", artist: "Amy Winehouse"),
                          Track(id: 2, title: "Comfortably numb", artist: "Pink Floyd"),
                          Track(id: 3, title: "New York, New York", artist: "Frank Sinatra"),
                          Track(id: 4, title: "Bohemiam Rhapsody", artist: "Queen"),
                          Track(id: 5, title: "Cocaine", artist: "Eric Clapton"),
                          Track(id: 6, title: "Hotel California", artist: "The Eagles"),
                          Track(id: 7, title: "Tom Sawyer", artist: "Rush"),
                          Track(id: 8, title: "Thunderstruck", artist: "AC/DC")]
    
    func fetch(completion: ([Track]) -> ()) {
        completion(tracks)
    }
    
    func addTrack(title: String, artist: String, completion: () -> Void) {
        tracks.append(Track(id: tracks.count + 1, title: title, artist: artist))
        completion()
    }
    
    func delete(track: Track, completion: () -> Void) {
        guard let index = tracks.index(where: { trackIndex -> Bool in
            return track == trackIndex
        }) else { return }
        tracks.remove(at: index)
        completion()
    }
}

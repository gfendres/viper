import Foundation

enum ServiceError: LocalizedError {
    case alreadyExists, notFound
    var errorDescription: String? {
        switch self {
        case .notFound: return "not found"
        case .alreadyExists: return "already exists"
        }
    }
}

enum Result<T> {
    case success(T)
    case failure(ServiceError)
}

protocol TrackServicing {
    func fetch(completion: @escaping (_ result: Result<[Track]>) -> ())
    func addTrack(title: String, artist: String, completion: @escaping (_ result: Result<[Track]>) -> Void)
    func delete(track: Track, completion: @escaping (_ result: Result<[Track]>) -> Void)
}

final class TrackService: TrackServicing {

    private var tracks: [Track]

    init(tracks: [Track] = [Track(id: 0, title: "Hey Joe", artist: "Jimi Hendrix"),
                            Track(id: 1, title: "Valerie", artist: "Amy Winehouse"),
                            Track(id: 2, title: "Comfortably numb", artist: "Pink Floyd"),
                            Track(id: 3, title: "New York, New York", artist: "Frank Sinatra"),
                            Track(id: 4, title: "Bohemiam Rhapsody", artist: "Queen"),
                            Track(id: 5, title: "Cocaine", artist: "Eric Clapton"),
                            Track(id: 6, title: "Hotel California", artist: "The Eagles"),
                            Track(id: 7, title: "Tom Sawyer", artist: "Rush"),
                            Track(id: 8, title: "Thunderstruck", artist: "AC/DC")]) {
        self.tracks = tracks
    }
    
    func fetch(completion: @escaping (_ result: Result<[Track]>) -> ()) {
        completion(.success(tracks))
    }
    
    func addTrack(title: String, artist: String, completion: @escaping (_ result: Result<[Track]>) -> Void) {
        let containsTrack = tracks.contains (where: { track in
            return track.title == title && track.artist == artist
        })

        if containsTrack {
            completion(.failure(.alreadyExists))
            return
        }

        let track = Track(id: tracks.count + 1, title: title, artist: artist)
        tracks.append(track)
        completion(.success(tracks))
    }
    
    func delete(track: Track, completion: @escaping (_ result: Result<[Track]>) -> Void) {
        do {
            let trackIndex = try index(for: track)
            tracks.remove(at: trackIndex)
            completion(.success(tracks))
        }
        catch { completion(.failure(.notFound)) }

    }

    private func index(for track: Track) throws -> Int {
        guard let index = tracks.index(where: { searchedTrack -> Bool in
            return track == searchedTrack
        }) else {
            throw ServiceError.notFound
        }
        return index
    }
}

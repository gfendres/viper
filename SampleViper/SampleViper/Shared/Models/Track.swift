import Foundation

final class Track: Equatable {
    
    let id: Int
    let title: String
    let artist: String
    
    init(id: Int, title: String, artist: String) {
        self.id = id
        self.title = title
        self.artist = artist
    }
    
    static func ==(lhs: Track, rhs: Track) -> Bool {
        return lhs.title == rhs.title && lhs.artist == rhs.artist
    }
}

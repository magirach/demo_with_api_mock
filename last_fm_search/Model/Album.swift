//
//  Album.swift
//  last_fm_search
//
//  Created by Moinuddin Girach on 23/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

struct AlbumsResponse: Codable {
    var results: AlbumResults
}

struct AlbumResponse: Codable {
    var album: Album
}

struct AlbumResults: Codable {
    var albummatches: AlbumMatches
}

struct AlbumMatches: Codable {
    var album: [Album]
}

struct Album: Codable {
    var name: String
    var artist: String
    var image: [Image]
    var mbid: String
    var tracks: [Tracks]?
    
    var smallImage: String {
        return image.filter {$0.size == "small"}.first!.text
    }
    
    var mediumImage: String {
        return image.filter {$0.size == "medium"}.first!.text
    }
}

struct Image: Codable {
    var text: String
    var size: String
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}

struct Tracks: Codable {
    var track: [Track]
}

struct Track: Codable {
    var name: String
    var duration: String
    var artist: Artist
}

struct Artist: Codable {
    var name: String
    var mbid: String
}

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
    var tracks: Tracks?
    var wiki: Wiki?
    
    var mediumImage: String {
        return image.filter {$0.size == "medium"}.first!.text
    }
    
    var lagreImage: String {
        return image.filter {$0.size == "large"}.first!.text
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
    
    var formatedDuration: String {
        let intDuration = Int(duration) ?? 0
        var hour = 0
        var min = 0
        var sec = 0
        if intDuration < 60 {
            sec = intDuration
            return String(format: "%02d:%02d", min, sec)
        } else if intDuration < 3600 {
            sec = intDuration % 60
            min = (intDuration - sec) / 60
            return String(format: "%02d:%02d", min, sec)
        } else {
            sec = intDuration % 60
            min = ((intDuration - sec) / 60) % 60
            hour = (((intDuration - sec) / 60) - min) / 60
            return String(format: "%02d:%02d:%02d", hour, min, sec)
        }
    }
}

struct Artist: Codable {
    var name: String
    var mbid: String
}

struct Wiki: Codable {
    var published: String
    var summary: String
}

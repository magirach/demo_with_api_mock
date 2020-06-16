//
//  Constants.swift
//  last_fm_search
//
//  Created by Moinuddin Girach on 17/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

struct Constants {
    static var APIKey: String {
        return "207d9906a556e2e31ce96c7f609ee112"
    }
    
    static var host: String {
        return "http://ws.audioscrobbler.com/2.0/"
    }
    
    static var methodGetAlbum: String {
        return "album.search"
    }
    
    static var responseForamte: String {
        return "json"
    }
}

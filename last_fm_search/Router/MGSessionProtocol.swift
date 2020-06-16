//
//  MGSessionProtocol.swift
//  last_fm_search
//
//  Created by Moinuddin Girach on 17/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

public protocol MGSessionProtocol: class {
    static var shared: MGSessionProtocol { get }
    static var sharedSession: URLSession? { get }
    var session: URLSession? {get set}
    var bundle: Bundle {get set}
}

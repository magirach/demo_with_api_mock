//
//  MGSession.swift
//  last_fm_search
//
//  Created by Moinuddin Girach on 17/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

/// Session class. main purpose to create class is to make singalton object of URLSession. shaed object of URLSesion does not allow to cusomize configuration so neds to create custom URLSession oject and set configuration.
public class MGSession: NSObject, URLSessionDataDelegate, MGSessionProtocol  {
    public var bundle: Bundle = Bundle.main
    
    private static let serialQueue = DispatchQueue(label: "com.moin.girach.serial")
    
    public static let shared: MGSessionProtocol = {
        return serialQueue.sync {
            return MGSession()
        }
    }()
    
    public static var sharedSession: URLSession? {
        return shared.session
    }
    
    public var session: URLSession?
    
    private override init() {
        super.init()
        /// Custom cach implmented for all request so urlCache does not required and disabling all urlCache
        let config = URLSessionConfiguration.default
        /// ignores all local and remote chache data
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        /// set urlCache nil, custom urlCache implemented so default url cache does not required.
        config.urlCache = nil
        session = URLSession(configuration: config)
        
    }
}

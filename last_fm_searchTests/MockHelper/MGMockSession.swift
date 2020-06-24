//
//  MGMockSession.swift
//  last_fm_searchUITests
//
//  Created by Moinuddin Girach on 17/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//
import Foundation
@testable import last_fm_search

public class MGMockSession: NSObject, URLSessionDataDelegate, MGSessionProtocol {
    public var bundle: Bundle = Bundle(for: MGMockSession.self)
    
    public static var sharedSession: URLSession? {
        return shared.session
    }
    
    public var session: URLSession?
    
    
    private static let serialQueue = DispatchQueue(label: "com.Demo.MGMockSession.serial")
    
    public static let shared: MGSessionProtocol = {
        return serialQueue.sync {
            return MGMockSession()
        }
    }()
        
    private override init() {
        super.init()
        /// Custom cach implmented for all request so urlCache does not required and disabling all urlCache
        let config = URLSessionConfiguration.default
        /// ignores all local and remote chache data
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        /// set urlCache nil, custom urlCache implemented so default url cache does not required.
        config.urlCache = nil
        session = MGMockUrlSession()
        
    }
}

class MGMockUrlSession: URLSession {
    
    override var configuration: URLSessionConfiguration {
        return URLSessionConfiguration.ephemeral
    }
        
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let response = HTTPURLResponse(url: URL(string: "http://localhost/")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        return MGMockTask(request: request, response: response, completionHandler: completionHandler)
    }
}

class MGMockTask: URLSessionDataTask {
    var desc: String?
    override var taskDescription: String? {
        set {
            desc = newValue
        }
        get {
            return desc
        }
    }
    
    let request: URLRequest?
    override var currentRequest: URLRequest? {
        return request
    }
    
    override var originalRequest: URLRequest? {
        return request
    }
    
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    let completionHandler: ((Response) -> Void)?
    var mockResponse: HTTPURLResponse?
    
    init(request: URLRequest?, response: URLResponse?, completionHandler:((Response) -> Void)?) {
        self.completionHandler = completionHandler
        self.request = request
        self.mockResponse = response as? HTTPURLResponse
    }
    
    override func resume() {
        let response = HTTPURLResponse(url: URL(string: "http://localhost/")!, statusCode: 200, httpVersion: nil, headerFields: getHeaderFromUrl())
        let data = getDataFromUrl()
        completionHandler?((data.0, response, data.1))
    }
    
    func getMockfileUrl() -> URL {
        var file: String = ""
        let bundle = MGMockSession.shared.bundle
        
        file = MockConfiguration.getFilePath(forKey: self.taskDescription!)
        
        if file.isEmpty {
            return URL(fileURLWithPath: file)
        } else {
            if let path = bundle.path(forResource: file, ofType: "json") {
                return URL(fileURLWithPath: path)
            } else {
                return URL(fileURLWithPath: file)
            }
        }
    }
    
    func getDataFromUrl() -> (Data?, Error?) {
        let url = getMockfileUrl()
        do {
            return (try Data(contentsOf: url), nil)
        } catch {
            return (nil, error)
        }
    }
    
    func getHeaderFromUrl() -> [String: String]? {
        let url = getMockfileUrl()
        let lastPath = url.deletingPathExtension().lastPathComponent
        let lastPathExtension = url.pathExtension
        let headerUrl = url.deletingLastPathComponent().appendingPathComponent("\(lastPath)_header.\(lastPathExtension)")
        do {
            let data = try Data(contentsOf: headerUrl)
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String]
            return jsonData
        } catch {
            return nil
        }
    }
}

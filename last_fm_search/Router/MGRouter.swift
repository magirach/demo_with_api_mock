//
//  MGRouter.swift
//  last_fm_search
//
//  Created by Moinuddin Girach on 17/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

public struct MGRouter {
    
    static var debug = false
    static let encodingStratagy = JSONEncoder.KeyEncodingStrategy.useDefaultKeys
    static let decodingStratagy = JSONDecoder.KeyDecodingStrategy.useDefaultKeys

    /// urlsession data task
    static var task: URLSessionDataTask?
    static var session: MGSessionProtocol = MGSession.shared
    
    var input: MGRouterInputProtocol
    
    var baseUrl: String {
        return input.host
    }
    
    /// custom headers
    var headers: [String: String] {
        return input.headers
    }
    
    var method: String {
        return input.method.rawValue
    }
    
    var timeout: TimeInterval {
        return TimeInterval(input.timeout)
    }
    
    var body: Data? {
        return input.body
    }
    
    /// final url
    var url: URL {
        let strUrl = String(format: "%@%@", baseUrl, input.endpoint)
        return URL(string: strUrl)!
    }
    
    var request: URLRequest {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = timeout
        request.httpBody = body
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
}

extension MGRouter {
    
    public func call<T: Decodable>(callback: @escaping (Result<T?, Error>) -> Void) {
            self.apiCall(callback: callback)
    }
    
    
    /// make network api calls
    /// - Parameter callback: callback blocak
    internal func apiCall<T: Decodable>(callback: @escaping (Result<T?, Error>) -> Void) {
        MGRouter.task = MGRouter.session.session!.dataTask(with: request) { (data, response, error) in
            let responseStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            if let error = error {
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
                return
            }
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    let error = NSError(domain: "com.moin.error", code: responseStatusCode, userInfo: ["description": "Invalid data"])
                    callback(.failure(error))
                }
                return
            }
            if data.isEmpty {
                DispatchQueue.main.async {
                    let error = NSError(domain: "com.moin.error", code: responseStatusCode, userInfo: ["description": "Empty response"])
                    callback(.failure(error))
                }
                return
            }
            if MGRouter.debug {
                print("=================\nREQUEST\n=================")
                print("URL: \(self.url)")
                print("-----------------\nMETHOD:\(self.method)\n-----------------")
                if let body = self.body {
                    print("BODY: \(String(data: body, encoding: .utf8)!)\n-----------------")
                }
                print("HEADERS: \(self.request.allHTTPHeaderFields!)")
                print("=================\nRESPONSE\n=================")
                
            }
            
            switch responseStatusCode {
            case 200, 201:
                if T.self == Data.self {
                    DispatchQueue.main.async {
                        callback(.success(data as? T))
                    }
                } else {
                    self.decode(data: data, callback: callback)
                }
            default:
                print("RESPONSE STATUS CODE: \(responseStatusCode)")
                print("STRING FROM SERVER:\(String(data: data, encoding: .utf8) ?? "Binary data")\n-----------------")
                DispatchQueue.main.async {
                    let error = NSError(domain: "com.moin.error", code: responseStatusCode, userInfo: ["description": "Response error", "data": data])
                    callback(.failure(error))
                }
            }
        }
        MGRouter.task?.taskDescription = NSStringFromClass(type(of: input))
        MGRouter.task?.resume()
    }
    
    /// decode data to required output
    /// - Parameters:
    ///   - data: response data
    ///   - callback: callback block after data conversion
    internal func decode<T: Decodable>(data: Data, callback: @escaping (Result<T?, Error>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = MGRouter.decodingStratagy
        do {
            let responseData = try decoder.decode(T.self, from: data)
            if MGRouter.debug {
                print("\(responseData)\n=================")
            }
            DispatchQueue.main.async {
                callback(.success(responseData))
            }
        } catch {
            if MGRouter.debug {
                print("\(error)\n=================")
            }
            DispatchQueue.main.async {
                callback(.failure(error))
            }
        }
    }
}

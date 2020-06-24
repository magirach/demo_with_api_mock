//
//  MockConfiguration.swift
//  last_fm_searchUITests
//
//  Created by Moinuddin Girach on 17/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

class MockConfiguration {
    
    enum ResponseType: String {
        case success
        case failure
    }
    
    static func setMockFile(for type: ResponseType, fileKey: String, forKey: String) {
        if let fileUrl = Bundle(for: MockConfiguration.self).url(forResource: "mock_file_path", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: fileUrl)
                if var result = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: [String: Any]] {
                    result[forKey]!["pick"] = type.rawValue + "_" + fileKey
                    let plistData = try PropertyListSerialization.data(fromPropertyList: result, format: .xml, options: 0)
                    try plistData.write(to: fileUrl)
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func setMockFileForSuccess(fileKey: String, forKey: String) {
        setMockFile(for: .success, fileKey: fileKey, forKey: forKey)
    }
    
    static func setMockFileForFailure(fileKey: String, forKey: String) {
        setMockFile(for: .failure, fileKey: fileKey, forKey: forKey)
    }
    
    static func getFilePath(forKey: String) -> String {
        if let fileUrl = Bundle(for: MockConfiguration.self).url(forResource: "mock_file_path", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: fileUrl)
                if let result = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: [String: Any]] {
                    if let dicFile = result[forKey], let seletionName = dicFile["pick"] as? String {
                        let comps = seletionName.components(separatedBy: "_")
                        return (dicFile[comps[0]] as! [String: String])[comps[1]] as! String
                    }
                }
            } catch {
                print(error)
                return ""
            }
        }
        return ""
    }
}

//
//  last_fm_searchTests.swift
//  last_fm_searchTests
//
//  Created by Moinuddin Girach on 17/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import XCTest
@testable import last_fm_search

class last_fm_searchTests: XCTestCase {

    override func setUpWithError() throws {
        MGMockSession.shared.bundle = Bundle(for: last_fm_searchTests.self)
        MGRouter.session = MGMockSession.shared
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testModels() {
        convertFileToModel(fileName: "albums") { (result: AlbumsResponse?) in
            validateAlbumsResponse(model: result!)
        }
        
        convertFileToModel(fileName: "album") { (result: AlbumResponse?) in
            validateAlbumResponse(model: result!)
        }
    }
    
    func testAlbumsApi() {
        let albumsVC = AlbumsViewController()
        albumsVC.getAlbums(query: "Aa")
        let expectAlbums = expectation(description: "getAlbums")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectAlbums.fulfill()
        }
        wait(for: [expectAlbums], timeout: 2)
        XCTAssert(!albumsVC.arrAlbums.isEmpty)
    }

    func testAlbumApi() {
        let albumVC = AlbumInfoViewController()
        albumVC.getAlbum(mbid: "9f80e404-9436-307a-a369-e93a2fdd6751")
        let expectAlbum = expectation(description: "getAlbum")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectAlbum.fulfill()
        }
        wait(for: [expectAlbum], timeout: 2)
        XCTAssertNotNil(albumVC.album)
        validateAlbum(album:albumVC.album!)
    }

    
    
    func testTrackDurationLogic() {
        var track = Track(name: "123", duration: "49", artist: Artist(name: "artist", mbid: "1234"))
        XCTAssertEqual(track.formatedDuration, "00:49")
        track.duration = "109"
        XCTAssertEqual(track.formatedDuration, "01:49")
        track.duration = "3709"
        XCTAssertEqual(track.formatedDuration, "01:01:49")
    }

    func convertFileToJson(fileName: String, withBody: Bool = true) -> Any? {
        let bundle = Bundle(for: last_fm_searchTests.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: fileUrl)
                let json = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
                return json
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func convertFileToModel<T: Codable>(fileName: String, onComplete:(T?) -> Void) {
        let bundle = Bundle(for: last_fm_searchTests.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: fileUrl)
                let decoder = JSONDecoder()
                let obj = try decoder.decode(T.self, from: data)
                onComplete(obj)
            } catch {
                print(error)
                onComplete(nil)
            }
        }
    }
    
    func validateAlbumsResponse(model: AlbumsResponse) {
        let album = model.results.albummatches.album.first
        XCTAssertNotNil(album, "no album found")
        XCTAssertEqual(album?.artist, "Phoenix")
        XCTAssertEqual(album?.name, "Wolfgang Amadeus Phoenix")
        XCTAssertEqual(album?.mbid, "9f80e404-9436-307a-a369-e93a2fdd6751")
        XCTAssertEqual(album?.image.count, 4)
        XCTAssertEqual(model.results.albummatches.album.count, 50)
    }
    
    func validateAlbumResponse(model: AlbumResponse) {
        let album = model.album
        validateAlbum(album: album)
        
    }
    
    func validateAlbum(album: Album) {
        XCTAssertNotNil(album, "no album found")
        XCTAssertEqual(album.artist, "Phoenix")
        XCTAssertEqual(album.name, "Wolfgang Amadeus Phoenix")
        XCTAssertEqual(album.mbid, "9f80e404-9436-307a-a369-e93a2fdd6751")
        XCTAssertEqual(album.image.count, 6)
        XCTAssertEqual(album.tracks?.track.count, 10)
        let track = album.tracks?.track.first
        XCTAssertNotNil(track)
        XCTAssertEqual(track?.artist.name, "Phoenix")
        XCTAssertEqual(track?.name, "Lisztomania")
    }
}

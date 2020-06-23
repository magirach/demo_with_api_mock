//
//  AlbumsViewController.swift
//  last_fm_search
//
//  Created by Moinuddin Girach on 17/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import UIKit

class AlbumsViewController: BaseViewController {

    @IBOutlet weak var tblAlbum: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var arrAlbums = [Album]() {
        didSet {
            tblAlbum.reloadData()
            tblAlbum.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell") as! AlbumTableViewCell
        cell.loadData(data: arrAlbums[indexPath.row])
        return cell
    }
}

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mbid = arrAlbums[indexPath.row].mbid
        if mbid.isEmpty {
            showAlert(message: "mbid does not availabe for \(arrAlbums[indexPath.row].name.uppercased()) album.")
        } else {
            let albumInfoVC = self.storyboard?.instantiateViewController(identifier: "AlbumInfoViewController") as! AlbumInfoViewController
            albumInfoVC.mbid = mbid
            self.navigationController?.pushViewController(albumInfoVC, animated: true)
        }
    }
}

extension AlbumsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tblAlbum.isHidden = true
        } else {
            getAlbums(query: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    /// get ablum based on query
    /// - Parameter query: search query string
    func getAlbums(query: String) {
        MGRouter.task?.cancel()
        let input = MGRouterSearchAlbumsInput(urlParams: ["album": query])
        MGRouter(input: input).apiCall { (result: Result<AlbumsResponse?, Error>) in
            switch result {
            case let .success(response):
                self.arrAlbums = response!.results.albummatches.album
            case let .failure(error):
                print(error)
            }
        }
    }
}

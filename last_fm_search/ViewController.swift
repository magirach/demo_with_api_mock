//
//  AlbumsViewController.swift
//  last_fm_search
//
//  Created by Moinuddin Girach on 17/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {

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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell") as? AlbumTableViewCell else {
            return UITableViewCell()
        }
        cell.loadData(data: arrAlbums[indexPath.row])
        return cell
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func getAlbums(query: String) {
        MGRouter.task?.cancel()
        let input = MGRouterGetAlbumInput(urlParams: ["album": query])
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

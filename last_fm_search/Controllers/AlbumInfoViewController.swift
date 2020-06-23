//
//  AlbumInfoViewController.swift
//  last_fm_search
//
//  Created by Moinuddin Girach on 23/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import UIKit

class AlbumInfoViewController: BaseViewController {

    @IBOutlet weak var imgAlbum: MGImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblSortDesc: UILabel!
    @IBOutlet weak var tblTracks: UITableView!
    
    var mbid: String?
    
    var album: Album? {
        didSet {
            setData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAlbum(mbid: mbid!)
    }
    
    /// get albun information
    /// - Parameter mbid: album mbid string
    func getAlbum(mbid: String) {
        showLoader()
        MGRouter.task?.cancel()
        let input = MGRouterGetAlbumInput(urlParams: ["mbid": mbid])
        MGRouter(input: input).apiCall { [weak self] (result: Result<AlbumResponse?, Error>) in
            guard let `self` = self else {return}
            switch result {
            case let .success(response):
                self.album = response!.album
            case let .failure(error):
                self.showAlert(message: error.localizedDescription)
            }
            self.hideLoader()
        }
    }
    
    /// set album data
    func setData() {
        lblArtistName.text = album?.artist
        lblName.text = album?.name
        lblSortDesc.text = album?.wiki?.summary
        imgAlbum.setImage(url: album!.lagreImage)
        tblTracks.reloadData()
    }
}

extension AlbumInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album?.tracks?.track.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell") as! TrackTableViewCell
        cell.loadData(track: album!.tracks!.track[indexPath.row])
        return cell
    }
}

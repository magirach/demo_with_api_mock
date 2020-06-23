//
//  AlbumTableViewCell.swift
//  last_fm_search
//
//  Created by Moinuddin Girach on 23/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgAlbum: MGImageView!
    @IBOutlet weak var lblAlbumName: UILabel!
    @IBOutlet weak var lblAlbumDesc: UILabel!
    
    var album: Album!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadData(data: Album) {
        self.album = data
        imgAlbum.setImage(url: album.mediumImage)
        lblAlbumName.text = album.name
        lblAlbumDesc.text = album.artist
    }
    
    override func prepareForReuse() {
        imgAlbum.image = nil
    }
    
}

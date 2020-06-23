//
//  TrackTableViewCell.swift
//  last_fm_search
//
//  Created by Moinuddin Girach on 23/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    var track: Track?
    
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// load track data to cell
    /// - Parameter track: track object
    func loadData(track: Track) {
        self.track = track
        lblTrackName.text = track.name
        lblArtistName.text = track.artist.name
        lblDuration.text = track.formatedDuration
    }

}

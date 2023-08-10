//
//  VideoTableViewCell.swift
//  SeSACWeek4
//
//  Created by 문정호 on 2023/08/09.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 13)
        contentLabel.numberOfLines = 0
        thumbnailImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

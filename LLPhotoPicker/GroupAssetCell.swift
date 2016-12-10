//
//  GroupAssetCell.swift
//  LLPhotoPicker
//
//  Created by leoliu on 2016/12/6.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit
import Photos
class GroupAssetCell: UITableViewCell {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cover: UIImageView!
    var groupAsset: GroupAsset? {
        didSet {
            if let asset = groupAsset {
                self.titleLabel.text = asset.collectionTitle
                self.countLabel.text = String(asset.groupFetchResult.count)
                let scale = UIScreen.main.scale
                let thumbnailSize = CGSize(width: 70 * scale, height: 70 * scale)
                LLImageService.shareInstance.requestImage(for: asset.groupFetchResult.firstObject!, targetSize: thumbnailSize, resultHandler: {[weak self] image in
                    self?.cover.image = image
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier);
//        makeUI();
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func makeUI() {
//        
//    }
    override func prepareForReuse() {
        super.prepareForReuse()
        cover.image = nil
        titleLabel.text = nil
        countLabel.text = nil
    }
}

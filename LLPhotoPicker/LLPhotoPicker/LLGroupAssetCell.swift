//
//  LLGroupAssetCell.swift
//  LLPhotoPicker
//
//  Created by lbq on 2016/12/15.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit
import Photos

class LLGroupAssetCell: UITableViewCell {

    var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    var cover: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    var groupAsset: GroupAsset? {
        didSet {
            if let asset = groupAsset {
                self.titleLabel.text = asset.collectionTitle
                self.countLabel.text = String(asset.groupFetchResult.count)
                let thumbnailSize = CGSize(width: 70, height: 70)
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        makeUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        contentView.addSubview(cover)
        cover.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10.0)
            make.width.height.equalTo(70.0)
            make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(5.0)
            make.top.equalTo(cover)
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(cover)
        }
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        cover.image = nil
        titleLabel.text = nil
        countLabel.text = nil
    }
}

//
//  LLGridViewCell.swift
//  LLPhotoPicker
//
//  Created by lbq on 2016/12/7.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit
import Photos

class LLGridViewCell: UICollectionViewCell {
    var thumbnail: UIImageView = UIImageView()
    var live: UIImageView = UIImageView()
    
    var asset:PHAsset?{
        didSet{
            let scale = UIScreen.main.scale
            let width = (UIScreen.main.bounds.size.width / 4);
            let thumbnailSize = CGSize(width: width * scale, height: width * scale)
            LLImageService.shareInstance.requestImage(for: asset!, targetSize: thumbnailSize, resultHandler: {image in
                self.thumbnail.image = image
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        thumbnail = UIImageView()
        contentView.addSubview(thumbnail)
        thumbnail.snp.makeConstraints { maker in
            maker.edges.equalTo(contentView)
        }
        
        live = UIImageView()
        contentView.addSubview(live)
        live.snp.makeConstraints { make in
            make.left.top.equalTo(contentView)
            make.width.height.equalTo(20.0)
        }
    }
    
    
}

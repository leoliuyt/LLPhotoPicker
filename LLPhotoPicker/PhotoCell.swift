//
//  PhotoCell.swift
//  LLPhotoPicker
//
//  Created by lbq on 2016/12/15.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit
import Photos

class PhotoCell: UITableViewCell {
    
    static let maxInOneLine: Int = 4
    static let padding:CGFloat = 5.0
    static let maxPhotos: Int = 9
    static var wh: CGFloat {
        get {
            return ((CGFloat(UIScreen.main.bounds.width) - CGFloat(CGFloat(PhotoCell.maxInOneLine + 1) * PhotoCell.padding)) / CGFloat(PhotoCell.maxInOneLine))
        }
    }
    let addBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"image_select"), for: .normal)
        return btn
    }()
    
    var didClickAdd:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    var assets: [PHAsset]? {
        didSet{
            contentView.subviews.forEach({ (btn) in
                if btn.isKind(of: UIButton.self) {
                    btn.removeFromSuperview()
                }
            })
            if let assetValues = assets {
                var x: CGFloat = 0.0
                var y: CGFloat = 0.0
                var count = 0
                for (index, value) in assetValues.enumerated() {
                    let imgBtn = UIButton(type: .custom)
                    LLImageService.shareInstance.requestImage(for: value, targetSize: CGSize(width: PhotoCell.wh,height: PhotoCell.wh), resultHandler: { [weak self](image) in
                    
                        imgBtn.setBackgroundImage(image, for: .normal)
                        x = CGFloat(Int(index % PhotoCell.maxInOneLine)) * (PhotoCell.wh + PhotoCell.padding) + PhotoCell.padding
                        y = CGFloat(Int(index / PhotoCell.maxInOneLine)) * (PhotoCell.wh + PhotoCell.padding) + PhotoCell.padding
                        imgBtn.frame = CGRect(x: x , y: y, width: PhotoCell.wh, height: PhotoCell.wh)
                        count += 1
                        if let strongSelf = self {
                            strongSelf.contentView.addSubview(imgBtn)
                            if count == assetValues.count {
                                if assetValues.count != PhotoCell.maxPhotos {
                                    x = CGFloat(Int(assetValues.count % PhotoCell.maxInOneLine)) * (PhotoCell.wh + PhotoCell.padding) + PhotoCell.padding
                                    y = CGFloat(Int(assetValues.count / PhotoCell.maxInOneLine)) * (PhotoCell.wh + PhotoCell.padding) + PhotoCell.padding
                                    strongSelf.addBtn.frame = CGRect(x: x , y: y, width: PhotoCell.wh, height: PhotoCell.wh)
                                    strongSelf.contentView.addSubview(strongSelf.addBtn)
                                }
                            }
                        }
                    })
                }
                
            } else {
                addBtn.frame = CGRect(x: PhotoCell.padding, y: PhotoCell.padding, width: PhotoCell.wh, height: PhotoCell.wh)
                contentView.addSubview(addBtn)
            }
        }
    }
    
    func makeUI() {
        contentView.addSubview(addBtn)
        addBtn.frame = CGRect(x: PhotoCell.padding, y: PhotoCell.padding, width: PhotoCell.wh, height: PhotoCell.wh)
        addBtn.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
    }
    
    func clickAction(sender: UIButton) {
        if let clousce = didClickAdd {
            clousce()
        }
    }
    
    class func height(contents: [PHAsset]?) -> CGFloat {
        let count = contents?.count ?? 0
        return (wh + 2.0 * padding) * CGFloat(Int(count / maxInOneLine) + 1);
    }

}

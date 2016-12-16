//
//  LLImageService.swift
//  LLPhotoPicker
//
//  Created by lbq on 2016/12/8.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit
import Photos

class LLImageService: NSObject {
    private let imageManager: PHImageManager = PHImageManager.default()
    static let shareInstance: LLImageService = LLImageService()
    private override init() {
        super.init()
    }
    
    //裁剪缩略图
    func requestImage(for asset: PHAsset, targetSize: CGSize, resultHandler: @escaping (UIImage?) -> Swift.Void) {
        let scale = UIScreen.main.scale
        let thumbnailSize = CGSize(width: targetSize.width * scale, height: targetSize.height * scale)
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact;
        options.isNetworkAccessAllowed = false //不允许从iCloud 下载图片
        //.aspectFill 和 .exact 配合 才能裁剪出想要的图片
        //.aspectFit 让图片完整可见
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: options, resultHandler: { image, info in
            resultHandler(image)
        })
    }
}

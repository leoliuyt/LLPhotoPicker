//
//  LLImagePikcerViewController.swift
//  LLPhotoPicker
//
//  Created by lbq on 2016/12/7.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit
import Photos
class LLImagePikcerViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    @IBOutlet weak var collectionView: UICollectionView!
    var groupAsset: GroupAsset?
    override func viewDidLoad() {
        super.viewDidLoad()

        var itemSize: CGSize {
            get {
                let itemWidth = (screenWidth - 5 * 5 ) / 4
                return CGSize(width: itemWidth, height: itemWidth)
            }
        }
        
        let collectionFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.minimumInteritemSpacing = 5.0
        collectionFlowLayout.minimumLineSpacing = 5.0
        collectionFlowLayout.itemSize = itemSize
        
        self.collectionView.collectionViewLayout = collectionFlowLayout
        self.collectionView.contentInset = UIEdgeInsetsMake(10, 5, 10, 5);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension LLImagePikcerViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension LLImagePikcerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (groupAsset?.groupFetchResult.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LLGridViewCell.self), for: indexPath) as? LLGridViewCell
            else { fatalError("unexpected cell in collection view") }
        let asset = groupAsset?.groupFetchResult.object(at: indexPath.row)
        let scale = UIScreen.main.scale
        let width = (UIScreen.main.bounds.size.width / 4);
        let thumbnailSize = CGSize(width: width * scale, height: width * scale)
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact;
        options.isNetworkAccessAllowed = false //不允许从iCloud 下载图片
        PHImageManager.default().requestImage(for: asset!, targetSize: thumbnailSize, contentMode: .aspectFill, options: options, resultHandler: {  image,_ in
            cell.thumbnail.image = image
        })
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
}

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

    @IBOutlet weak var collectionView: UICollectionView!
    var groupAsset: GroupAsset?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LLImagePikcerViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return fetchResult.count
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let asset = fetchResult.object(at: indexPath.item)
//        
//        // Dequeue a GridViewCell.
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridViewCell.self), for: indexPath) as? GridViewCell
//            else { fatalError("unexpected cell in collection view") }
//        
//        #if os(iOS)
//            // Add a badge to the cell if the PHAsset represents a Live Photo.
//            if asset.mediaSubtypes.contains(.photoLive) {
//                cell.livePhotoBadgeImage = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
//            }
//        #endif
//        
//        // Request an image for the asset from the PHCachingImageManager.
//        cell.representedAssetIdentifier = asset.localIdentifier
//        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
//            // The cell may have been recycled by the time this handler gets called;
//            // set the cell's thumbnail image only if it's still showing the same asset.
//            if cell.representedAssetIdentifier == asset.localIdentifier {
//                cell.thumbnailImage = image
//            }
//        })
//        
//        return cell
//        
//    }
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
        options.resizeMode = .exact;
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: asset!, targetSize: thumbnailSize, contentMode: .aspectFit, options: nil, resultHandler: {  image,_ in
            cell.thumbnail.image = image
        })
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
}

extension LLImagePikcerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(UIScreen.main.bounds.size.width / 4);
        return CGSize(width: width, height: width)
    }

}

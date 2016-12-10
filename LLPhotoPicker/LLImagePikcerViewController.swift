//
//  LLImagePikcerViewController.swift
//  LLPhotoPicker
//
//  Created by lbq on 2016/12/7.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit
import Photos
import SnapKit

struct GroupAsset {
    var collection: PHAssetCollection
    var groupFetchResult: PHFetchResult<PHAsset>
    var collectionTitle: String
}

class LLImagePikcerViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var group:Array<GroupAsset> = []
    var collectionView: UICollectionView!
    var groupAsset: GroupAsset? {
        didSet {
            print("\(oldValue)")
        }
    }
    
    var titleBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    func makeUI(){
        makeCollectionView()
    }
    
    func makeCollectionView() {
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
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionFlowLayout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view);
        }
        
        collectionView.collectionViewLayout = collectionFlowLayout
        collectionView.contentInset = UIEdgeInsetsMake(10, 5, 10, 5);
    }
    
    func makeNaviTitleView() {
        titleBtn = UIButton(type: .custom)
        self.navigationItem.titleView = titleBtn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        self.group.removeAll()
        let fetchOption: PHFetchOptions = PHFetchOptions()
        //智能相册
        let smartResult: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: fetchOption)
        smartResult.enumerateObjects({ (collection, index, bool) in
            if collection.isKind(of: PHAssetCollection.self) {
                print("collectionTitle name:\(collection.localizedTitle!)")
                let albumItemResult: PHFetchResult = PHAsset.fetchAssets(in: collection, options: fetchOption)
                if albumItemResult.count > 0 {
                    let groupAsset = GroupAsset(collection: collection, groupFetchResult: albumItemResult, collectionTitle: collection.localizedTitle!)
                    self.group.append(groupAsset)
                }
            }
        })
        // 用户创建的相册
        // 列出所有用户创建的相册
        let topLevelUserCollections: PHFetchResult = PHAssetCollection.fetchTopLevelUserCollections(with: nil)
        topLevelUserCollections.enumerateObjects ({ (collection, index, bool) in
            if collection.isKind(of: PHAssetCollection.self) {
                print("user collection title\(collection.localizedTitle)")
                let albumItemResult: PHFetchResult = PHAsset.fetchAssets(in: collection as! PHAssetCollection, options: fetchOption)
                //每个相册中资源数
                if albumItemResult.count > 0 {
                    let groupAsset = GroupAsset(collection: collection as! PHAssetCollection, groupFetchResult: albumItemResult, collectionTitle: collection.localizedTitle!)
                    self.group.append(groupAsset)
                }
            }
        })
        
        print("-------------")
        
        for value in self.group {
            print("name:\(value.collectionTitle)")
            //            print(value.groupFetchResult)
            value.groupFetchResult.enumerateObjects({ (asset, index, bool) in
                print("width:\(asset.pixelWidth),height:\(asset.pixelHeight)")
            })
        }
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
        LLImageService.shareInstance.requestImage(for: asset!, targetSize: thumbnailSize, resultHandler: {image in
            cell.thumbnail.image = image
        })
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
}

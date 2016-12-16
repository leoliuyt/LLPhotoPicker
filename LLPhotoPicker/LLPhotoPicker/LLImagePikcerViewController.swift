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
    let reuseIdentifier = String(describing: LLGridViewCell.self)
    
    var selectedPhotos: [PHAsset]? = []
    var didSelectPhotos: ((_ assets:[PHAsset]?) -> Void)?
    var didSelectOnePhoto: ((_ asset: PHAsset?) -> Void)?
    
    private var group:Array<GroupAsset> = []
    private var collectionView: UICollectionView!
    
    let touchBtn: UIButton = {
        let btn = UIButton(type: .custom)
        return btn
    }()
    
    let groupView: LLGroupView = {
       let groupV = LLGroupView()
        return groupV
    }()
    
    let overLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.85)
        return view
    }()
    
    var groupItem: GroupAsset? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var titleBtn: LLButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        makeUI()
        loadData()
    }
    
    func makeUI(){
        makeNaviTitleView()
        makeCollectionView()
        makeNaviRight()
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
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view);
        }
        
        collectionView.collectionViewLayout = collectionFlowLayout
        collectionView.contentInset = UIEdgeInsetsMake(10, 5, 10, 5);
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(LLGridViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func makeNaviTitleView() {
        titleBtn = LLButton(type: LLButtonLayoutType.rightLeft)
        titleBtn?.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        titleBtn?.setTitle("相册", for: .normal)
        titleBtn?.setTitleColor(UIColor.black, for: .normal)
        titleBtn?.setImage(UIImage(named:"arraw_down"), for: .normal)
//        titleBtn?.backgroundColor = UIColor.orange;
        titleBtn?.addTarget(self, action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.titleView = titleBtn
    }
    func makeNaviRight() {
        let rightItem: UIBarButtonItem = UIBarButtonItem(title: "finish", style: .plain, target: self, action: #selector(finishClick(sender:)))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func finishClick(sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
        if let clource = self.didSelectPhotos {
            clource(self.selectedPhotos)
        }
    }
    
    func buttonClick(sender: LLButton) {
        UIView.animate(withDuration: 0.3, animations:{
            if let imageView = sender.imageView {
                if imageView.transform.isIdentity {
                    imageView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI))
                    self.showGroupView()
                } else {
                    imageView.transform = CGAffineTransform(rotationAngle: 0)
                    self.dismissGroupView()
                }
            }
        })
    }
    
    func dismissAction(sender: UIButton) {
        if let button = self.titleBtn {
            self.buttonClick(sender: button)
        }
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
        if let groupAsset = group.first {
            self.titleBtn?.setTitle(groupAsset.collectionTitle, for: .normal)
            self.groupItem = groupAsset
        } else {
            self.titleBtn?.setTitle(nil, for: .normal)
        }
        
    }
    
    func showGroupView() {
        
        let tableViewHeight: CGFloat = CGFloat(self.group.count >= 5 ? (min(self.group.count, 5) * 80) : (max(self.group.count, 5) * 80))
        
        view.addSubview(overLayerView)
        overLayerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(view).offset(64.0)
        }
        
        touchBtn.addTarget(self, action: #selector(dismissAction(sender:)), for: .touchUpInside)
        overLayerView.addSubview(touchBtn)
        touchBtn.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(overLayerView)
            make.height.equalTo(view).offset(CGFloat(screenHeight - tableViewHeight - 64.0))
        }
        
        overLayerView.alpha = 0
        
        view.addSubview(groupView)
        groupView.snp.makeConstraints { (make) in
            make.left.right.equalTo(overLayerView)
            make.height.equalTo(tableViewHeight)
            make.top.equalTo(-tableViewHeight)
        }
        
        groupView.didSelectGroupAsset = { [weak self] gpAsset in
            self?.groupItem = gpAsset
            if let btn = self?.titleBtn, let gp = gpAsset{
                btn.setTitle(gp.collectionTitle, for: .normal)
                self?.buttonClick(sender: btn)
            }
            self?.collectionView.reloadData()
        }
        
        view.insertSubview(overLayerView, belowSubview: groupView)

        UIView.animate(withDuration: 0.1, animations: {
            self.overLayerView.alpha = 0.85
        }, completion:{ complete in
            self.groupView.group = self.group
            self.groupView.snp.remakeConstraints { (make) in
                make.left.top.right.equalTo(self.overLayerView)
                make.height.equalTo(tableViewHeight)
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion:{ complete in
                
            })
        })
    }
    
    func dismissGroupView() {
        let tableViewHeight = self.group.count >= 5 ? (min(self.group.count, 5) * 80) : (max(self.group.count, 5) * 80)
        groupView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(overLayerView)
            make.height.equalTo(tableViewHeight)
            make.top.equalTo(-tableViewHeight)
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.overLayerView.alpha = 0
        }, completion:{ complete in
            self.overLayerView.removeFromSuperview()
        })
    }
    
    deinit {
        print("\(self) deinit")
    }
}

extension LLImagePikcerViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let asset = groupItem?.groupFetchResult.object(at: indexPath.row) {
            self.selectedPhotos?.append(asset)
            print("--------count:\(self.selectedPhotos?.count)")
        }
    }
}

extension LLImagePikcerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (groupItem?.groupFetchResult.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? LLGridViewCell
            else { fatalError("unexpected cell in collection view") }
        let asset = groupItem?.groupFetchResult.object(at: indexPath.row)
        cell.asset = asset
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
}

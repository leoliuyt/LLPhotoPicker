//
//  ViewController.swift
//  LLPhotoPicker
//
//  Created by leoliu on 2016/12/5.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit
import Photos

struct GroupAsset {
    var collection: PHAssetCollection
    var groupFetchResult: PHFetchResult<PHAsset>
    var collectionTitle: String
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var group:Array<GroupAsset> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
//        test1();
    }
    
    func loadData(){
        self.group.removeAll()
        let fetchOption: PHFetchOptions = PHFetchOptions()
        //case album //相册
        //case smartAlbum //智能相册(内容动态更新 如最近添加)
        //case moment //(根据时间、地点建立的相册)
        
        //case AlbumRegular //用户在 Photos 中创建的相册，也就是我所谓的逻辑相册
        //case AlbumSyncedEvent //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步过来的事件。然而，在iTunes 12 以及iOS 9.0 beta4上，选用该类型没法获取同步的事件相册，而必须使用AlbumSyncedAlbum。
        //case AlbumSyncedFaces //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步的人物相册。
        //case AlbumSyncedAlbum //做了 AlbumSyncedEvent 应该做的事
        //case AlbumImported //从相机或是外部存储导入的相册，完全没有这方面的使用经验，没法验证。
        //case AlbumMyPhotoStream //用户的 iCloud 照片流
        //case AlbumCloudShared //用户使用 iCloud 共享的相册
        //case SmartAlbumGeneric //文档解释为非特殊类型的相册，主要包括从 iPhoto 同步过来的相册。由于本人的 iPhoto 已被 Photos 替代，无法验证。不过，在我的 iPad mini 上是无法获取的，而下面类型的相册，尽管没有包含照片或视频，但能够获取到。
        //case SmartAlbumPanoramas //相机拍摄的全景照片
        //case SmartAlbumVideos //相机拍摄的视频
        //case SmartAlbumFavorites //收藏文件夹
        //case SmartAlbumTimelapses //延时视频文件夹，同时也会出现在视频文件夹中
        //case SmartAlbumAllHidden //包含隐藏照片或视频的文件夹
        //case SmartAlbumRecentlyAdded //相机近期拍摄的照片或视频
        //case SmartAlbumBursts //连拍模式拍摄的照片，在 iPad mini 上按住快门不放就可以了，但是照片依然没有存放在这个文件夹下，而是在相机相册里。
        //case SmartAlbumSlomoVideos //Slomo 是 slow motion 的缩写，高速摄影慢动作解析，在该模式下，iOS 设备以120帧拍摄。不过我的 iPad mini 不支持，没法验证。
        //case SmartAlbumUserLibrary //这个命名最神奇了，就是相机相册，所有相机拍摄的照片或视频都会出现在该相册中，而且使用其他应用保存的照片也会出现在这里。
        //case Any //包含所有类型
        
        //智能相册
        let smartResult: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: fetchOption)
        smartResult.enumerateObjects({ (collection, index, bool) in
            if collection.isKind(of: PHAssetCollection.self) {
                print("collectionTitle name:\(collection.localizedTitle!)")
                let albumItemResult: PHFetchResult = PHAsset.fetchAssets(in: collection, options: fetchOption)
                if albumItemResult.count > 0 {
                   let groupAsset = GroupAsset(collection: collection, groupFetchResult: albumItemResult, collectionTitle: self.localizedString(title: collection.localizedTitle))
                    self.group.append(groupAsset)
                }
            }
        })
        // 用户创建的相册
        // 列出所有用户创建的相册
//        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
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
        
        tableView.reloadData()
    }
    
    func localizedString(title: String?) -> String {
        if let string = title {
            switch string {
            case "Videos":
                return "视频"
            case "Panoramas":
                return "全景照"
            case "Slo-mo":
                return "高速摄影慢动作解析"
            case "Favorites":
                return "我的收藏"
            case "Time-lapse":
                return "延时视频"
            case "Bursts":
                return "连拍照"
            case "Recently Added":
                return "最近添加"
            case "Hidden":
                return "隐藏"
            case "Camera Roll":
                return "相机胶卷"
            case "Selfies":
                return "自拍照"
            case "Screenshots":
                return "屏幕截图"
            default:
                return ""
            }
        } else {
            return ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? LLImagePikcerViewController
            else { fatalError("unexpected view controller for segue") }
        
        let indexPath = tableView!.indexPath(for: sender as! UITableViewCell)!
        destination.groupAsset = self.group[indexPath.row]
    }
}

extension ViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.group.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GroupAssetCell = tableView.dequeueReusableCell(withIdentifier: "GroupAssetCell") as! GroupAssetCell
        cell.groupAsset = self.group[indexPath.row]
        return cell
    }
}

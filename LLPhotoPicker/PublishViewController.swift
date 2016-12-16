//
//  PublishViewController.swift
//  LLPhotoPicker
//
//  Created by lbq on 2016/12/15.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit
import Photos

class PublishViewController: UIViewController {

    var selectAssets: [PHAsset]?
    let reuseIdentifier = String(describing: PhotoCell.self)
    
    let tableView: UITableView = {
       let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PhotoCell.self, forCellReuseIdentifier:reuseIdentifier)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PublishViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PhotoCell.height(contents: self.selectAssets)
    }
}

extension PublishViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PhotoCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! PhotoCell
        cell.assets = self.selectAssets
        cell.didClickAdd = {[weak self] in
            if let strongSelf = self {
                strongSelf.showPhotoPicker()
            }
        }
        return cell
    }
    
    func showPhotoPicker() {
        let pickerVC: LLImagePikcerViewController = LLImagePikcerViewController()
        pickerVC.didSelectPhotos = { [weak self] assets in
            if let strongSelf = self {
                strongSelf.selectAssets = assets
                strongSelf.tableView.reloadData()
            }
        }
//        let nav: UINavigationController = UINavigationController(rootViewController: pickerVC)
//        self.show(nav, sender: nil)
        self.navigationController?.pushViewController(pickerVC, animated: true);
    }
}

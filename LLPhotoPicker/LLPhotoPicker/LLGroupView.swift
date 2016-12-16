//
//  LLGroupView.swift
//  LLPhotoPicker
//
//  Created by lbq on 2016/12/13.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit

class LLGroupView: UIView {
    let reuseIdentifier = String(describing: LLGroupAssetCell.self)
    
    var group:Array<GroupAsset>?{
        didSet {
            tableView.reloadData()
        }
    }
    
    var didSelectGroupAsset: ((_ groupAsset: GroupAsset?) -> Void)?
    
    var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        return table
    }()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LLGroupAssetCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }

}

extension LLGroupView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let groupAsset = self.group?[indexPath.row]
        if let didSelect = didSelectGroupAsset {
            didSelect(groupAsset)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

extension LLGroupView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let gp = group {
            return gp.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? LLGroupAssetCell else {
            fatalError("unexpected cell in collection view")
        }
        
        cell.groupAsset = self.group?[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

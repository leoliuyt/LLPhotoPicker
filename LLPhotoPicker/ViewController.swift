//
//  ViewController.swift
//  LLPhotoPicker
//
//  Created by leoliu on 2016/12/5.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit
import Photos
import SnapKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        let button: LLButton = LLButton(type: .bottomTop)
        button.setTitle("添加图片", for: .normal)
        button.setImage(UIImage(named:"image_select"), for: .normal)
        button.addTarget(self, action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints{ make in
            make.width.height.equalTo(70)
            make.top.equalTo(view).offset(64)
            make.centerX.equalTo(view)
        }
    }

    func buttonClick(sender: LLButton) {
        pushPublishVC()
        UIView.animate(withDuration: 0.3, animations:{
            if let imageView = sender.imageView {
                if imageView.transform.isIdentity {
                    imageView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI))
                } else {
                    imageView.transform = CGAffineTransform(rotationAngle: 0)
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPhotoPicker() {
        let pickerVC: LLImagePikcerViewController = LLImagePikcerViewController()
        let nav: UINavigationController = UINavigationController(rootViewController: pickerVC)
        self.show(nav, sender: nil)
    }
    
    func pushPublishVC() {
        let vc: PublishViewController = PublishViewController()
//        let nav: UINavigationController = UINavigationController(rootViewController: vc)
//        self.show(nav, sender: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



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
    static let shareInstance: LLImageService = LLImageService()
    private override init() {
        super.init()
    }
}

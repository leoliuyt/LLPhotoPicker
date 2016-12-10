//
//  LLButton.swift
//  LLPhotoPicker
//
//  Created by lbq on 2016/12/9.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit

enum LLButtonLayoutType : Int{
    case normal,leftRight //左图右文
    case rightLeft //右图左文
    case topBottom //上图下文
    case bottomTop //下图上文
}

extension UIButton {
    
}

class LLButton : UIControl {
    
    var titleLabel: UILabel?
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: UIButtonType) {
        self.init(frame: CGRect.zero)
    }
    
    // default is nil. title is assumed to be single line
    func setTitle(_ title: String?, for state: UIControlState) {
        if let text = title {
            if let label = self.titleLabel {
                label.text = text
            } else {
                titleLabel = UILabel()
                titleLabel?.text = text
                addSubview(titleLabel!)
            }
        } else {
            titleLabel = nil;
        }
        setNeedsLayout()
    }
    
    // default if nil. use opaque white
    func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        self.titleLabel?.textColor = color
    }
    
    // default is nil. should be same size if different for different states
    func setImage(_ image: UIImage?, for state: UIControlState) {
        if let img = image {
            if let view = self.imageView {
                view.image = image
            } else {
                imageView = UIImageView(image: img)
                addSubview(imageView!)
            }
        } else {
            imageView = nil
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel?.frame = titleRect(for: self.bounds)
        self.imageView?.frame = imageRect(for: self.bounds)
    }
    
    func titleRect(for: CGRect) -> CGRect {
        if (self.titleLabel?.text) != nil {
            let size = imageSize()
            let labelSize = titleSize()
            let y = (max(size.height, labelSize.height) - labelSize.height)/2.0
            let frame = CGRect(x: 0, y: y, width: labelSize.width, height: max(size.height, labelSize.height))
            return frame
        } else {
            return CGRect.zero
        }
    }
    
    func imageRect(for: CGRect) -> CGRect {
        if (self.imageView?.image) != nil {
            let size = imageSize()
            let labelSize = titleSize()
            let x = labelSize.width > 0 ? (labelSize.width + 5 ): 0
            let y = (max(size.height, labelSize.height) - size.height)/2.0
            let frame = CGRect(x: x, y: y, width: size.width, height: size.height)
            return frame
        } else {
            return CGRect.zero
        }
    }
    
    
    func boundRect() -> CGRect {
        let size = imageSize()
        let labelSize = titleSize()
        let width = size.width + 5 + labelSize.width
        let frame = CGRect(x: 0, y: 0, width: width, height: max(size.height,labelSize.height))
        return frame
    }
    
    private func titleSize() -> CGSize {
        if let label = self.titleLabel , let text = label.text{
            let string: NSString = NSString(string: text);
            let size = CGSize(width: 1000, height: 1000)
            let dict = [NSFontAttributeName:label.font,
                        NSBackgroundColorAttributeName:label.textColor
                        ]
            let labelSize = string.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dict, context: nil).size;
            return CGSize(width: ceil(labelSize.width) + 1, height: ceil(labelSize.height))
        } else {
            return CGSize.zero
        }
    }
    
    private func imageSize() -> CGSize {
        if let image = self.imageView?.image {
            return image.size
        }else {
            return CGSize.zero
        }
    }
    
    // default is nil
    open func setBackgroundImage(_ image: UIImage?, for state: UIControlState) {
        
    }
}


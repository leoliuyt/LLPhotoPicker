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
    var backgroundImageView: UIImageView?
    
    var contentEdgeInsets: UIEdgeInsets?
    
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
        let bounds = self.bounds
        let rect = contentRect(for: bounds)
//        const CGRect bounds = self.bounds;
//        const CGRect contentRect = [self contentRectForBounds:bounds];
        self.backgroundImageView?.frame = contentRect(for: bounds)
        self.titleLabel?.frame = titleRect(for: rect)
        self.imageView?.frame = imageRect(for: rect)
    }
    
    func contentRect(for contentRect: CGRect) -> CGRect {
        if let insets = contentEdgeInsets {
            return UIEdgeInsetsInsetRect(contentRect, insets)
        } else {
            return UIEdgeInsetsInsetRect(contentRect, UIEdgeInsets.zero)
        }
    }
    
    func titleRect(for contentRect: CGRect) -> CGRect {
        if (self.titleLabel?.text) != nil {
            let size = imageSize()
            let labelSize = titleSize()
//            let y = (max(size.height, labelSize.height) - labelSize.height)/2.0
//            let frame = CGRect(x: 0, y: y, width: labelSize.width, height: max(size.height, labelSize.height))
//            return frame
//            UIEdgeInsets inset = _titleEdgeInsets;
            var inset: UIEdgeInsets = UIEdgeInsets()
//            inset.left += size.width;
            inset.right += size.width
            return componentRect(for: labelSize, contentRect: UIEdgeInsetsInsetRect(contentRect, inset))
        } else {
            return CGRect.zero
        }
    }
    
    func imageRect(for contentRect: CGRect) -> CGRect {
        if (self.imageView?.image) != nil {
            let size = imageSize()
            let labelSize = titleSize()
//            let x = labelSize.width > 0 ? (labelSize.width + 5 ): 0
//            let y = (max(size.height, labelSize.height) - size.height)/2.0
//            let frame = CGRect(x: x, y: y, width: size.width, height: size.height)
//            return frame
            var inset: UIEdgeInsets = UIEdgeInsets()
//            inset.right += labelSize.width;
            inset.left = labelSize.width;
            return componentRect(for: size, contentRect: UIEdgeInsetsInsetRect(contentRect, inset))
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
    
    private func componentRect(for size: CGSize, contentRect: CGRect) -> CGRect {
        var rect: CGRect = CGRect.zero
        rect.origin = contentRect.origin
        rect.size = size
        
        if rect.maxX > contentRect.maxX {
            rect.size.width -= (rect.maxX - contentRect.maxX)
        }
        rect.origin.x += CGFloat(floorf(Float(contentRect.size.width - rect.size.width)/2.0))
        rect.origin.y += CGFloat(floorf(Float(contentRect.size.height - rect.size.height)/2.0));
        return rect
    }
    
//    static func UIEdgeInsetsInsetRect(rect: CGRect,insets: UIEdgeInsets) -> CGRect {
//        var rt = rect
//        rt.origin.x    += insets.left;
//        rt.origin.y    += insets.top;
//        rt.size.width  -= (insets.left + insets.right);
//        rt.size.height -= (insets.top  + insets.bottom);
//        return rt;
//    }

}


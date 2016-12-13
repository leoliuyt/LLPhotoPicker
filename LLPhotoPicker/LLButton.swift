//
//  LLButton.swift
//  LLButton
//
//  Created by leoliu on 2016/12/11.
//  Copyright © 2016年 LL. All rights reserved.
//

import UIKit

extension UIButton {

}

private enum ButtonContentType : String {
    case title
    case titleColor
    case shadowColor
    case image
    case backgroundImage
}

enum LLButtonLayoutType : Int{
    case normal,leftRight //左图右文
    case rightLeft //右图左文
    case topBottom //上图下文
    case bottomTop //下图上文
}


class LLButton : UIControl {

    var titleLabel: UILabel?
    var imageView: UIImageView?
    var backgroundImageView: UIImageView?
    
    var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    var titleEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    var imageEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    
//    var reversesTitleShadowWhenHighlighted: Bool //false
//    var adjustsImageWhenHighlighted: Bool //true
//    var adjustsImageWhenDisabled: Bool //true
//    var showsTouchWhenHighlighted: Bool //false
    
    var buttonType: UIButtonType?

    var buttonLayoutType: LLButtonLayoutType?
    private var contentDic: [String : [String : Any]] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: LLButtonLayoutType = .normal) {
        self.init(frame: CGRect.zero)
        buttonLayoutType = type
    }
    
    private func makeUI() {
        titleLabel = UILabel()
        imageView = UIImageView()
        backgroundImageView = UIImageView()
        
        titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        titleLabel?.backgroundColor = UIColor.clear;
        titleLabel?.textAlignment = .left;
        titleLabel?.shadowOffset = CGSize.zero;
        
        addSubview(backgroundImageView!)
        addSubview(titleLabel!)
        addSubview(imageView!)
        
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("bounds ====== \(self.bounds)")
        let bounds = self.bounds
        let rect = contentRect(forBounds: bounds)
        self.backgroundImageView?.frame = backgroundRect(forBounds: bounds)
        self.imageView?.frame = imageRect(forContentRect: rect)
        self.titleLabel?.frame = titleRect(forContentRect: rect)
    }

    func setTitle(_ title: String?, for state: UIControlState) {
        setContent(title, for: state, type: ButtonContentType.title)
    }
    
    func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        setContent(color, for: state, type: ButtonContentType.titleColor)
    }
    
    func setTitleShadowColor(_ color: UIColor?, for state: UIControlState) {
        setContent(color, for: state, type: ButtonContentType.shadowColor)
    }
    
    func setImage(_ image: UIImage?, for state: UIControlState) {
        setContent(image, for: state, type: ButtonContentType.image)
    }
    
    func setBackgroundImage(_ image: UIImage?, for state: UIControlState) {
        setContent(image, for: state, type: ButtonContentType.backgroundImage)
    }
    
    func setAttributedTitle(_ title: NSAttributedString?, for state: UIControlState) {
        
    }
    
    func title(for state: UIControlState) -> String? {
        guard let value = defaultContentForState(for: state, type: ButtonContentType.title), let stringValue = value as? String
        else {
            return nil;
        }
        return stringValue
    }
    
    func titleColor(for state: UIControlState) -> UIColor? {
        guard let value = defaultContentForState(for: state, type: ButtonContentType.titleColor), let colorValue = value as? UIColor
            else {
                return nil;
        }
        return colorValue
    }
    
    func titleShadowColor(for state: UIControlState) -> UIColor? {
        guard let value = defaultContentForState(for: state, type: ButtonContentType.shadowColor), let shadowColorValue = value as? UIColor
            else {
                return nil;
        }
        return shadowColorValue
    }
    
    func image(for state: UIControlState) -> UIImage? {
        guard let value = defaultContentForState(for: state, type: ButtonContentType.image), let imageValue = value as? UIImage
            else {
                return nil;
        }
        return imageValue
    }
    
    func backgroundImage(for state: UIControlState) -> UIImage? {
        guard let value = defaultContentForState(for: state, type: ButtonContentType.backgroundImage), let backgroundImageValue = value as? UIImage
            else {
                return nil;
        }
        return backgroundImageValue
    }
    
    func attributedTitle(for state: UIControlState) -> NSAttributedString? {
//        guard let value = defaultContentForState(for: state, type: ButtonContentType.backgroundImage), let backgroundImageValue = value as? UIImage
//            else {
//                return nil;
//        }
//        return backgroundImageValue
        return NSAttributedString()
    }
    
// normal/highlighted/selected/disabled.
    var currentTitle: String? {
        return titleLabel?.text
    }
    
    var currentTitleColor: UIColor {
        if let color = titleLabel?.textColor {
            return color
        } else {
            return UIColor.white
        }
    }
    
    var currentTitleShadowColor: UIColor? {
        return titleLabel?.shadowColor
    }
    
    var currentImage: UIImage? {
        return imageView?.image
    }
    
    var currentBackgroundImage: UIImage? {
        return backgroundImageView?.image
    }
    
    var currentAttributedTitle: NSAttributedString? {
        return titleLabel?.attributedText
    }
    
    func backgroundRect(forBounds bounds: CGRect) -> CGRect {
        return bounds
    }
    
    func contentRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, contentEdgeInsets)
    }
    
    func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        if (self.titleLabel?.text) != nil {
            let imgSize = imageSize()
            let labelSize = titleSize()
            let insetLeftRightValue = imgSize.width >= contentRect.width ? min(imgSize.width, contentRect.width) : imgSize.width
            let insetTopBottomValue = imgSize.height >= contentRect.height ? min(imgSize.height, contentRect.height) : imgSize.height
            
            var inset: UIEdgeInsets = UIEdgeInsets()
            if let type = buttonLayoutType {
                switch type {
                case .normal,.leftRight:
                    inset.left += insetLeftRightValue
                case .rightLeft:
                    inset.right += insetLeftRightValue
                case .topBottom:
                    inset.top += insetTopBottomValue
                case .bottomTop:
                    inset.bottom += insetTopBottomValue
                }
            } else {
                //default
                inset.left += imgSize.width
            }
            return componentRect(for: labelSize, contentRect: UIEdgeInsetsInsetRect(contentRect, inset))
        } else {
            return CGRect.zero
        }
    }
    
    func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        if (self.imageView?.image) != nil {
            let imgSize = imageSize()
            let labelSize = titleSize()
            var inset: UIEdgeInsets = UIEdgeInsets()
            let totalWidth = imgSize.width + labelSize.width
            let totalHeight = imgSize.height + labelSize.height
            let insetLeftRightValue = totalWidth >= contentRect.width ? max(contentRect.width - imgSize.width,0.0) : labelSize.width
            let insetTopBottomValue = totalHeight >= contentRect.height ? max(contentRect.height - imgSize.height,0.0) : labelSize.height
            if let type = buttonLayoutType {
                switch type {
                case .normal,.leftRight:
                    inset.right += insetLeftRightValue
                case .rightLeft:
                    inset.left += insetLeftRightValue
                case .topBottom:
                    inset.bottom += insetTopBottomValue
                case .bottomTop:
                    inset.top += insetTopBottomValue
                }
            } else {
                inset.right = labelSize.width;
            }
            let a = UIEdgeInsetsInsetRect(contentRect, inset)
            print("\(a)")
            return componentRect(for: imgSize, contentRect: UIEdgeInsetsInsetRect(contentRect, inset))
        } else {
            return CGRect.zero
        }
    }
    
//MARK:private
    private func setContent(_ value: Any?, for state: UIControlState, type: ButtonContentType) {
        let contentKey: String = type.rawValue
        let typeKey = String(state.rawValue)
        var typeContent = contentDic[contentKey]
        guard var typeDic = typeContent else {
            if let content = value {
                typeContent = [typeKey:content]
                contentDic[contentKey] = typeContent
                updateContent()
            }
            return
        }
        
        if let content = value {
            typeDic[typeKey] = content
            contentDic[contentKey] = typeDic
        } else {
            _ = typeDic.removeValue(forKey: typeKey)
            if typeDic.values.count > 0 {
                contentDic[contentKey] = typeDic
            } else {
                contentDic.removeValue(forKey: contentKey)
            }
        }
        
        updateContent()
    }
    
    private func updateContent(){
        let state = self.state
        
        if let strTitle = title(for: state) {
            if let label = titleLabel {
                label.text = strTitle
                label.textColor = titleColor(for: state)
                label.shadowColor = titleShadowColor(for: state)
            } else {
                titleLabel = UILabel()
                titleLabel?.text = strTitle
                titleLabel?.textColor = titleColor(for: state)
                titleLabel?.shadowColor = titleShadowColor(for: state)
                addSubview(titleLabel!)
            }
        } else {
            titleLabel?.removeFromSuperview()
            titleLabel = nil
        }

        
        if let image = contentForState(for: state, type: ButtonContentType.image), let img = image as? UIImage{
            if let imgV = imageView {
                imgV.image = img
            } else {
                imageView = UIImageView(image: img)
                addSubview(imageView!)
            }
        } else {
            imageView?.removeFromSuperview()
            imageView = nil
        }
        
        if let bgImage = contentForState(for: state, type: ButtonContentType.backgroundImage), let bgImg = bgImage as? UIImage{
            if let imgV = backgroundImageView {
                imgV.image = bgImg
            } else {
                backgroundImageView = UIImageView(image: bgImg)
                addSubview(backgroundImageView!)
                sendSubview(toBack: backgroundImageView!)
            }
        } else {
            backgroundImageView?.removeFromSuperview()
            backgroundImageView = nil
        }
         setNeedsLayout()
    }
    
    private func contentForState(for state: UIControlState, type: ButtonContentType) -> Any? {
        let contentKey: String = type.rawValue
        let typeKey = String(state.rawValue)
        return contentDic[contentKey]?[typeKey]
    }
    
    private func defaultContentForState(for state: UIControlState, type: ButtonContentType) -> Any? {
        
        if let value = contentForState(for: state, type: type) {
            return value
        } else {
            return contentForState(for: .normal, type: type)
        }
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
    
    private func componentRect(for size: CGSize, contentRect: CGRect) -> CGRect {
        var rect: CGRect = CGRect.zero
        rect.origin = contentRect.origin
        rect.size = size
        
        if let type = buttonLayoutType {
            switch type {
            case .normal,.leftRight,.rightLeft:
                if rect.maxX > contentRect.maxX {
                    rect.size.width -= (rect.maxX - contentRect.maxX)
                }
            case .topBottom,.bottomTop:
                if rect.maxY > contentRect.maxY {
                    rect.size.height -= (rect.maxY - contentRect.maxY)
                }
                rect.size.width = min(size.width, contentRect.width)
            }
        } else {
            if rect.maxX > contentRect.maxX {
                rect.size.width -= (rect.maxX - contentRect.maxX)
            }
        }
        rect.origin.x += CGFloat(floorf(Float(contentRect.size.width - rect.size.width)/2.0))
        rect.origin.y += CGFloat(floorf(Float(contentRect.size.height - rect.size.height)/2.0))
        
        return rect
    }
}

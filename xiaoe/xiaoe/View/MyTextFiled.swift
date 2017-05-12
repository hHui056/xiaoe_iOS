//
//  MyTextFiled.swift
//  xiaoe
//
//  Created by 何辉 on 2017/4/28.
//  Copyright © 2017年 何辉. All rights reserved.
//

import UIKit

@IBDesignable class MyTextFiled: UITextField {
    
    typealias RightSelectHandler = (UITextField, Bool) -> Void
    
    let DEFULT_COLOLR = UIColor.lightGray
    
    var rightButtonSelected = false
    
    var rightSelectedHandler: RightSelectHandler?
    
    
    @IBInspectable var leftImage: UIImage? {
        set {
            if leftView == nil {
                leftView = UIView(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
                leftViewMode = .always
            }
            
            let leftImgView = UIImageView(image: newValue)
            leftImgView.contentMode = .scaleAspectFit
            leftImgView.tag = 1000
            leftImgView.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
            
            leftView?.addSubview(leftImgView)
        }
        
        get {
            if let leftImgView = leftView?.viewWithTag(1000) as? UIImageView {
                return leftImgView.image
            }
            return nil
        }
    }
    
    @IBInspectable var leftImageSizeToSuper: CGFloat {
        
        set {
            if let leftImgView = leftView?.viewWithTag(1000) as? UIImageView {
                leftImgView.frame = CGRect(x: frame.height*(1-newValue)/2,
                                           y: frame.height*(1-newValue)/2,
                                           width: frame.height*newValue,
                                           height: frame.height*newValue)
            }
        }
        
        get {
            if let leftImgView = leftView?.viewWithTag(1000) as? UIImageView {
                return leftImgView.frame.height / frame.height
            }
            return 0
        }
    }
}


extension MyTextFiled {
    
    @IBInspectable var rightImage: UIImage? {
        set {
            if rightView == nil {
                rightView = UIView(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
                rightViewMode = .always
            }
            let newImage = newValue?.withRenderingMode(.alwaysTemplate)
            let rightImgView = UIImageView(image: newImage)
            rightImgView.contentMode = .scaleAspectFit
            rightImgView.tag = 1001
            rightImgView.tintColor = DEFULT_COLOLR
            rightImgView.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
            
            rightView?.addSubview(rightImgView)
            
            // 按钮手势
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(rightViewTaped(_:)))
            rightView?.addGestureRecognizer(tapGes)
        }
        
        get {
            if let rightImgView = rightView?.viewWithTag(1001) as? UIImageView {
                return rightImgView.image
            }
            return nil
        }
    }
    
    
    @IBInspectable var rightImageSizeToSuper: CGFloat {
        
        set {
            if let rightImgView = rightView?.viewWithTag(1001) as? UIImageView {
                rightImgView.frame = CGRect(x: frame.height*(1-newValue)/2,
                                            y: frame.height*(1-newValue)/2,
                                            width: frame.height*newValue,
                                            height: frame.height*newValue)
            }
        }
        
        get {
            if let rightImgView = rightView?.viewWithTag(1001) as? UIImageView {
                return rightImgView.frame.height / frame.height
            }
            return 0
        }
    }
}

extension MyTextFiled {
    
    func rightViewTaped(_ sender: UIView) {
        if let rightImgView = rightView?.viewWithTag(1001) as? UIImageView {
            rightButtonSelected = !rightButtonSelected
            rightImgView.tintColor = rightButtonSelected ? tintColor : DEFULT_COLOLR
            rightSelectedHandler?(self, rightButtonSelected)
        }
    }
}

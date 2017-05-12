//
//  UIKit.swift
//  ETiLinkDemo
//
//  Created by Heee on 15/8/13.
//  Copyright (c) 2015年 Heee. All rights reserved.
//

import UIKit
import Dispatch

// MARK: - UIView
extension UIView {
    
    var frameX: CGFloat {
        return frame.origin.x
    }
    
    var frameY: CGFloat {
        return frame.origin.y
    }
    
    var frameW: CGFloat {
        return frame.width
    }
    
    var frameH: CGFloat {
        return frame.height
    }
    
    var frameSumX: CGFloat {
        return frame.origin.x + frame.width
    }
    
    var frameSumY: CGFloat {
        return frame.origin.y + frame.height
    }
    
    //查找该视图中得第一响应者
    var findFirstResponder: UIView? {
        if self.isFirstResponder {
            return self
        }
        for subview in self.subviews {
            if let resView = subview.findFirstResponder {
                return resView
            }
        }
        return nil
    }
    
    func removeAllSubviews() {
        for v in subviews {
            v.removeFromSuperview()
        }
    }
}


@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let c = layer.borderColor {
                return UIColor(cgColor: c)
            }
            return nil
        }
        set { layer.borderColor = newValue?.cgColor }
    }
}


private var kButtonTouchUpInside = "kButtonTouchUpInside"
extension UIButton {
    
    typealias TouchUpInsideHandler = (() -> Void)
    
    class ClosureWrapper {
        var closure: TouchUpInsideHandler
        
        init(_ closure: @escaping TouchUpInsideHandler) {
            self.closure = closure
        }
    }
    
    func addTouchUpInside(handler: @escaping TouchUpInsideHandler) {
        self.addTarget(self, action: #selector(touchedEvent(sender:)), for: .touchUpInside)
        objc_setAssociatedObject(self, &kButtonTouchUpInside, ClosureWrapper(handler), .OBJC_ASSOCIATION_RETAIN)
    }

    func touchedEvent(sender: UIButton) {
        let handler = objc_getAssociatedObject(self, &kButtonTouchUpInside) as? ClosureWrapper
        handler?.closure()
    }
}


private var kAlertViewTouched = "kAlertViewTouched"
extension UIAlertView {
    
    typealias TouchedHandler = ((_ alertView: UIAlertView, _ buttonIndex: Int) -> Void)
    
    class ClosureWrapper {
        var closure: TouchedHandler?
        
        init(_ closure: TouchedHandler?) {
            self.closure = closure
        }
    }
    
    /// 弹出 Alert 提示框
    class func showAlert(title: String?, message: String?, cancelTitle: String?, otherTitles: [String]?, handler: TouchedHandler?) {
        
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelTitle)
        alert.delegate = alert

        
        if let titles = otherTitles {
            for s in titles {
                alert.addButton(withTitle: s)
            }
        }
        objc_setAssociatedObject(alert, &kAlertViewTouched, ClosureWrapper(handler), .OBJC_ASSOCIATION_RETAIN)
        alert.show()
        
        /// 当 没有 Title 时, 1s 后自动隐藏
        if cancelTitle == nil && otherTitles == nil {
            let time = DispatchTime.init(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + 1)
            DispatchQueue.global().asyncAfter(deadline: time) {
                alert.dismiss(withClickedButtonIndex: 0, animated: true)
            }
        }
    }
    
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let wrapper = objc_getAssociatedObject(alertView, &kAlertViewTouched) as? ClosureWrapper
        wrapper?.closure?(alertView, buttonIndex)
    }
}


private var kTapGuesture = "kTapGuesture"
private var kDismissWhenTouchedWindow = "kDismissWhenTouchedWindow"
extension UIAlertController {
    
    var messageLabel: UILabel? {
        return view.subviews[0].subviews[0].subviews[0].subviews[0].subviews[0].subviews[1] as? UILabel
    }
    
    var dismissWhenTouchedWindow: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &kDismissWhenTouchedWindow) as? Bool else {
                return false
            }
            
            return value
        }
        
        set {
            objc_setAssociatedObject(self, &kDismissWhenTouchedWindow, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var tapGuesture: UITapGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &kTapGuesture) as? UITapGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &kTapGuesture, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        if dismissWhenTouchedWindow {
            tapGuesture = UITapGestureRecognizer(target: self, action: #selector(touchedDissmis(_:)))
            UIApplication.shared.keyWindow?.addGestureRecognizer(tapGuesture!)
        }
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if tapGuesture != nil {
            UIApplication.shared.keyWindow?.removeGestureRecognizer(tapGuesture!)
            tapGuesture = nil
        }
    }
    
    func touchedDissmis(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIViewController
private let ScreenSize = UIScreen.main.bounds.size
private var kOriginLayoutConstraint = "kOriginLayoutConstraint"

extension UIViewController {
    
    func setUpKeyboard(layoutCons: NSLayoutConstraint) {
        let notficaCenter = NotificationCenter.default
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.touchedHiddenKeyBoard))
        
        let value = NSNumber(value: Float(layoutCons.constant))
        objc_setAssociatedObject(self, &kOriginLayoutConstraint, value, .OBJC_ASSOCIATION_RETAIN)
        
        //添加tap手势,收起键盘
        notficaCenter.addObserver(forName: NSNotification.Name.UIKeyboardWillShow,
                                  object: nil,
                                  queue: OperationQueue.main) { notification  in
                                    self.view.addGestureRecognizer(tapGesture)
        }
        
        //移除Tap手势,避免和App中的UIResponder链冲突
        notficaCenter.addObserver(forName: NSNotification.Name.UIKeyboardWillHide,
                                  object: nil,
                                  queue: OperationQueue.main) { notification in
                                    if let oldConstant = objc_getAssociatedObject(self, &kOriginLayoutConstraint) as? NSNumber {
                                        layoutCons.constant = CGFloat(oldConstant.floatValue)
                                        UIView.animate(withDuration: 0.3) {
                                            self.view.layoutIfNeeded()
                                        }
                                    }
                                    self.view.removeGestureRecognizer(tapGesture)
        }
        
        //键盘遮挡处理
        notficaCenter.addObserver(
            forName: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil,
            queue: OperationQueue.main) { (notification) -> Void in
                let usrInfo = notification.userInfo!
                let keyboardRect = (usrInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
                if let respView = self.view.findFirstResponder {
                    
                    let convertRect = self.view.convert(respView.frame, from: respView.superview)
                    let offset = convertRect.origin.y + convertRect.height - keyboardRect!.origin.y
                    
                    if offset > 0 {
                        layoutCons.constant += -offset
                        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded()
                        }
                    }
                }
        }
    }
    
    //取消所有的响应者
    func touchedHiddenKeyBoard() {
        self.view.endEditing(true)
    }
}

extension UIView {
    
    // 渐变背景
    func addGradient(startColor: UIColor, endColor: UIColor) {
        let gradient = CAGradientLayer()
        let startColor = startColor
        let endColor = endColor
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = bounds
        
        layer.insertSublayer(gradient, at: 0)
    }
}

extension String {
    func boundingRect(withFont font: UIFont) -> CGSize {
        let size = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        
        var option = NSStringDrawingOptions.truncatesLastVisibleLine
        option.insert(NSStringDrawingOptions.usesLineFragmentOrigin)
        
        let attributes = [NSFontAttributeName: font]
        
        let rect = boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size
    }
}

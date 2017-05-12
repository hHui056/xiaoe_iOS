//
//  MyFounctionButton.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/9.
//  Copyright © 2017年 何辉. All rights reserved.
//

import UIKit

class MyFounctionButton: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //UIView添加点击效果
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // self.backgroundColor = UIColor.orange
      self.alpha = 0.2
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
            self.backgroundColor = UIColor.clear
            self.alpha = 1.0
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
            self.backgroundColor = UIColor.clear
      
            self.alpha = 1.0
        })
    }
    
    func addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
    }
}

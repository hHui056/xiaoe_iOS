//
//  HhuiButton.swift
//  xiaoe
//
//  Created by 何辉 on 2017/4/27.
//  Copyright © 2017年 何辉. All rights reserved.
//

import UIKit
@IBDesignable class HhuiButton:UIView{
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
 
    @IBOutlet weak var funcdes: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
       super.init(coder: aDecoder)
        initViewFromNib()
    }
    
    
    private func initViewFromNib() {
        // 需要这句代码，不能直接写UINib(nibName: "HhuiButton", bundle: nil)，不然不能在storyboard中显示
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "HhuiButton", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.view.frame = bounds
        self.addSubview(view)
    }
    //设置数据
    public func setData(founctionmode:FounctionMode){
         self.name.text = founctionmode.name
         self.icon.image = founctionmode.icon
         self.funcdes.text = founctionmode.funcdes
    }
    
    
    //UIView添加点击效果
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // self.backgroundColor = UIColor.orange
        self.name.alpha = 0.2
        self.icon.alpha = 0.2
        self.funcdes.alpha = 0.2
        
     
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
            self.backgroundColor = UIColor.clear
            self.name.alpha = 1.0
            self.icon.alpha = 1.0
            self.funcdes.alpha = 1.0
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
            self.backgroundColor = UIColor.clear
            self.name.alpha = 1.0
            self.icon.alpha = 1.0
            self.funcdes.alpha = 1.0
            
        })
    }
    
    func addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
    }
}



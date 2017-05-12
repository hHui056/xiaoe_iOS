//
//  BaseViewController.swift
//  xiaoe
//
//  Created by 何辉 on 2017/4/28.
//  Copyright © 2017年 何辉. All rights reserved.
//

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        //title颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //barbutton 颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white
     
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
       
       
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //弹出窗口提示，1.5 s消失
    private  func showToast(title:String,message:String?){
        let alertController = UIAlertController(title:title,message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }

   
}

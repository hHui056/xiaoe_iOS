//
//  QRCodeSuccess.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/9.
//  Copyright © 2017年 何辉. All rights reserved.
//

import UIKit

class QRCodeSuccess: BaseViewController {
    // - 开发板的appkey
    var device_appkey = ""
    // - 开发板的uid  34位
    var device_uid = ""
    
    var btn_str = SURE_BIND_DEVICE

    @IBOutlet weak var btn_sure: UIButton!
    
    @IBOutlet weak var label_appkey: UILabel!
    
    @IBOutlet weak var label_uid: UILabel!
    
    let defaults = UserDefaults.standard
    
    // - 存储开发板信息到本地
    @IBAction func btn_binddevice() {
        self.defaults.set(device_uid, forKey: DEVICE_ID_KEY)
        self.defaults.set(device_appkey, forKey: APPKEY_KEY)
        if btn_str == SURE_BIND_DEVICE { //跳转到Main storyboard
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let anotherView = (storyboard.instantiateViewController(withIdentifier:"HomeNav"))
            ViewController.isFirstUse = false
            self.present(anotherView, animated: true, completion: {
                
            })
        }else {//跳转到群组管理页面
            let viewCtl : UIViewController = self.navigationController!.viewControllers[1]
            self.navigationController?.popToViewController(viewCtl, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label_appkey.text = device_appkey
        self.label_uid.text = device_uid
        self.btn_sure.setTitle(btn_str, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

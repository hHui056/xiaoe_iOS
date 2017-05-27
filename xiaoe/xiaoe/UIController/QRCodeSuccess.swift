//
//  QRCodeSuccess.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/9.
//  Copyright © 2017年 何辉. All rights reserved.
//
// - 扫描成功，绑定设备

import UIKit
import ETILinkSDK
import SVProgressHUD

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
    
    var mainViewController : ViewController!
    
    // - 存储开发板信息到本地
    @IBAction func btn_binddevice() {
      
        if btn_str == SURE_BIND_DEVICE { //跳转到Main storyboard
            self.defaults.set(device_uid, forKey: DEVICE_ID_KEY)
            self.defaults.set(device_appkey, forKey: APPKEY_KEY)
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
        mainViewController = self.navigationController!.viewControllers[0] as! ViewController //取得ViewContrallor实例
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // - 添加群成员(每次添加一个)
    func addGroupMember(groupId:String,userId:String){
        SVProgressHUD.show(withStatus: "添加中...")
        mainViewController.mAppManager.etManager.addGroupMembers(groupId, userList: [userId]) { (usersInfo, error) in
            if error == nil {//添加成功
                SVProgressHUD.showSuccess(withStatus: "添加成功")
            } else {//添加失败
                SVProgressHUD.showSuccess(withStatus: "添加失败")
            }
        }
    }

}

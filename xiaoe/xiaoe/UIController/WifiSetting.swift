//
//  WifiSetting.swift
//  xiaoe
//
//  Created by 何辉 on 2017/4/27.
//  Copyright © 2017年 何辉. All rights reserved.
//
// - 配置WiFi模块
import UIKit
import SystemConfiguration.CaptiveNetwork
import EspTouch

class WifiSetting: BaseViewController {

    @IBOutlet weak var titleview: UIView!
    
    @IBOutlet weak var inputfiled: UIView!
    
    @IBOutlet weak var wifiname: MyTextFiled!
    
    @IBOutlet weak var startconfig: UIButton!
    
    @IBOutlet weak var wifipassword: MyTextFiled!
   
    
    @IBAction func begainconfig() {
        
        let ssid = wifiname.text ?? ""
        let password = wifipassword.text ?? ""
        
        guard ssid != "" else {
            DDLogWarn("can not commit, ssid or password is empty")
            return
        }
        
        DDLogInfo("committing ssid: \(ssid), password: \(password)")
        
        // commit this
        if !commit(ssid: ssid, bssid: bssid, passwd: password) {
            DDLogWarn("can not commit this configuration. please stop frist!")
            UIAlertView.showAlert(title: "提示", message: "不能进行当前配置，请先停止上次配置！", cancelTitle: "停止", otherTitles: nil) { alert, index in
                if index == 0 {
                    self.cancel()
                }
            }
        } else {
            DDLogInfo("configing...")
        }
        
    }
    
    
    
    var bssid = ""
    
    let reachability = Reachability()!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "配置WiFi"
        // Do any additional setup after loading the view.   
    
        
        configureSubViews()
        
        disableDeployButton()
        
        wifipassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        wifipassword.isSecureTextEntry = true
        
        // 启动监听网络
        do {
            try reachability.startNotifier()
        } catch {
            DDLogError("reachability start notifier error: \(error)")
        }
        
        let defaultCenter = NotificationCenter.default
        
        // 网络状态改变 - 则判断是否 Wi-Fi 可用
        defaultCenter.addObserver(self,
                                  selector: #selector(reachabilityChanged(sender:)),
                                  name: ReachabilityChangedNotification,
                                  object: nil)
        
        // 程序进入前台 - 则重新获取 ssid (以防 Wi-Fi 更换)
        defaultCenter.addObserver(self,
                                  selector: #selector(refreshSsidAndBssid),
                                  name: .UIApplicationWillEnterForeground,
                                  object: nil)
        
        refreshSsidAndBssid()
    }
    
    @objc fileprivate func refreshSsidAndBssid() {
        DDLogInfo("fetch current Wi-Fi ssid")
        guard let ssid = fetchSsid() else {
            DDLogWarn("get ssid is nil")
            return
        }
        
        guard let bssid = fetchBssid() else {
            DDLogWarn("get bssid is nil")
            return
        }
        
        // get password for userdefault
        if let cachedPwd = UserDefaults.standard.string(forKey: ssid) {
            DDLogInfo("get password for userdefault, passowrd: \(cachedPwd), ssid: \(ssid)")
            wifipassword.text = cachedPwd
        } else {
            wifipassword.text = ""
        }
        
        DDLogInfo("refresh ssid&bssid ssid success: \(ssid), \(bssid)")
        wifiname.text = ssid
        self.bssid = bssid
        enableDeployButton()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // inputfiled.backgroundColor = UIColor(patternImage: UIImage(named:"输入背景.png")!)
    }
   
    //点击任意位置键盘弹出
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.wifiname.resignFirstResponder()
        self.wifipassword.resignFirstResponder()
    }
    
    
    func configureSubViews() {
//        // 添加背景渐变色
//        view.addGradient(startColor: UIColor(red: 0.154, green: 0.779, blue: 0.938, alpha: 1),
//                         endColor: UIColor(red: 0.812, green: 0.949, blue: 0.983, alpha: 1))
        
        // 添加 TextFeild 的左边距
        wifiname.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        wifiname.leftViewMode = .always
        
        wifipassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        wifipassword.leftViewMode = .always
        
        // password 右边眼睛
        let checkPasswd = UIButton(frame: CGRect(x: 0, y: 0,width: wifipassword.frameH, height: wifipassword.frameH))
        
        checkPasswd.setImage(UIImage(named: "眼睛"), for: .selected)
        checkPasswd.setImage(UIImage(named: "眼睛"), for: .normal)
        checkPasswd.addTouchUpInside {
            let text = self.wifipassword.text ?? ""
            self.wifipassword.isSecureTextEntry = !self.wifipassword.isSecureTextEntry
            self.wifipassword.text = ""
            self.wifipassword.text = text
            checkPasswd.isSelected = !self.wifipassword.isSecureTextEntry
        }
        wifipassword.rightView = checkPasswd
        wifipassword.rightViewMode = .always
        
        
    }
    func enableDeployButton() {
        startconfig.isEnabled = true
        startconfig.alpha = 1
    }
    func disableDeployButton() {
        startconfig.isEnabled = false
        startconfig.alpha = 0.5
    }
}
// MARK: UI Helper
let netAlertCtlr = UIAlertController(title: "", message: "手机未连接 WiFi", preferredStyle: UIAlertControllerStyle.alert)
// MARK: IBAction
extension WifiSetting {
    
    func textFieldDidChange(_ sender: UITextField) {
        let ssid = wifiname.text
        
        guard ssid != "" else {
            disableDeployButton()
            return
        }
        
        enableDeployButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DDLogInfo("textfield: \(textField.text!), range: \(range.location)-\(range.length), string: \(string)")
        
        // 判定为增加字符串
        guard range.length == 0 && string != "" else {
            return true
        }
        
        let password = textField.text ?? ""
        if password.lengthOfBytes(using: String.Encoding.utf8) > 64 {
            DDLogInfo("passwrod can not more than 64 bytes")
            return false
        }
        
        return true
    }
    

    func reachabilityChanged(sender: Notification) {
        let reachability = sender.object as! Reachability
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            if reachability.isReachable {
                if reachability.isReachableViaWiFi {
                   netAlertCtlr.dismissWhenTouchedWindow = false
                    netAlertCtlr.dismiss(animated: true, completion: nil)
                    weakSelf.refreshSsidAndBssid()
                } else {
                    netAlertCtlr.dismissWhenTouchedWindow = true
                    weakSelf.present(netAlertCtlr, animated: true, completion: nil)
                    weakSelf.disableDeployButton()
                }
            } else {
                netAlertCtlr.dismissWhenTouchedWindow = true
                weakSelf.present(netAlertCtlr, animated: true, completion: nil)
                weakSelf.disableDeployButton()
            }
        }
    }
}
// MARK: Wi-Fi Helper
extension WifiSetting {
    
    /// 获取当前 Wi-Fi 网络的 SSID
    func fetchSsid() -> String? {
        if let info = fetchNetInfo() {
            if let ssid = info[kCNNetworkInfoKeySSID] as? String {
                return ssid
            }
        }
        return nil
    }
    
    /// 获取当前 Wi-Fi 网络的 BSSID
    func fetchBssid() -> String? {
        if let info = fetchNetInfo() {
            if let bssid = info[kCNNetworkInfoKeyBSSID] as? String {
                return bssid
            }
        }
        return nil
    }
    
    private func fetchNetInfo() -> NSDictionary? {
        if let interfaces = CNCopySupportedInterfaces() as? Array<String> {
            for s in interfaces {
                let int: CFString = s as NSString
                if let ssidInfo = CNCopyCurrentNetworkInfo(int) {
                    return ssidInfo
                }
            }
        }
        return nil
    }
}



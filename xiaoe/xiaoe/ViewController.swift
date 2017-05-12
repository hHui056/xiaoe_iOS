//
//  ViewController.swift
//  xiaoe
//
//  Created by 何辉 on 2017/4/26.
//  Copyright © 2017年 何辉. All rights reserved.
//

import UIKit
import AdSupport
import ETILinkSDK
import SVProgressHUD

class ViewController: BaseViewController {
    
      var mAppManager: AppManager!
    
     var isConnectedServer = false //当前手机用户是否连接上服务器
    
     var isDeviceOnline = false //设备是否在线
    
     var PhoneUid : String = ""
    
     let defaults = UserDefaults.standard
    
    
     var DeviceUid = ""
    
     public static  var isFirstUse = false
    
     override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        
        if defaults.string(forKey: USER_ID_KEY) == nil{
            addUser()
        }else{
             PhoneUid = defaults.string(forKey: USER_ID_KEY)!
        }
        if !ViewController.isFirstUse {
           addMainViewController()
        }else{
           addFristViewController()
        }   
    }
    // - 不是第一次使用，加载主页面
    func addMainViewController(){
        DeviceUid = defaults.string(forKey: DEVICE_ID_KEY)!
        initData()
        mAppManager = AppManager(uid: self.PhoneUid)
        
        mAppManager.delegate = self
        mAppManager.discover()
        SVProgressHUD.show(withStatus: "连接中...")
    }
    // - 第一次使用，加载绑定设备页面
    func addFristViewController(){
        
        tishi_text.text = 步骤描述
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            //连接成功 ------> 获取设备状态
            if isConnectedServer {
                self.getDeviceState()
            }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //设置wifi
    @IBAction func toSettingWifi() {
        let storyboard = UIStoryboard(name: "WifiSetting", bundle: nil)
        
        let anotherView = (storyboard.instantiateViewController(withIdentifier:"wifiset"))
        
        self.navigationController?.pushViewController(anotherView, animated:true)
     
    }
    
    @IBOutlet weak var tishi_text: UITextView!
    
    @IBAction func fist_toSettingWifi() {
        
        let storyboard = UIStoryboard(name: "WifiSetting", bundle: nil)
        
        let anotherView = (storyboard.instantiateViewController(withIdentifier:"wifiset"))
        
        self.navigationController?.pushViewController(anotherView, animated:true)
    }
    // - 前往二维码扫描绑定设备界面
    @IBAction func bindDevice() {
        let  scanner = ScannerViewController()
        scanner.WhereFrom = FIRST_BIND_DEVICE
        scanner.delegate = self
        self.navigationController?.pushViewController(scanner, animated: true)
    }
    @IBOutlet weak var bangdingshebei: UIImageView!
    //设备状态
    @IBOutlet weak var deviceStatus: UILabel!
    
    @IBOutlet weak var wendu: MyFounctionButton!   

    @IBOutlet weak var keshijiaohu: MyFounctionButton!
    
    @IBOutlet weak var daqiya: MyFounctionButton!
    
    @IBOutlet weak var duocaidengguang: MyFounctionButton!
    
    @IBOutlet weak var shujutouchuan: MyFounctionButton!
 
    @IBOutlet weak var yuyinkongzhi: MyFounctionButton!
    
    @IBOutlet weak var yuyinliuyan: MyFounctionButton!
   
    @IBOutlet weak var qunzhuguanli: MyFounctionButton!
    
    //初始化显示数据
    func initData(){
        
        self.wendu.addOnClickListener(target: self, action: #selector(querytemperature))
        self.daqiya.addOnClickListener(target: self, action: #selector(queryatmos))
        self.keshijiaohu.addOnClickListener(target: self, action: #selector(goKeShiJiaoHu))
        self.yuyinkongzhi.addOnClickListener(target: self, action: #selector(goYuYinKongZhi))
        self.duocaidengguang.addOnClickListener(target: self, action: #selector(contralLight))
        self.yuyinliuyan.addOnClickListener(target: self, action: #selector(goYuYinLiuYan))
        self.qunzhuguanli.addOnClickListener(target: self, action: #selector(goQunZuGuanLi))
        
    }
    //查询温湿度
    func querytemperature(){
        if !isDeviceOnline {
            SVProgressHUD.showError(withStatus: "开发板不在线")
            return
        }
        SVProgressHUD.show(withStatus: "查询中...")
        let instruction = Instruction.Builder().setCmd(cmd: Instruction.Cmd.QUERY).setBody(body: TemperatureAndHumidityReqBody(data1:Instruction.RequestType.BOTH)).createInstruction()
        
        let message = ETMessage(bytes : instruction!.toByteArray())
        
        
        mAppManager.etManager.chatTo(DeviceUid, message: message) { (error) in
            guard error == nil else {
                SVProgressHUD.showError(withStatus: "查询失败！")
                return
            }
            
            print("chatto [\(self.DeviceUid)], content: \(message) ")
        }
        
        
        //8s无查询回复则消失提示框
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 8) {
            if SVProgressHUD.isVisible(){
                SVProgressHUD.showError(withStatus: "查询失败")
            }
        }
    }
    //多彩灯光
    func contralLight(){
        SVProgressHUD.show(withStatus: "查询中...")
        let instruction = Instruction.Builder().setCmd(cmd: Instruction.Cmd.CONTROL).setBody(body: LEDControllerReqBody(content:"这是中文")).createInstruction()
        
        let message = ETMessage(bytes : instruction!.toByteArray())
        print("发送的byte是: \(instruction!.toByteArray())")
        mAppManager.etManager.chatTo(DeviceUid, message: message) { (error) in
            guard error == nil else {
                print("chatto error \(error!)")
                return
            }
            print("chatto [\(self.DeviceUid)], content: \(message) ")
        }
    }
    //查询大气压
    func queryatmos(){
        if !isDeviceOnline {
            SVProgressHUD.showError(withStatus: "开发板不在线")
            return
        }
        SVProgressHUD.show(withStatus: "查询中...")
        
        let instruction = Instruction.Builder().setCmd(cmd: Instruction.Cmd.QUERY).setBody(body: AirReqBody(data1:Instruction.RequestType.AIR)).createInstruction()
        
        let message = ETMessage(bytes : instruction!.toByteArray())
        
        
        mAppManager.etManager.chatTo(DeviceUid, message: message) { (error) in
            guard error == nil else {
                SVProgressHUD.showError(withStatus: "查询失败！")
                return
            }
            
            print("chatto [\(self.DeviceUid)], content: \(message) ")
        }
        //8s无查询回复则消失提示框
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 8) {
            if SVProgressHUD.isVisible(){
                SVProgressHUD.showError(withStatus: "查询失败")
            }
        }
     
    }
    //跳转到可视交互
    func goKeShiJiaoHu(){
        if !isDeviceOnline {
            SVProgressHUD.showError(withStatus: "开发板不在线")
            return
        }
         jumpToOtherStoryboard(name: "VisualInteractive", id: "keshijiaohu")
    }
    //跳转到语音控制
    func goYuYinKongZhi(){
        if !isDeviceOnline {
            SVProgressHUD.showError(withStatus: "开发板不在线")
            return
        }
        
         jumpToOtherStoryboard(name: "VoiceControl", id: "Voicecontrol")
    }
    //跳转到语音留言
    func goYuYinLiuYan(){
        showToast(title: "语音留言")
    }
    //跳转到群组管理
    func goQunZuGuanLi(){
        jumpToOtherStoryboard(name: "GroupManager", id: "groupmanager")
    }
    func showDialog(data:String){
        let alertController:UIAlertController = UIAlertController(title: nil, message: data, preferredStyle:  UIAlertControllerStyle.alert)
        let maction = UIAlertAction(title: "确   认", style: UIAlertActionStyle.default, handler: {(alertAction)-> Void in
            
          //  NSLog("点击了 确认")
        })
        alertController.addAction(maction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //弹出窗口提示，1.5 s消失
    func showToast(title:String){
        let alertController = UIAlertController(title:title,message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
       // ToastView.showInfo(info: title, bgColor: UIColor.white, inView: self.view, vertical: 0.9)
    }
  // - 跳转到另一个storyboard
    func jumpToOtherStoryboard(name:String,id:String)  {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        let anotherView = (storyboard.instantiateViewController(withIdentifier:id))
        
        self.navigationController?.pushViewController(anotherView, animated:true)
    }
    
    // - 通过设备UUID注册唯一Uid
    func addUser(){
        let adId : String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let musername = adId.components(separatedBy: "-")[0]
        ETILink.addUser(withAppKey: APPKEY, secretKey: SECRETKEY, host: SERVER_HOST, port: 8085, username: musername, nickname: musername){ (user, error) -> Void in
            if error == nil {
                // user 为 `ETUser` 实例
                // 里面包含 `userID` `userName` `nickName` 属性
                print("add user successful. user: \(user!)")
                // - 注册成功保存userID
                self.PhoneUid = user!.userID
                self.defaults.set(user!.userID, forKey: USER_ID_KEY)
                
            } else {
                print("add user failed! \(error!)")
            }
        }
    }
    // - 获取设备连接状态
    func getDeviceState(){
        mAppManager.getDeviceState(uid: self.DeviceUid)
    }
    // - 订阅设备状态
    func subDeviceState(){
        mAppManager.etManager.subUserState("Fc5wGsTuvumvyVvy6Xf4ydxUWodXYLaXec"){(error) in
            if error == nil{
                print("订阅状态成功")
            }else{
                print("订阅状态失败")
            }
            
        }
    }
    func showLog(_ data:String){
        NSLog(data)
    }
}

extension ViewController:HeHuiDelegete{
        func onMessage(type: ETMessageType, topic: String?, sender: String?, message: ETReceiveMessage) {
       
        SVProgressHUD.dismiss()
        print("bytes是：  \(message.bytes)")
        let instruction = InstructionParser().parseInstruction(content : message.bytes)
            if instruction == nil {
                print("查询失败，请确认档位和跳线帽都正确再试")
                showDialog(data: "查询失败,请确认档位和跳线帽都正确后再试")
                return
            }
            if instruction!.getBody() is TemperatureAndHumidityResBody {
                let tempbody = instruction!.getBody() as! TemperatureAndHumidityResBody
                let showstr = "温度 (℃)  \(tempbody.tempeInt).\(tempbody.tempeDec)℃\n\n湿度 (RH) \(tempbody.humInt).\(tempbody.hunDec)%"
                showDialog(data: showstr)
            }else if instruction!.getBody() is AirResBody {
                let airbody = instruction!.getBody() as! AirResBody
                let showstr = "大气压 (Pa) \(airbody.air) \n\n海拔 (m) \(airbody.high)"
                showDialog(data: showstr)
            }
    }
    func onBroken(server: ETServer, error: NSError?) {
        self.isConnectedServer = false
        // reconnect 逻辑
        // 在除自己主动断开, 或异地登录的情形下, 断开后, 直接尝试重新连接
        if let error = error, error.code != ETErrorCode.loginElseWhere.rawValue {
            print("will reconnect to server")
            // 每 10s 进行一次重连服务器, 直到连接成功
            mAppManager.etManager.reconnect(interval: 10) { (times, success, error) -> Bool in
                guard success else {
                    print("auto reconnect failed, error: \(error!)")
                    return true
                }
                print("auto reconnect success!")
                self.isConnectedServer = true
                //重连成功----->重新获取设备状态
                self.getDeviceState()
                return true
            }
        }
    }
    
    func onServer(server: ETServer) {
       mAppManager.connect(mserver:server){ (server, error) in
        
            guard error == nil else {
                SVProgressHUD.showError(withStatus: "连接失败")
                print("connect error \(error!)")
                return
            }
            print("connected \((server?.host)!)")
            self.isConnectedServer = true
            SVProgressHUD.showSuccess(withStatus: "连接成功")
            self.getDeviceState()
        }
        
    }
    func onFileRecved(senderUid: String, fileInfo: ETFileInfo) {
    
        
    }
    // - 用户状态回调
    func onUserState(userID:String,state:Bool,error:NSError?){
        if error == nil {
            if state {
                self.isDeviceOnline = true
                self.deviceStatus.text = "设备在线"
            }else{
                self.isDeviceOnline = false
                self.deviceStatus.text = "设备离线"
            }
        }
        print("user : \(userID) state : \(state)")
    }
}
extension ViewController:MessageDelegete{
    func sendMessage(message: String) {
        print("扫描结果是 \(message)")
    }
}

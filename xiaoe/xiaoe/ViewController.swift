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
    
     public static  var isFirstUse = false //是否第一次使用app
    
     public static  var isResponse = true  //此页面是否需要处理onmessage收到的消息
    
     var leddelegate : LEDReceiveDelegete?
    
     var messagereceiveddelegate : MessageReceiveDelegete?
    
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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            if SVProgressHUD.isVisible() && !self.isConnectedServer{
                SVProgressHUD.showError(withStatus: "连接失败，请检查网络。")
            }
        }
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
        ViewController.isResponse = true //显示是设置需要处理收到的消息
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //设置wifi
    @IBAction func toSettingWifi() {
        if SVProgressHUD.isVisible() {
            return
        }
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
        if SVProgressHUD.isVisible() {
            return
        }
        let  scanner = ScannerViewController()
        scanner.WhereFrom = FIRST_BIND_DEVICE
        scanner.delegate = self
        self.navigationController?.pushViewController(scanner, animated: true)
    }

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
        self.shujutouchuan.addOnClickListener(target: self, action: #selector(GotoDataTransfer))
        
    }
    // - 跳转到数据透传
    func GotoDataTransfer(){
        ShowInputUidDialog()
      //  jumpToOtherStoryboard(name: "DataTransfer", id: "datatrans")
    }
    
    //查询温湿度
    func querytemperature(){
        if SVProgressHUD.isVisible() {
            return
        }
        if !isConnectedServer{
            showDialog(data: "与服务器未连接，不能使用此功能")
            return
        }
        if !isDeviceOnline {
            showDialog(data: "设备不在线")
            return
        }
        SVProgressHUD.show(withStatus: "查询中...")
        let instruction = Instruction.Builder().setCmd(cmd: Instruction.Cmd.QUERY).setBody(body: TemperatureAndHumidityReqBody(data1:Instruction.RequestType.BOTH)).createInstruction()
        
        let message = ETMessage(bytes : instruction!.toByteArray())
        
        
        mAppManager.etManager.chatTo(DeviceUid, message: message) { (error) in
            guard error == nil else {
                SVProgressHUD.showError(withStatus: "查询失败")
                return
            }
            
            print("chatto [\(self.DeviceUid)], content: \(message) ")
        }
        //15s无查询回复则消失提示框
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
            if SVProgressHUD.isVisible(){
                SVProgressHUD.showError(withStatus: "查询失败")
            }
        }
    }
    //多彩灯光
    func contralLight(){
        if SVProgressHUD.isVisible() {
            return
        }
        if !isConnectedServer{
            showDialog(data: "与服务器未连接，不能使用此功能")
            return
        }
        if !isDeviceOnline {
            showDialog(data: "设备不在线")
            return
        }
        showControlLightDialog()
    }
    //查询大气压
    func queryatmos(){
        if SVProgressHUD.isVisible() {
            return
        }
        if !isConnectedServer{
            showDialog(data: "与服务器未连接，不能使用此功能")
            return
        }
        if !isDeviceOnline {
            showDialog(data: "设备不在线")
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
        //15s无查询回复则消失提示框
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
            if SVProgressHUD.isVisible(){
                SVProgressHUD.showError(withStatus: "查询失败")
            }
        }
     
    }
    //跳转到可视交互
    func goKeShiJiaoHu(){
        if SVProgressHUD.isVisible() {
            return
        }
        if !isConnectedServer{
            showDialog(data: "与服务器未连接，不能使用此功能")
            return
        }
        if !isDeviceOnline {
            showDialog(data: "设备不在线")
            return
        }
        
         jumpToOtherStoryboard(name: "VisualInteractive", id: "keshijiaohu")
    }
    //跳转到语音控制
    func goYuYinKongZhi(){
        if SVProgressHUD.isVisible() {
            return
        }
        if !isConnectedServer{
            showDialog(data: "与服务器未连接，不能使用此功能")
            return
        }
        if !isDeviceOnline {
            showDialog(data: "设备不在线")
            return
        }
        
        let storyboard = UIStoryboard(name: "VoiceControl", bundle: nil)
        
        let voice = (storyboard.instantiateViewController(withIdentifier:"Voicecontrol")) as! VoiceControl
        voice.WhoAmI = VOICE_CONTROL
        self.navigationController?.pushViewController(voice, animated:true)
    }
    //跳转到语音留言
    func goYuYinLiuYan(){
        if SVProgressHUD.isVisible() {
            return
        }
        if !isConnectedServer{
            showDialog(data: "与服务器未连接，不能使用此功能")
            return
        }
        if !isDeviceOnline {
            showDialog(data: "设备不在线")
            return
        }
        
        let storyboard = UIStoryboard(name: "VoiceControl", bundle: nil)
        
        let voice = (storyboard.instantiateViewController(withIdentifier:"Voicecontrol")) as! VoiceControl
        voice.WhoAmI = LEAVE_MESSAGE
        self.navigationController?.pushViewController(voice, animated:true)
    }
    //跳转到群组管理
    func goQunZuGuanLi(){
        if SVProgressHUD.isVisible() {
            return
        }
        if !isConnectedServer{
            showDialog(data: "与服务器未连接，不能使用此功能")
            return
        }
        if !isDeviceOnline {
            showDialog(data: "设备不在线")
            return
        }
        
        jumpToOtherStoryboard(name: "GroupManager", id: "groupmanager")
    }
    func showDialog(data:String){
        if !ViewController.isResponse { //此页面不需要响应----->其他页面处理
            return
        }
        let alertController:UIAlertController = UIAlertController(title: nil, message: data, preferredStyle:  UIAlertControllerStyle.alert)
        let maction = UIAlertAction(title: "确  认", style: UIAlertActionStyle.default, handler: {(alertAction)-> Void in
            
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
    let emptyView = UIView()
    let LightControlView = UIView()
    let MypieChartView = PieChartView()
    let choicelightlabel = UILabel()
    let backHome = UIButton()
    let slideView = UIView()
  
    //显示控制灯光弹窗
    func showControlLightDialog(){
        // 定义灯光控制视图的位置和大小
        let originLightControl = CGPoint(x: 0.026 * self.view.frame.width, y: 0.139 * self.view.frame.height)
        let sizeLightControl = CGSize(width: 0.948 * self.view.frame.width, height: 0.643 * self.view.frame.height)
        LightControlView.frame = CGRect(origin: originLightControl, size: sizeLightControl)
        LightControlView.backgroundColor = UIColor.white
        LightControlView.layer.cornerRadius = 11.0  //为view设置圆角
        
        // - 定义饼状图的大小
        let piemargin = CGPoint(x: 0.103 * self.view.frame.width, y: 0.048 * self.view.frame.height)
        let piesize = CGSize(width: 0.733 * self.view.frame.width, height: 0.41 * self.view.frame.height)
        MypieChartView.frame = CGRect(origin:piemargin,size:piesize)
        
        // - 定义《选择灯光颜色》label大小、位置、文字颜色
        let labelmargin = CGPoint(x: 0.375 * self.view.frame.width, y: 0.505 * self.view.frame.height)
        let labelsize = CGSize(width: 0.246 * self.view.frame.width, height: 0.03 * self.view.frame.height)
        choicelightlabel.text = "选择灯光颜色"
        choicelightlabel.textColor = UIColor(red:163/255,green:163/255,blue:163/255,alpha:1.0)
        choicelightlabel.font = UIFont(name:"Zapfino", size:13)
        choicelightlabel.frame = CGRect(origin:labelmargin,size:labelsize)
        
        // - 添加分割线
        let slidemargin = CGPoint(x: 0, y: 0.562 * self.view.frame.height)
        let slidesize = CGSize(width: LightControlView.frame.width, height: 1.0)
        slideView.backgroundColor = UIColor(red:204/255,green:204/255,blue:204/255,alpha:1.0)
        slideView.frame = CGRect(origin:slidemargin,size:slidesize)
        
        // - 定义《返回首页》Button大小、位置、文字颜色、点击事件
        let buttonmargin = CGPoint(x: 0, y: 0.563 * self.view.frame.height)
        let buttonsize = CGSize(width: LightControlView.frame.width, height: 0.0814 * self.view.frame.height)
        backHome.setTitle("返回首页", for: .normal)
        backHome.setTitleColor(UIColor(red:255/255,green:153/255,blue:0,alpha:1.0), for: .normal)
        backHome.frame = CGRect(origin:buttonmargin,size:buttonsize)
        backHome.addTarget(self, action: #selector(dismissLightControl), for: .touchUpInside)
       
        // 设置空视图的大小，背景，打开交互，添加手势
        emptyView.frame = self.view.frame
        emptyView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        emptyView.isUserInteractionEnabled = true
        
        //初始化灯光显示数据
        setTestData(piechart:MypieChartView)
        
        LightControlView.addSubview(MypieChartView)
        LightControlView.addSubview(choicelightlabel)
        LightControlView.addSubview(slideView)
        LightControlView.addSubview(backHome)
        emptyView.addSubview(LightControlView)
        self.view.addSubview(emptyView)
        
    }
    // 移除灯光控制视图
    func dismissLightControl() {
        slideView.removeFromSuperview()
        backHome.removeFromSuperview()
        choicelightlabel.removeFromSuperview()
        MypieChartView.removeFromSuperview()
        LightControlView.removeFromSuperview()
        emptyView.removeFromSuperview()
    }
    
    func showLog(_ data:String){
        NSLog(data)
    }
    
    
    func setTestData(piechart:PieChartView){
        piechart.delegate = self  //设置代理，处理灯光选择事件
        var yValues = [PieChartDataEntry]()
        // 最好从0 开始. 否则第一个将失去点击效果, 并出现bug...
        for i in 0...11 {
            // 占比数据
            yValues.append(PieChartDataEntry(value:1.0,label:LIGHT_COLORS[i]))
        }
        let dataSet: PieChartDataSet = PieChartDataSet.init(values: yValues, label: "");
        // - 扇形间间隙
        dataSet.sliceSpace = 3.0
        // - 定义灯光颜色数据
        var colors = [UIColor]()
        colors.append(UIColor (red: 230/255, green: 29/255, blue: 190/255, alpha: 1.0 ))
        colors.append(UIColor (red: 250/255, green: 40/255, blue: 11/255, alpha: 1.0 ))
        colors.append(UIColor (red: 255/255, green: 126/255, blue: 0/255, alpha: 1.0 ))
        colors.append(UIColor (red: 255/255, green: 195/255, blue: 13/255, alpha: 1.0 ))
        colors.append(UIColor (red: 254/255, green: 255/255, blue: 51/255, alpha: 1.0 ))
        colors.append(UIColor (red: 200/255, green: 253/255, blue: 58/255, alpha: 1.0 ))
        colors.append(UIColor (red: 114/255, green: 244/255, blue: 36/255, alpha: 1.0 ))
        colors.append(UIColor (red: 0/255, green: 209/255, blue: 103/255, alpha: 1.0 ))
        colors.append(UIColor (red: 2/255, green: 198/255, blue: 227/255, alpha: 1.0 ))
        colors.append(UIColor (red: 5/255, green: 118/255, blue: 247/255, alpha: 1.0 ))
        colors.append(UIColor (red: 65/255, green: 0/255, blue: 251/255, alpha: 1.0 ))
        colors.append(UIColor (red: 150/255, green: 0/255, blue: 255/255, alpha: 1.0 ))
        dataSet.colors = colors
        
        dataSet.selectionShift = 12 //选中扇形半径
        dataSet.valueLinePart1OffsetPercentage = 0.0
        dataSet.valueLinePart1Length = 0.0
        dataSet.valueLinePart2Length = 0.0
        dataSet.yValuePosition = .insideSlice
        let data = PieChartData(dataSet: dataSet)
        // - 这里还没弄明白，暂设文字描述为透明色不显示（解决内部会显示百分比数字问题）
        data.setValueTextColor(UIColor.clear)
        
        piechart.legend.enabled = false // 不显示下方说明
        piechart.data = data
        
        
    }
    
    // - 提示输入透传板的UID
    func ShowInputUidDialog() {
        var usernameTextField: UITextField?
       
        let alertController = UIAlertController(title: "提示",message: "请输入透传板的uid",preferredStyle: UIAlertControllerStyle.alert)
        
        let loginAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
            (action) -> Void in
            
            if let username = usernameTextField?.text {
                if username == "" {
                    print("什么也没输入")
                }else{
                    print("输入的是：\(username)")
                    let pattern = "^[0-9A-Za-z]+$"
                    let macher = MyRegex(pattern)
                    if macher.match(input: username) && username.characters.count == 34{//满足uid条件
                      //  self.defaults.set(username, forKey: TOUCHUANBAN_UID_KEY)
                        
                        
                        self.mAppManager.etManager.subscribe(self.DeviceUid + "&TX"){(error) in
                            
                            if error == nil{
                                print("订阅 \(self.DeviceUid)&TX 成功")
                                
                                // - 跳转到数据透传页面
                                let storyboard = UIStoryboard(name: "DataTransfer", bundle: nil)
                                let DataTransferView = (storyboard.instantiateViewController(withIdentifier:"datatrans")) as! DataTransfer
                                DataTransferView.TouChuanBanUid = username
                                self.navigationController?.pushViewController(DataTransferView, animated:true)
                            }else{
                                print("订阅 \(self.DeviceUid)&TX 失败")
                            }
                            
                        }                        
                        
                    }else{
                        self.showDialog(data: "输入的Uid有误")
                    }
                }
            } else {
                print("什么也没输入")
            }
        }
        alertController.addTextField {
            (txtUsername) -> Void in
            usernameTextField = txtUsername
            usernameTextField!.placeholder = "输入uid"
        }
        usernameTextField?.text = DeviceUid
        //设置uid为之前保存过的uid
//        if  defaults.string(forKey: DEVICE_ID_KEY) != nil {
//            let ss =  defaults.string(forKey: TOUCHUANBAN_UID_KEY)
//            usernameTextField?.text = ss
//        }
        alertController.addAction(loginAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController:HeHuiDelegete{
        func onMessage(type: ETMessageType, topic: String?, sender: String?, message: ETReceiveMessage) {
        SVProgressHUD.dismiss()
        let receive = String(bytes: message.bytes, encoding: String.Encoding.utf8)
            
        print("收到消息:  from: \(String(describing: topic))  message: \(String(describing: receive))")
        self.messagereceiveddelegate?.onMessageReceived(topic: topic, message: message)
        
        if topic != nil{
                return
            }
        if sender! != self.DeviceUid {//不是绑定设备回复的消息不处理
                return
            }
        let instruction = InstructionParser().parseInstruction(content : message.bytes)
            if instruction == nil {
                print("查询失败，请确认档位和跳线帽都正确再试")
                showDialog(data: "操作失败,请确认档位和跳线帽都正确后再试")
                return
            }
            let ResBody = instruction!.getBody()
            if ResBody is TemperatureAndHumidityResBody {//温湿度查询反馈
                let tempbody = ResBody as! TemperatureAndHumidityResBody
                let showstr = "温度 (℃)  \(tempbody.tempeInt).\(tempbody.tempeDec)℃\n\n湿度 (RH) \(tempbody.humInt).\(tempbody.hunDec)%"
                self.leddelegate?.onQueryReceive(body: tempbody)
                showDialog(data: showstr)
            }else if ResBody is AirResBody {//大气压查询反馈
                let airbody = ResBody as! AirResBody
                let showstr = "大气压 (Pa) \(airbody.air) \n\n海拔 (m) \(airbody.high)"
                self.leddelegate?.onQueryReceive(body: airbody)
                showDialog(data: showstr)
            }else if ResBody is RGBControllerResBody {//RGB灯光控制反馈
                let rgbbody = ResBody as! RGBControllerResBody
                if !rgbbody.isSuccess {
                    showDialog(data: "控制灯光失败！")
                }
                self.leddelegate?.onQueryReceive(body: rgbbody)
            }else if ResBody is LEDControllerResBody {
                let ledbody = ResBody as! LEDControllerResBody
                self.leddelegate?.onLEDReceive(body: ledbody)
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
            if userID == self.DeviceUid {
                if  state {
                    self.isDeviceOnline = true
                    self.deviceStatus.text = "设备在线"
                }else{
                    self.isDeviceOnline = false
                    self.deviceStatus.text = "设备离线"
                }
            }
           
        }
        print("user : \(userID) state : \(state)")
    }
}

extension ViewController:MessageDelegete,ChartViewDelegate{
    func sendMessage(message: String) {
        print("扫描结果是 \(message)")
    }
    // - 选择了灯光颜色后回调
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let pieentry = entry as! PieChartDataEntry
        print("piechartView中选中的是 \(pieentry.label!)")
        
        let instruction = Instruction.Builder().setCmd(cmd: Instruction.Cmd.CONTROL).setBody(body: RGBControllerReqBody(color:pieentry.label!)).createInstruction()
        
        let message = ETMessage(bytes : instruction!.toByteArray())
        
        
        mAppManager.etManager.chatTo(DeviceUid, message: message) { (error) in
            guard error == nil else {
                SVProgressHUD.showError(withStatus: "查询失败！")
                return
            }
          
            print("chatto [\(self.DeviceUid)], content: \(message) ")
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
}

protocol LEDReceiveDelegete {
    func onLEDReceive(body:LEDControllerResBody)
    func onQueryReceive(body:Body)
}
protocol MessageReceiveDelegete {
    func onMessageReceived(topic:String?,message:ETReceiveMessage)
}

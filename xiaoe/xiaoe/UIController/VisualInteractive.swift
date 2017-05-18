//
//  VisualInteractive.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/2.
//  Copyright © 2017年 何辉. All rights reserved.
//
import Foundation
import UIKit
import ETILinkSDK
import SVProgressHUD
class VisualInteractive: BaseViewController , ChatDataSource , UITextFieldDelegate , LEDReceiveDelegete {
    
    let CELL_MESSAGE = "CELL_SHOW_MESSAGE"
    
    var Chats:NSMutableArray!
    
    var tableView:TableView!
    
    @IBOutlet weak var BottomView: UIView!
    
    @IBOutlet weak var bottomviewmargin: NSLayoutConstraint!
    
    @IBOutlet weak var input: UITextField!
    
    @IBOutlet weak var topview: UIView!
    
    @IBOutlet weak var ParentView: UIView!
    
    var mainViewController : ViewController!
    
    var me:UserInfo!
    
    var you:UserInfo!
    
    let defaults = UserDefaults.standard
    
    var DeviceUid = "" //设备ID
    
    @IBAction func sendMessage() {
        chatToLed()
        self.input.resignFirstResponder()
        input.text = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "可视交互"
        
        DeviceUid = defaults.string(forKey: DEVICE_ID_KEY)!
        input.returnKeyType = UIReturnKeyType.send
        self.input.delegate = self
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillChange(_:)),name: .UIKeyboardWillChangeFrame, object: nil)
        
        Chats = NSMutableArray()
        mainViewController = self.navigationController!.viewControllers[0] as! ViewController //取得ViewContrallor实例（使用appManage对象）
        mainViewController.leddelegate = self
        setupChatTable()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatToLed()
        input.text = ""
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //收到led显示控制反馈
    func onLEDReceive(body: LEDControllerResBody) {
        if body.isSuccess {//控制成功
            let msg = MessageItem(body:"控制成功",user:you, date:Date(timeIntervalSinceNow:0), mtype:.someone)
            Chats.add(msg)
            self.tableView.reloadData()
        }else{//控制失败
            let msg = MessageItem(body:"控制失败",user:you, date:Date(timeIntervalSinceNow:0), mtype:.someone)
            Chats.add(msg)
            self.tableView.reloadData()
        }
    }
    //收到查询信息--->不处理
    func onQueryReceive(body: Body) {
        
        
    }
    //点击任意位置键盘弹出
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.input.resignFirstResponder()
    }
    
    
    // 键盘改变
    func keyboardWillChange(_ notification: Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            self.view.layoutIfNeeded()
            //改变下约束
            self.bottomviewmargin.constant = intersection.height + 5
            UIView.animate(withDuration: duration, delay: 0.0,options: UIViewAnimationOptions(rawValue: curve), animations: {
                _ in
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    func setupChatTable()
    {
        self.view.bringSubview(toFront: BottomView) //将输入框移到最上层，避免被其他视图遮住
        self.tableView = TableView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:self.ParentView.frame.height - BottomView.frame.height - 10), style: .plain)
        //创建一个重用的单元格
        self.tableView!.register(TableViewCell.self, forCellReuseIdentifier: "ChatCell")
        me = UserInfo(name:"Xiaoming" ,logo:("头像_设备.png"))
        you  = UserInfo(name:"Xiaohua", logo:("头像_设备.png"))
        //   let second =  MessageItem(image:UIImage(named:"sz.png")!,user:me, date:Date(timeIntervalSinceNow:-90000290), mtype:.mine)
        let fouth =  MessageItem(body:"请先确定开发板处于1档位且跳线帽插入正确，再发送消息!",user:me, date:Date(timeIntervalSinceNow:0), mtype:.mine)
        
        Chats.add(fouth)
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        self.ParentView.addSubview(self.tableView)
    }
    
    func rowsForChatTable(_ tableView:TableView) -> Int
    {
        return self.Chats.count
    }
    
    func chatTableView(_ tableView:TableView, dataForRow row:Int) -> MessageItem
    {
        print("这是第\(row)")
        return Chats[row] as! MessageItem
    }
    //发送消息到LED屏显示
    func chatToLed(){
        if input.text == "" {//输入为空
            return
        }
        if !isChinese(string: input.text!){
            showDialog(data: "只能输入中文！")
            return
        }
        let msg = MessageItem(body:input.text! as NSString,user:me, date:Date(timeIntervalSinceNow:0), mtype:.mine)
        Chats.add(msg)
        self.tableView.reloadData()
        sendMessageToLED(message: input.text!)
        self.input.resignFirstResponder()
    }
    // - 提示弹窗
    func showDialog(data:String){
        let alertController:UIAlertController = UIAlertController(title: nil, message: data, preferredStyle:  UIAlertControllerStyle.alert)
        let maction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: {(alertAction)-> Void in
            
            
        })
        alertController.addAction(maction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendMessageToLED(message:String){
        let instruction = Instruction.Builder().setCmd(cmd: Instruction.Cmd.CONTROL).setBody(body:LEDControllerReqBody(content:message)).createInstruction()
        
        let message = ETMessage(bytes : instruction!.toByteArray())
        
        
        mainViewController.mAppManager.etManager.chatTo(self.DeviceUid, message: message) { (error) in
            guard error == nil else {
                SVProgressHUD.showError(withStatus: "查询失败！")
                return
            }
            
            print("chatto [device], content: \(message) ")
        }
    }
    
    // - 检验是否全为中文(只支持中文GB2321编码)
    func isChinese(string: String) -> Bool {
        
        for (_, value) in string.characters.enumerated() {
            
            if ("\u{4E00}" > value  || value > "\u{9FA5}") {//含有非中文字符
                return false
            }
        }
        return true
    }

}





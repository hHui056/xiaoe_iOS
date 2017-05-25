//
//  DataTransfer.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/19.
//  Copyright © 2017年 何辉. All rights reserved.
/*
 热河路就像80年代的金坛县，梧桐 垃圾 灰尘 和各式各样的杂货店~
 人们总是早早的离开，拉上卷帘门，在天黑前穿上衣服，点一根烟~
 热河路有一家开了好多年的理发店 不管剪什么样的发型 你只要付5块钱~
 老板和他的妹妹坐在椅子上对着镜子一言不发 他们的老家在身后在岸边在安徽在全椒县~
 没有人在热河路谈恋爱 总有人在天亮时伤感 如果年轻时你没来过热河路 那你现在的生活是不是很幸福~
 纪念碑旁有一家破旧的电影院 往北走五百米就是南京火车西站~
 每天都有外地人在直线和曲线之间迷路 气喘嘘嘘眼泪模糊 奔跑跌倒奔跑~
 秋林龙虾换了新的地方 32路还是穿过挹江门 高架桥拆了修了新的隧道 走来走去走不出我的盐仓桥~
 来到城市已经八百九十六天 热河路一直是相同的容颜~
 偶尔有干净的潘西路过 她不会说你好再见~
*/
//
// - 数据透传模块（使用透传板，每次需要输入透传板uid）< - 透传板uid可以连接上串口打印波特率115200查看 - >

import UIKit
import ETILinkSDK
import SVProgressHUD

class DataTransfer: BaseViewController , UITextFieldDelegate , ChatDataSource , MessageReceiveDelegete{
    
    var Chats:NSMutableArray!
    
    var tableView:TableView!
    
    var me:UserInfo!
    
    var you:UserInfo!
    
    var TouChuanBanUid = "" //透传板uid
    
    var mainViewController : ViewController!

    @IBOutlet weak var ParentView: UIView!
    
    @IBOutlet weak var bottomoragin: NSLayoutConstraint! //底部缩进
    
    @IBOutlet weak var input: UITextField!
    
    @IBOutlet weak var BottomView: UIView!
    
    @IBAction func SendMessage() {
        chatTo()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "数据透传"
       
        // Do any additional setup after loading the view.
        ViewController.isResponse = false
        input.returnKeyType = UIReturnKeyType.send
        self.input.delegate = self
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillChange(_:)),name: .UIKeyboardWillChangeFrame, object: nil)
        Chats = NSMutableArray()
        mainViewController = self.navigationController!.viewControllers[0] as! ViewController //取得ViewContrallor实例（使用appManage对象)
        mainViewController.messagereceiveddelegate = self
        setupChatTable()
        
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
            self.bottomoragin.constant = intersection.height + 5
            UIView.animate(withDuration: duration, delay: 0.0,options: UIViewAnimationOptions(rawValue: curve), animations: {
                _ in
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func rowsForChatTable(_ tableView:TableView) -> Int
    {
        return self.Chats.count
    }
    
    func chatTableView(_ tableView:TableView, dataForRow row:Int) -> MessageItem
    {
        
        return Chats[row] as! MessageItem
    }
    
    //点击键盘上的发送键
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatTo()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.input.resignFirstResponder()
    }
    
    func setupChatTable()
    {
        self.view.bringSubview(toFront: BottomView) //将输入框移到最上层，避免被其他视图遮住
        self.tableView = TableView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:self.ParentView.frame.height - BottomView.frame.height - 10), style: .plain)
        //创建一个重用的单元格
        self.tableView!.register(TableViewCell.self, forCellReuseIdentifier: "ChatCell")
        me = UserInfo(name:"me" ,logo:("头像_设备.png"))
        you  = UserInfo(name:"you", logo:("头像_设备.png"))
        //   let second =  MessageItem(image:UIImage(named:"sz.png")!,user:me, date:Date(timeIntervalSinceNow:-90000290), mtype:.mine)
        let item =  MessageItem(body:"请确认你的透传板在线，再使用透传功能。",user:me, date:Date(timeIntervalSinceNow:0), mtype:.mine)
        
        Chats.add(item)
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        self.ParentView.addSubview(self.tableView)
    }
    //收到透传板发出的消息
    func onMessageReceived(topic: String?, message: ETReceiveMessage) {
        if topic! == TouChuanBanUid {
            let receive = String(bytes: message.bytes, encoding: String.Encoding.utf8)
            
            let item =  MessageItem(body:(receive as NSString?)!,user:you, date:Date(timeIntervalSinceNow:0), mtype:.someone)
            
            Chats.add(item)
            self.tableView.reloadData()
        }
        
    }
    
    func chatTo(){
        if input.text == nil {
            SVProgressHUD.showError(withStatus: "请先输入再发送")
            return
        }
        if input.text! == "" {
            SVProgressHUD.showError(withStatus: "请先输入再发送")
            return
        }
        self.input.resignFirstResponder()
        let message = ETMessage(str:input.text!)
        mainViewController.mAppManager.etManager.chatTo(TouChuanBanUid, message: message) { (error) in
            guard error == nil else {
                SVProgressHUD.showError(withStatus: "发送失败")
                return
            }
            print("chatoto [\(self.TouChuanBanUid)] ,content \(message)")
            //发送成功-->更新对话视图
            let fouth =  MessageItem(body:self.input.text! as NSString,user:self.me, date:Date(timeIntervalSinceNow:0), mtype:.mine)
            self.Chats.add(fouth)
            self.tableView.reloadData()
            self.input.text = ""
        }
    }

}

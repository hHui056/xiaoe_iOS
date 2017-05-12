//
//  VisualInteractive.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/2.
//  Copyright © 2017年 何辉. All rights reserved.
//

import UIKit
class VisualInteractive: BaseViewController , ChatDataSource , UITextFieldDelegate{
    
    let CELL_MESSAGE = "CELL_SHOW_MESSAGE"
    
    var Chats:NSMutableArray!
    
    var tableView:TableView!
    
    @IBOutlet weak var bottomview: UIView!
   
    @IBOutlet weak var bottomviewmargin: NSLayoutConstraint!
   
    @IBOutlet weak var input: UITextField!
    
    @IBOutlet weak var topview: UIView!

    
   
    var me:UserInfo!
    
    var you:UserInfo!
    
    @IBAction func sendMessage() {
        chatToLed()
        self.input.resignFirstResponder()
        input.text = ""
   
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "可视交互"
        
        input.returnKeyType = UIReturnKeyType.send
        self.input.delegate = self
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillChange(_:)),name: .UIKeyboardWillChangeFrame, object: nil)
        
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
            print("键盘高度是: \(intersection.height)")
            UIView.animate(withDuration: duration, delay: 0.0,options: UIViewAnimationOptions(rawValue: curve), animations: {
                            _ in
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
   //
    func setupChatTable()
    {
        
         self.tableView = TableView(frame:CGRect(x: 0, y: topview.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - bottomview.frame.size.height - topview.frame.size.height), style: .plain)
        //创建一个重用的单元格
        self.tableView!.register(TableViewCell.self, forCellReuseIdentifier: "ChatCell")
        me = UserInfo(name:"Xiaoming" ,logo:("头像_设备.png"))
        you  = UserInfo(name:"Xiaohua", logo:("xiaohua.png"))
        
      
   //   let second =  MessageItem(image:UIImage(named:"sz.png")!,user:me, date:Date(timeIntervalSinceNow:-90000290), mtype:.mine)

        
        let fouth =  MessageItem(body:"免费领取开发板",user:me, date:Date(timeIntervalSinceNow:0), mtype:.mine)
        Chats = NSMutableArray()
        Chats.add(fouth)
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        self.view.addSubview(self.tableView)
    }
    
    func rowsForChatTable(_ tableView:TableView) -> Int
    {
        return self.Chats.count
    }
    
    func chatTableView(_ tableView:TableView, dataForRow row:Int) -> MessageItem
    {
        return Chats[row] as! MessageItem
    }
    //发送消息到LED屏显示
    func chatToLed(){
        if input.text == "" {//输入为空
            
            return
        }
        let msg = MessageItem(body:input.text! as NSString,user:me, date:Date(timeIntervalSinceNow:0), mtype:.mine)
        Chats.add(msg)
        self.tableView.reloadData()

    }
}



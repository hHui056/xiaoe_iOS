//
//  GroupManager.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/10.
//  Copyright © 2017年 何辉. All rights reserved.
//
// - 群组管理模块
import UIKit
import SwiftyJSON
import ETILinkSDK
import SVProgressHUD
class GroupManager: BaseViewController , UICollectionViewDelegate ,UICollectionViewDataSource {
    
    let TAG = "GroupManager"
    
    let GROUP_MEMBER_CELL = "group_member_cell"
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var addgroupmemberlabel: UILabel!
    
    var addicon = [ADD_GROUP_MEMBER_ICON] //最后一个添加按钮
    
    var NowMembers = [String]()   //当前所有成员数据（除了最后一个添加按钮数据）
    
    var isHaveThisUid = false  //群组中是否含有新增的uid
    
    var mainViewController : ViewController!
    
    var MyGroupInfo = ETILinkSDK.ETGroup() //我的群组信息
    
    var isCreateGroup = false  //是否为创建群组 false：每次添加删除一个群成员     true：群成员数据本地运算，最后的数组用来创建群
    
    var WaitingAddUid : [String]?//等待加入群组的uid ,次数组的长度为1
    
    @IBOutlet weak var group_name: MyTextFiled!
    
    
    @IBOutlet weak var GroupMemberLists: UICollectionView!
   

    
    @IBAction func SureSetting(_ sender: UIButton) {
        if isCreateGroup {//允许创建群组
            if group_name.text == "" {
                showDialog(data: "请先输入群名称")
                return
            }
            if NowMembers.count == 0 {
                showDialog(data: "还未添加群成员")
                return
            }
            createGroup(name: group_name.text!)
        }
        
    }
    
    //点击任意位置键盘弹出
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.group_name.resignFirstResponder()
    }
    //视图出现时重新刷新grid数据显示
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isHaveThisUid {
         showDialog(data: "群组中已含有此设备，请勿重复添加！")
        }else {//调用api，添加uid到群成员中
            if WaitingAddUid != nil {
                addGroupMember(uid: WaitingAddUid![0])
            }
        }
        isHaveThisUid = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "群组管理"
        // 添加 TextFeild 的左边距
        group_name.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        group_name.leftViewMode = .always
        GroupMemberLists.backgroundColor = UIColor(red: 0.973, green: 0.976, blue: 0.976, alpha: 1)
        addgroupmemberlabel.backgroundColor = UIColor(red: 0.973, green: 0.976, blue: 0.976, alpha: 1)
        addgroupmemberlabel.textColor = UIColor(red: 0.773, green: 0.776, blue: 0.776, alpha: 1)
        group_name.textColor = UIColor(red: 0.773, green: 0.776, blue: 0.776, alpha: 1)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:60,height:60)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        GroupMemberLists.collectionViewLayout = layout
        
        GroupMemberLists.delegate = self
        GroupMemberLists.dataSource = self
        //注册一个cell
        let nibCell = UINib(nibName: "GroupMember", bundle: nil)
        GroupMemberLists.register(nibCell, forCellWithReuseIdentifier:GROUP_MEMBER_CELL)
        GroupMemberLists.reloadData()
        self.view.addSubview(GroupMemberLists)
        mainViewController = self.navigationController!.viewControllers[0] as! ViewController //取得ViewContrallor实例（使用appManage对象）
        
        // ------------初始化数据显示-------------------
        if defaults.string(forKey: GROUPID_KEY) != nil{// - 本地有群组数据(id,name)---->获取成员列表
            MyGroupInfo.groupId = defaults.string(forKey: GROUPID_KEY)!
            MyGroupInfo.name = defaults.string(forKey: GROUPNAME_KEY)!
            self.group_name.text = MyGroupInfo.name
            self.group_name.isEnabled = false
            self.getGroupMembers(MyGroupInfo.groupId)
            GroupMemberLists.reloadData()
        }else{//本地无保存的群组数据-------->获取群组数据------>有群组（获取成员列表） ： 无群组(准备创建群组)
            getMyGroupAndGroupMembers()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: 代理
    //每个区的item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return NowMembers.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if indexPath.section == 0 && indexPath.row == NowMembers.count {//点击的是添加成员图标
            let  scanner = ScannerViewController()
            scanner.WhereFrom = ADD_DEVICE
            scanner.delegate = self
            self.navigationController?.pushViewController(scanner, animated: true)
        }else{//点击的是成员头像
            print("点击的成员的id是； \(NowMembers[indexPath.row])")
            let alertController:UIAlertController = UIAlertController(title: "提示", message: "确定将此设备移出群组？", preferredStyle:
                UIAlertControllerStyle.alert)
            let maction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: {(alertAction)-> Void in
                self.deleteGroupMember(userIndex: indexPath.row)
            })
           
            let maction1 = UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: {(alertAction)-> Void in
                
            })
            alertController.addAction(maction)
            alertController.addAction(maction1)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    //分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //自定义cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GROUP_MEMBER_CELL, for: indexPath) as! GroupMember
        if indexPath.row != NowMembers.count {//不是最后一项，使用成员数据
            cell.setdata(uid: NowMembers[indexPath.row])
        }else{//最后一项---->加载添加设备图标
            cell.setdata(uid: addicon[0])
        }
        return cell
    }
    
    func showPrint(_ data:String) {
        print("\(TAG) \(data)")
    }
    
    func showDialog(data:String){
        let alertController:UIAlertController = UIAlertController(title: "提示", message: data, preferredStyle:
            UIAlertControllerStyle.alert)
        let maction = UIAlertAction(title: "确 定", style: UIAlertActionStyle.default, handler: {(alertAction)-> Void in
            
        })
        alertController.addAction(maction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension GroupManager : MessageDelegete {
    
    func sendMessage(message: String) {
        showPrint("扫描到的数据：  \(message)")
                for item in NowMembers {
                    if item == message {
                        self.isHaveThisUid = true
                        return
                    }
                }
                WaitingAddUid = [message]
    }
   //获取我加入的群----->此例子中只允许加入一个群
    func getMyGroupAndGroupMembers(){
        showPrint("获取群列表")
        mainViewController.mAppManager.etManager.getGroups() { (groups, error) -> Void in
            if error == nil {
                if groups!.count > 0 {//群已建立---->获取群信息---->获取群成员列表
                    self.MyGroupInfo = groups![0]
                    self.getGroupMembers(self.MyGroupInfo.groupId)
                    self.group_name.text = self.MyGroupInfo.name
                    self.group_name.isEnabled = false
                    self.group_name.text = self.MyGroupInfo.name
                    
                    // - 保存groupname groupid 到偏好
                    self.defaults.set(groups![0].groupId, forKey: GROUPID_KEY)
                    self.defaults.set(groups![0].name, forKey: GROUPNAME_KEY)
                    self.getGroupMembers(self.MyGroupInfo.groupId)
                }else{//没有加入群------>准备创建群
                    self.group_name.isEnabled = true
                    self.isCreateGroup = true
                    
                }
            } else {
                self.showPrint("\(String(describing: error))")
                SVProgressHUD.showError(withStatus: "获取群组信息失败！")
            }
        }
    }
    // 获取群成员
    func getGroupMembers(_ groupId:String){
        showPrint("获取群成员")
        SVProgressHUD.show(withStatus: "获取群成员... ")
        mainViewController.mAppManager.etManager.getGroupMembers(groupId) { (member, createId, error) in
            if error == nil {//查询成员成功
                for item in member! {
                    self.NowMembers += [item.userID]
                    self.showPrint("nickname \(item.nickName)  username: \(item.userName) uid: \(item.userID)" )
                }
                SVProgressHUD.dismiss()
                self.GroupMemberLists.reloadData()
            } else {//查询成员失败
                self.showPrint("查询群成员出错 \(String(describing: error))")
                SVProgressHUD.showError(withStatus: "查询群成员出错！")
            }
        }
    }
    // - 创建群
    func createGroup(name:String){
        if NowMembers.count == 0 {
            showDialog(data: "请先添加设备到群组中！")
            return
        }
        SVProgressHUD.show(withStatus: "创建中...")
        showPrint("创建群")
        mainViewController.mAppManager.etManager.createGroup(name, userList: self.NowMembers) { (group, error) in
            guard error == nil else {//创建失败
                SVProgressHUD.showError(withStatus: "创建失败")
                return
            }
           SVProgressHUD.showSuccess(withStatus: "创建成功")
           self.isCreateGroup = false //不能再创建群组
           self.MyGroupInfo = group!
            
            // - 保存groupname groupid 到偏好
           self.defaults.set(group!.groupId, forKey: GROUPID_KEY)
           self.defaults.set(group!.name, forKey: GROUPNAME_KEY)
        }
    }
  
    // - 删除群成员(每次删除一个)
    func deleteGroupMember(userIndex:Int){
        SVProgressHUD.show(withStatus: "删除中...")
        mainViewController.mAppManager.etManager.removeGroupMembers(self.MyGroupInfo.groupId, userList: [self.NowMembers[userIndex]]) { (error) in
            if error == nil {//删除成功
               SVProgressHUD.showSuccess(withStatus: "删除成功")
               self.NowMembers.remove(at: userIndex)
               self.GroupMemberLists.reloadData()
            } else {//删除失败
               SVProgressHUD.showSuccess(withStatus: "删除失败")
            }
        }
    }
    
    //  - 添加群成员
    func addGroupMember(uid:String){
        SVProgressHUD.show(withStatus: "添加中...")
        mainViewController.mAppManager.etManager.addGroupMembers(self.MyGroupInfo.groupId, userList: [uid]){(users,error) in
            SVProgressHUD.dismiss()
            if error == nil {//添加成功
                if self.WaitingAddUid == nil{
                    return
                }
                self.NowMembers = self.WaitingAddUid! + self.NowMembers
                self.GroupMemberLists.reloadData()
            }else{//添加失败
                self.WaitingAddUid = nil
            }
        }
        }

}


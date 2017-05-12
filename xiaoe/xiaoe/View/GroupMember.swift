//
//  GroupMember.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/10.
//  Copyright © 2017年 何辉. All rights reserved.
//

import UIKit

class GroupMember: UICollectionViewCell {

   
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var deviceId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deviceId.lineBreakMode = NSLineBreakMode.byTruncatingMiddle //中间以省略号表示
        // Initialization code
    }
    func setdata(uid:String){
        if uid == ADD_GROUP_MEMBER_ICON {
              deviceId.text = ""
              icon.image = UIImage(named: "添加成员.png")
        }else{
              deviceId.text = uid
             icon.image = UIImage(named: "成员头像背景.png")
            
        }
      
    }
}

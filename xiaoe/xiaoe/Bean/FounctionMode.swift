//
//  FounctionMode.swift
//  xiaoe
//
//  Created by 何辉 on 2017/4/27.
//  Copyright © 2017年 何辉. All rights reserved.
//

import UIKit
class FounctionMode{
    //功能模块名字
     dynamic var name = "温湿度"
    //图标
     dynamic var icon : UIImage = UIImage(named:"温湿度.png")!
    //功能描述
    dynamic var funcdes = "查询设备温度和湿度，任意档位均可"
    init(name:String,icon:UIImage,funcdes:String) {
        self.name = name
        self.icon = icon
        self.funcdes = funcdes
    }
    init() {
        
    }
}

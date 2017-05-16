//
//  LEDControllerResBody.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/16.
//  Copyright © 2017年 何辉. All rights reserved.
//
// - LED控制反馈实体
import Foundation
class LEDControllerResBody : Body{
    
     dynamic var isSuccess = false
    
    
    override  func parseContent(content:[UInt8]){
        if content[1] == 0x00 {
            isSuccess = true
        }
    }
}

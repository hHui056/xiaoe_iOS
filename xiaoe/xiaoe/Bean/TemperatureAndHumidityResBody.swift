//
//  TemperatureAndHumidityResBody.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/3.
//  Copyright © 2017年 何辉. All rights reserved.
//
// - 温度查询回复实体
import Foundation
class TemperatureAndHumidityResBody : Body {
   dynamic var deviceType : UInt8 = 0x00
   dynamic var res : UInt8 = 0x00
   dynamic var tempeInt = ""//温度整数部分
   dynamic var tempeDec = ""//温度小数部分
   dynamic var humInt = ""//湿度整数部分
   dynamic var hunDec = ""//湿度小数部分
    
   override  func parseContent(content:[UInt8]){
     deviceType = content[0]
     res = content[1]
     humInt = String(content[2],radix:16)
     hunDec = String(content[3],radix:16)
     tempeInt = String(content[4],radix:16)
     tempeDec = String(content[5],radix:16)
     }
}

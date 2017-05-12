//
//  AirResBody.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/9.
//  Copyright © 2017年 何辉. All rights reserved.
//
// - 大气压查询回复实体
import Foundation
class AirResBody : Body{
    // - 海拔
    dynamic var high : Float = 0.0
    // - 大气压
    dynamic var air : String = ""
    
    
    override  func parseContent(content:[UInt8]){
      print("大气压byte数据： \(content)")
      let num3 =  String(content[3],radix:16)
      let num4 =  String(content[4],radix:16)
      let num5 =  String(content[5],radix:16)
       
      let strnum = Float(num3 + num4 + num5)
      
      air = num3 + num4 + num5
        
      high = (1013.25 - strnum! / 100) * 9
    }
}

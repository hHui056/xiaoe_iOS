//
//  RGBControllerReqBody.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/15.
//  Copyright © 2017年 何辉. All rights reserved.
//
// - 灯光控制请求指令实体
import Foundation
class RGBControllerReqBody:Body{
    var data = [UInt8](repeating: 0x00,count: 4)
    
    override func toByteArray() -> [UInt8]? {
        
        return data
    }
    
    init(color:String) {
        data[0] = 0x10
        switch color {
        case LIGHT_COLORS[0]: //紫红
            data[1] = 230
            data[2] = 29
            data[3] = 190
        case LIGHT_COLORS[1]: //大红
            data[1] = 250
            data[2] = 40
            data[3] = 11
        case LIGHT_COLORS[2]: //橘红
            data[1] = 255
            data[2] = 126
            data[3] = 0
        case LIGHT_COLORS[3]: //橘黄
            data[1] = 255
            data[2] = 195
            data[3] = 13
        case LIGHT_COLORS[4]: //柠檬黄 
            data[1] = 254
            data[2] = 255
            data[3] = 51
        case LIGHT_COLORS[5]: //草绿
            data[1] = 200
            data[2] = 253
            data[3] = 58
        case LIGHT_COLORS[6]: //中绿
            data[1] = 114
            data[2] = 244
            data[3] = 36
        case LIGHT_COLORS[7]: //绿色
            data[1] = 0
            data[2] = 209
            data[3] = 103
        case LIGHT_COLORS[8]: //淡蓝
            data[1] = 2
            data[2] = 198
            data[3] = 227
        case LIGHT_COLORS[9]: //钴蓝
            data[1] = 5
            data[2] = 118
            data[3] = 247
        case LIGHT_COLORS[10]://靛青
            data[1] = 65
            data[2] = 0
            data[3] = 251
        case LIGHT_COLORS[11]://紫色
            data[1] = 150
            data[2] = 0
            data[3] = 255
        case LIGHT_COLORS[12]://开灯
            data[1] = 255
            data[2] = 255
            data[3] = 255
        case LIGHT_COLORS[13]://关灯
            data[1] = 0
            data[2] = 0
            data[3] = 0
        default:
            data[1] = 0xe6
            data[2] = 0x1d
            data[3] = 0xbe
            print("color错误")
        }
    }
    
   override func getLength() -> Int {
        return 4
    }
}

//
//  TemperatureAndHumidityReqBody.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/3.
//  Copyright © 2017年 何辉. All rights reserved.
//

// - 温湿度指令查询实体
class TemperatureAndHumidityReqBody : Body {
    var data1 : UInt8
    override func toByteArray() -> [UInt8]? {
       
        let bytes : [UInt8] = [data1]
        return bytes;
    }
    
    init(data1:UInt8) {
        self.data1 = data1
    }
    
    override func getLength() -> Int {
        return 1
    }
}

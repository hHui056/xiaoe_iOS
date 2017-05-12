//
//  AirReqBody.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/9.
//  Copyright © 2017年 何辉. All rights reserved.
//

// - 大气压查询指令实体
class AirReqBody : Body{
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

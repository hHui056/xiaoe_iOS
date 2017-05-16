//
//  RGBControllerResBody.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/15.
//  Copyright © 2017年 何辉. All rights reserved.
//

import Foundation
class RGBControllerResBody:Body {
    dynamic  var isSuccess = false
    
    override  func parseContent(content:[UInt8]){
        if content[1] == 0x00 {
            isSuccess = true
        }else{
            isSuccess = false
        }
        
    }
}

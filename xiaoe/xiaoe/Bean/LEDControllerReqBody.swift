//
//  LEDControllerReqBody.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/4.
//  Copyright © 2017年 何辉. All rights reserved.
//
import Foundation
class LEDControllerReqBody:Body{
    //发送到LED屏显示的内容，只支持中文
    var content : String
    
    var data_length : Int = 0
    
    let type : UInt8 = 0x40
    //转为gbk 字节数组
    override func toByteArray() -> [UInt8]? {
        var result :  [UInt8] = [UInt8](repeating: 0x00,count: data_length)
        result[0] = type
        
        let enc1 = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        let data1 = content.data(using: String.Encoding(rawValue: enc1), allowLossyConversion: false)
        var i = 0
        var index = 1
        repeat {
            result[index] = (data1?[i])! - 160
            i += 1
            index += 1
        }while index < data_length
        print("return result is : \(result)")
        return result
    }
    init(content:String){
        self.content = content
        let ss : NSString = content as NSString
        self.data_length = ss.length*2 + 1
    }
    
    override func getLength() -> Int {
        return data_length
    }  
    
//    func UTF8ToGB2312(str: String) -> (NSData?, UInt) {
//        let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
//        
//        let data = str.data(using: String.Encoding(rawValue: enc), allowLossyConversion: false)
//        return (data as? NSData, enc)
//    }
    
  
}


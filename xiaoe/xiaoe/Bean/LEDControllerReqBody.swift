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
//        var buffers : [UInt8] = [UInt8](repeating: 0x00,count: data_length-1)
        var result :  [UInt8] = [UInt8](repeating: 0x00,count: data_length)
//        result[0] = type
//        
//        let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.HZ_GB_2312.rawValue))
//        let y : UnsafeMutablePointer<Int> = UnsafeMutablePointer<Int>.allocate(capacity: data_length-1)
//        let afterRange = content.startIndex..<content.endIndex
//        let x : UnsafeMutablePointer<Range<String.Index>> = UnsafeMutablePointer<Range<String.Index>>.allocate(capacity: data_length-1)
//       
//        let isHave = content.getBytes(&buffers, maxLength: data_length-1, usedLength: y , encoding: String.Encoding(rawValue: enc), range: afterRange, remaining: x)
//        if isHave {
//            var i = 0
//            var index = 1
//            repeat{
//               result[index] = buffers[i]
//                i += 1
//                index += 1
//            }while i < buffers.count
//        }
//        print("return result is : \(result)")
        return result
    }
    init(content:String){
        self.content = content
        let ss : NSString = content as NSString
        self.data_length = ss.length*2+1
    }
    
    override func getLength() -> Int {
        return data_length
    }
}


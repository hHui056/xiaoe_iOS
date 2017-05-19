//
//  Extensions.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/4.
//  Copyright © 2017年 何辉. All rights reserved.
//

import Foundation
extension String {
    
    /// 串的utf8字节
    var bytes: [UInt8] {
        return [UInt8](utf8)
    }
    /// 转化为 UInt16
    var toUInt16: UInt16 {
        guard let res = UInt16(self) else {
            return 0
        }
        return res
    }
}
extension String {
    // 对象方法
    func getFileSize() -> UInt64  {
        var size: UInt64 = 0
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
        // 判断文件存在
        if isExists {
            // 是否为文件夹
            if isDir.boolValue {
                // 迭代器 存放文件夹下的所有文件名
                let enumerator = fileManager.enumerator(atPath: self)
                for subPath in enumerator! {
                    // 获得全路径
                    let fullPath = self.appending("/\(subPath)")
                    do {
                        let attr = try fileManager.attributesOfItem(atPath: fullPath)
                        size += attr[FileAttributeKey.size] as! UInt64
                    } catch  {
                        print("error :\(error)")
                    }
                }
            } else {    // 单文件
                do {
                    let attr = try fileManager.attributesOfItem(atPath: self)
                    size += attr[FileAttributeKey.size] as! UInt64
                    
                } catch  {
                    print("error :\(error)")
                }
            }
        }
        return size
    }
}
extension Int {
    public var toU8: UInt8{ get{return UInt8(truncatingBitPattern:self)} }
    public var to8: Int8{ get{return Int8(truncatingBitPattern:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingBitPattern:self)}}
    public var to16: Int16{get{return Int16(truncatingBitPattern:self)}}
    public var toU32: UInt32{get{return UInt32(truncatingBitPattern:self)}}
    public var to32: Int32{get{return Int32(truncatingBitPattern:self)}}
    public var toU64: UInt64{get{
        return UInt64(self) //No difference if the platform is 32 or 64
        }}
    public var to64: Int64{get{
        return Int64(self) //No difference if the platform is 32 or 64
        }}
}

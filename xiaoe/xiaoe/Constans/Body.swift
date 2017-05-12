//
//  Body.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/3.
//  Copyright © 2017年 何辉. All rights reserved.
//
// - 发送指令实体类

class Body{
    /**
     * 消息体的长度，字节数。
     */
    var length = 0
    /**
     * 消息体内容格式是否合法
     */
    var mContentAvailable : Bool = false
    /**
     * 消息的内容，可以为 nil
     */
    var mContent : [UInt8]?
    
    /**
     * 设置消息体内容格式是否正确。
     *
     * @param available true 正确； false 错误。
     */
    func setIsAvailable(isavailable:Bool){
        self.mContentAvailable = isavailable
    }
    /**
     * 消息体格式是否正确。
     *
     * @return ture，正确；false，错误。
     */
    func isAvailable()->Bool{
        return mContentAvailable
    }
    
    /**
     * 转换成要发送给设备的字节数组。
     *
     * @return null，表示消息体格式错误，不能发送到设备，需要通知UI消息体不正确。
     */
    
    func toByteArray() -> [UInt8]? {
        return mContent
    }
    /**
     * 解析应答消息体
     *
     * @param content 设备返回的消息体字节流
     */
    func parseContent(content:[UInt8]){
        self.mContent = content
    }
    
    func getLength()->Int{
        if mContent == nil {
            return 0
        }else{
            return mContent!.count
        }
    }
    
}

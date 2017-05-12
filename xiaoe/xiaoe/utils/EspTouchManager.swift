//
//  EspTouchManager.swift
//  SmartConfig
//
//  Created by HJianBo on 2016/11/2.
//  Copyright © 2016年 beidouapp. All rights reserved.
//

import Foundation
import EspTouch

/**
 EspTouch 管理类
 
 用于 EspTouch 配置功能, 依赖于 EspTouch Framework.
 在每次执行配置时, 都会创建一个 `EspTouchTask` 实例进行配置
 
 - warning: 单线程, 不并发
 
 */
class EspTouchManager: NSObject {
    
    typealias OnSuccessHandler = ([ESPTouchResult]) -> Void
    
    typealias OnConfiguredOnceHandler = (ESPTouchResult) -> Void
    
    typealias OnCofiguredTimeout = () -> Void
    
    typealias OnCofigureCanceled = () -> Void
    
    var opQueue: DispatchQueue
    
    var touchTask: ESPTouchTask?
    
    var isConfiguring: Bool
    
    var condition: NSCondition
    
    var onConfiguredOnce: OnConfiguredOnceHandler?
    
    static var shareInstance = EspTouchManager()
    
    override init() {
        isConfiguring = false
        condition = NSCondition()
        opQueue = DispatchQueue(label: "com.beidouapp.smartconfig.esptouchmanager")
    }
}

extension EspTouchManager {
    
    func cancel() {
        condition.lock()
        if let task = touchTask {
            task.interrupt()
            isConfiguring = false
        }
        condition.unlock()
    }
    
    func configrue(ssid: String, bssid: String, passwd: String, isHidden: Bool = false, count: Int32 = Int32.max,
                   onOnce: OnConfiguredOnceHandler?,
                   onSuccess: OnSuccessHandler?,
                   onTimeout: OnCofiguredTimeout?,
                   onCanceled: OnCofigureCanceled?) -> Bool {
        guard isConfiguring == false else {
            return false
        }
        
        isConfiguring = true
        onConfiguredOnce = onOnce
        
        opQueue.async {
            // execute the task
            let results = self.exectue(ssid: ssid, bssid: bssid, passwd: passwd, isHidden: isHidden, count: count)
            
            // show the result to the user in UI Main Thread
            DispatchQueue.main.async {
                self.isConfiguring = false
                if let fristResult = results.first {
                    // check whether the task is cancelled and no results received
                    if fristResult.isCancelled == false {
                        if fristResult.isSuc {
                            // 配置线程执行完成.
                            // 返回总的结果 results
                            DDLogInfo("\(results)")
                            onSuccess?(results)
                        } else {
                            // TODO: Publish Notification "FAILED"
                            DDLogWarn("frist result is failed")
                            onTimeout?()
                        }
                    } else {
                        // TODO: Publish Notification "CANCELLED"
                        DDLogWarn("frist result is cancelled")
                        onCanceled?()
                    }
                } else {
                    DDLogWarn("frist result is nil")
                }
            }
        }
        
        return true
    }
}

extension EspTouchManager {
    /**
     SmartConfig 配置 Wi-Fi.
     
     - note: 当配置成功的设备数 和 设置的 `count` 相等时、或超时后。配置线程终止，当前函数返回。
     
     - warning: 同步函数，会阻塞线程。请不要放在主线程中执行
     */
    fileprivate func exectue(ssid: String, bssid: String, passwd: String, isHidden: Bool, count: Int32) -> [ESPTouchResult] {
        condition.lock()
        
        // 超时时间 45 s
        touchTask = ESPTouchTask(apSsid: ssid, andApBssid: bssid, andApPwd: passwd, andIsSsidHiden: isHidden, andTimeoutMillisecond: 45*1000)
        touchTask!.setEsptouchDelegate(self)
        
        condition.unlock()
        
        return touchTask!.execute(forResults: count) as! [ESPTouchResult]
    }
}

// MARK: ESPTouchDelegate
extension EspTouchManager: ESPTouchDelegate {
    
    // on cofing
    func onEsptouchResultAdded(with result: ESPTouchResult!) {
        DDLogInfo("esptouch on result return: \(result)")
        DispatchQueue.main.async {
            self.onConfiguredOnce?(result)
        }
    }
}

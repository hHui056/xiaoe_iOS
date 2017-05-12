//
//  WifiSetting+SmartConfig.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/10.
//  Copyright © 2017年 何辉. All rights reserved.
//

import UIKit
import EspTouch

// MARK: - ConfigureVC
extension WifiSetting {
    
    func commit(ssid: String, bssid: String, passwd: String) -> Bool {
        
        // Esp 实例
        let instance = EspTouchManager.shareInstance
        
        var alertController = UIAlertController(title: "", message: "急速配置中，请耐心等待......", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { [weak self] _ in
            self?.cancel()
        }
        alertController.addAction(cancelAction)
        
        // 每配置成功一次
        var count = 0
        var additionalSpace = ""
        let onOnce: EspTouchManager.OnConfiguredOnceHandler = { [weak self] result in
            
            count += 1
            let ipString = "IP: " + ESP_NetUtil.descriptionInetAddr4(by: result.ipAddrData)
            if count == 1 {
                alertController.dismiss(animated: false, completion: nil)
                alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                
                // 居中左对齐（先左对齐，然后计算大小，填充空格字符）
                if let messageLabel = alertController.messageLabel {
                    messageLabel.textAlignment = .left
                    messageLabel.font = UIFont.systemFont(ofSize: 13)
                    // 计算需要填充的字符
                    let spaceSize = " ".boundingRect(withFont: messageLabel.font)
                    let ipSize = ipString.boundingRect(withFont: messageLabel.font)
                    // alertview 固定长为 238
                    let allSpaceCount = (238 - ipSize.width) / spaceSize.width
                    for _ in 0...Int(allSpaceCount / 2) {
                        additionalSpace += " "
                    }
                }
                
                // 以点击 `配置完成` 为弹框消失的前提
                let cancelAction = UIAlertAction(title: "配置完成", style: .cancel) { _ in
                    // 提示 '配置结束' 1秒后消失
                    Toast(text: "配置结束", delay: 0, duration: 1).show()
                    self?.cancel()
                }
                alertController.addAction(cancelAction)
                
                // 首次赋值
                alertController.message = "\(additionalSpace)\(ipString)"
                
                self?.present(alertController, animated: false, completion: nil)
            } else {
                alertController.message = (alertController.message ?? "") + "\n\(additionalSpace)\(ipString)"
            }
        }
        
        // 配置任务完成
        let onSuccess: EspTouchManager.OnSuccessHandler = { results in
            DDLogInfo("esptouch configrue compelete, results: \(results)")
            //alertController.dismiss(animated: false, completion: nil)
            
            // save to userdefauls
            DDLogInfo("save password to userdefauls ssid: \(ssid), password: \(passwd)")
            UserDefaults.standard.set(passwd, forKey: ssid)
        }
        
        // 超时
        let onTimeout: EspTouchManager.OnCofiguredTimeout = {
            DDLogInfo("esptouch configrue timeout")
            alertController.dismiss(animated: false, completion: nil)
            UIAlertView.showAlert(title: "", message: "配置超时，请重启设备再次配置", cancelTitle: "确认", otherTitles: nil, handler: nil)
        }
        
        // 取消
        let onCanceled: EspTouchManager.OnCofigureCanceled = {
            DDLogInfo("esptouch has cancelled!")
            // ..
        }
        
        let result = instance.configrue(ssid: ssid, bssid: bssid, passwd: passwd,
                                        onOnce: onOnce,
                                        onSuccess: onSuccess,
                                        onTimeout: onTimeout,
                                        onCanceled: onCanceled)
        
        present(alertController, animated: true, completion: nil)
        return result
    }
    
    func cancel() {
        EspTouchManager.shareInstance.cancel()
    }
}


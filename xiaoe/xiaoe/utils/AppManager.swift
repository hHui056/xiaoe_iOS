//
//  AppManager.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/2.
//  Copyright © 2017年 何辉. All rights reserved.
//

import Foundation
import ETILinkSDK

class AppManager: NSObject {
    
    var server: ETServer? = nil
    
    var etManager: ETILink
    
    var delegate : HeHuiDelegete?
    
    /// uid 为用户ID，如果没有需要调用 `addUser` 创建一个用户
    init(uid: String) {
        let appKey = APPKEY
        let secretKey = SECRETKEY
        let host = SERVER_HOST
       
        // 使用 AppKey、SecretKey、还有服务器地址，创建一个 option
        let createOpt = ETCreateOpt(appKey: appKey, secretKey: secretKey, balancHost: host)
        
        // 实例化 ETILink 对象
        etManager = ETILink(uid: uid, option: createOpt)
        super.init()
        // 设置回调
        etManager.delegate = self
        
        etManager.getUserStateHandler = {(userId,state,error) in
            self.delegate?.onUserState(userID: userId, state: state,error: error)
            print("uid :\(userId) 状态： \(state)")
        }
    }
    
    deinit {
        // 析构后, 断开连接
        etManager.disconnect()
    }
    
    // 发现服务器
    func discover() {
        etManager.discoverServers(timeout: 10)
    }
    
    // 连接服务器
    func connect(mserver:ETServer,handler: @escaping (ETServer?, NSError?) -> Void) {
        let conopt = ETConnectOpt(keepAlive: 10, cleansess: false, timeOut: 20)
        
        if server == nil {
            print("server = nil, the connect method will connect to default server")
        }        
        // connect to the server
        etManager.connect(mserver, option: conopt, handler: handler)
    }
    //
    func getDeviceState(uid:String){
       
        etManager.getUserState(uid)
    }
}

extension AppManager: ETILinkDelegate {
    
    // 成功发现一个服务器, 触发该回调
    func onServer(_ server: ETServer) {
        if server.type == .server {
            self.server = server
            print("has discover server: \(server)")
            self.delegate?.onServer(server: server)
          
        }
    }
    
    // 发现服务器完成
    func onDiscoverCompelated() {
        print("discover has compelated")
    }
    
    // 断开连接后, 触发该回调. (若为异常断线, error 则包含异常信息. 正常断开, error == ni)
    func onBroken(_ server: ETServer, error: NSError?) {
        print("disconnected from \(server), error: \(error)")
        self.delegate?.onBroken(server: server, error: error)
        
    }
    
    // 收到消息时, 触发该回调
    func onMessage(_ type: ETMessageType, topic: String?, sender: String?, message: ETReceiveMessage) {
        
        self.delegate?.onMessage(type:type,topic:topic,sender:sender,message: message)
    }
    
    // 收到文件, 触发该回调
    func onFileRecved(_ senderUid: String, fileInfo: ETFileInfo) {
        print("recv file, sender: \(senderUid), fileInfo: \(fileInfo)")
        self.delegate?.onFileRecved(senderUid: senderUid, fileInfo: fileInfo)
        // create directory
//        let downloadPath = NSHomeDirectory() + "/Documents/etdownloads"
//        let fileManager = FileManager.default
//        do {
//            try fileManager.createDirectory(atPath: downloadPath, withIntermediateDirectories: true, attributes: nil)
//            let filePath = downloadPath + "/\(fileInfo.fileName)"
//            
//            // download files
//            etManager.downloadFile(fileInfo, localPath: filePath) { (error) in
//                guard error == nil else {
//                    print("downloadfile error \(error!)")
//                    return
//                }
//                
//                print("downloadfile success, path: \(filePath)")
//            }
//        } catch {
//            print("create directory error \(error)")
//            return
//        }
    }
    
}

protocol HeHuiDelegete {
    func onMessage(type: ETMessageType, topic: String?, sender: String?, message: ETReceiveMessage)
    func onServer(server:ETServer)
    func onBroken(server:ETServer,error:NSError?)
    func onFileRecved(senderUid:String,fileInfo:ETFileInfo)
    func onUserState(userID:String,state:Bool,error:NSError?)
}

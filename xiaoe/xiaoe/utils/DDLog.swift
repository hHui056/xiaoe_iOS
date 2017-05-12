//
//  DDLog.swift
//  ETLan
//
//  Created by HeJianBo on 15/8/10.
//  Copyright (c) 2015年 JianBo. All rights reserved.
//

import Foundation

// Xcode 7.x
// DEBUG 宏前往 Build Setting -> Swift Compiler - Custom Flags
// 设置 DEBUG 模式参数 "-D DEBUG"
// 即生效

@objc enum LogLevel: UInt8 {
    
    /// 不显示日志
    case Off  = 0
    
    /// 显示 错误 日志
    case Error
    
    /// 显示 错误|警告 日志
    case Warning
    
    /// 显示 错误|警告|信息 日志 (Release 不会显示)
    case Info
    
    /// 显示 错误|警告|信息|调试 日志 (Release 不会显示)
    case Debug
    
    /// 显示 错误|警告|调试|信息|冗余 日志 (Release 不会显示)
    case Verbose
}


var logLevel: LogLevel  = .Info

func DDLogVerbose(_ format: String) {
    if logLevel >= .Verbose {
        NSLog("[Verbs]: \(format)")
    }
}

func DDLogDebug(_ format: String) {
    if logLevel >= .Debug {
        NSLog("[Debug]: \(format)")
    }
}

func DDLogInfo(_ format: String) {
        if logLevel >= .Info {
            NSLog("[Info ]: \(format)")
        }
}

func DDLogWarn(_ format: String) {
    if logLevel >= .Warning {
        NSLog("[Warn ]: \(format)")
    }
}

func DDLogError(_ format: String) {
    if logLevel >= .Error {
        NSLog("[Error]: \(format)")
    }
}


//////////// Comparable

extension LogLevel: Comparable {
}

extension LogLevel: Equatable {
}

func <(lhs: LogLevel, rhs: LogLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

func <=(lhs: LogLevel, rhs: LogLevel) -> Bool {
    return lhs.rawValue <= rhs.rawValue
}

func >=(lhs: LogLevel, rhs: LogLevel) -> Bool {
    return lhs.rawValue >= rhs.rawValue
}

func >(lhs: LogLevel, rhs: LogLevel) -> Bool {
    return lhs.rawValue > rhs.rawValue
}
func ==(lhs: LogLevel, rhs: LogLevel) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

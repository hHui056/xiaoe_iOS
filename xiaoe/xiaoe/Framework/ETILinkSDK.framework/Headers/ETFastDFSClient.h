//
//  ETFastDFSClient.h
//  fastdfs
//
//  Created by HJianBo on 2016/10/25.
//  Copyright © 2016年 beidouapp. All rights reserved.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSString * const kETFastDFSErrorDomain;

typedef NS_ENUM(NSInteger, ETFDFSError) {
    
    /// 未知错误
    ETFDFSErrorUnknown = -1,
    
    /// 参数无效
    ETFDFSErrorParameterInvaild = 1,
    
    /// 服务器发生系统错误
    ETFDFSErrorSystem,
    
    /// 下载文件时, 服务器应答文件未找到
    ETFDFSErrorFileNotFound,
    
    /// FBS 用户认证错误
    ETFDFSErrorAuthFailed,
    
    /// FBS 返回错误
    ETFDFSErrorFbsRetuenError
};

@interface ETFastDFSOption : NSObject

@property (nonatomic, copy) NSString *trackAddr;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *fileExtName;

@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, copy) NSString *userId;

/**
 * LOG_EMERG	0	 system is unusable
 * LOG_ALERT	1	 action must be taken immediately
 * LOG_CRIT	    2	 critical conditions
 * LOG_ERR		3	 error conditions
 * LOG_WARNING	4	 warning conditions
 * LOG_NOTICE	5	 normal but significant condition
 * LOG_INFO	    6	 informational
 * LOG_DEBUG    7  	 debug-level messages
 */
@property (nonatomic, assign) NSInteger logLevel;

@end

@interface ETFsatDFSResultInfo : NSObject

@property (nonatomic, copy) NSString *fileId;

@property (nonatomic, assign) NSInteger fileSize;

@property (nonatomic, assign) NSInteger crc32;

@property (nonatomic, copy) NSString *trackHost;

@property (nonatomic, assign) NSInteger trackPort;

@end

@interface ETFastDFSClient : NSObject

+ (ETFsatDFSResultInfo *)uploadWithFileData:(NSData *)data andOption:(ETFastDFSOption *)option error:(NSError **)error;

// FIXME: `sendfile` 函数 在真机下存在问题！所以该函数不可用
+ (ETFsatDFSResultInfo *)uploadWithFilePath:(NSString *)path andOption:(ETFastDFSOption *)option error:(NSError **)error;

+ (BOOL)downloadFileToPath:(NSString *)path withFileId:(NSString *)fileId  andOption:(ETFastDFSOption *)option error:(NSError **)error;

+ (NSData *)downloadFileWithFileId:(NSString *)fileId  andOption:(ETFastDFSOption *)option error:(NSError **)error;

@end

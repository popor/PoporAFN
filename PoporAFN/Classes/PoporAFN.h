//
//  PoporAFN.h
//  PoporAFN
//
//  Created by popor on 17/4/28.
//  Copyright © 2017年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoporAFNConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PoporAFNFinishBlock)(NSString *url, NSData *data, NSDictionary *dic);
typedef void(^PoporAFNFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

#define PoporAFNTool [PoporAFN new]

@interface PoporAFN : NSObject

- (void)postUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(PoporAFNFinishBlock _Nullable )success failure:(PoporAFNFailureBlock _Nullable)failure;

- (void)getUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(PoporAFNFinishBlock _Nullable )success failure:(PoporAFNFailureBlock _Nullable)failure;

#pragma mark - 下载
@property (nonatomic, strong) NSURLSessionDownloadTask * downloadTask;

// PoporAFN 需要持久化,不会无法下载
- (void)downloadUrl:(NSURL * _Nonnull)downloadUrl destination:(NSURL * _Nonnull)destinationUrl progress:(void (^)(float progress, NSProgress * _Nonnull downloadProgress))progressBlock finish:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))finishBlock;

@end

NS_ASSUME_NONNULL_END

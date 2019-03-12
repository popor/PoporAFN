//
//  PoporAFN.m
//  PoporAFN
//
//  Created by popor on 17/4/28.
//  Copyright © 2017年 popor. All rights reserved.
//

#import "PoporAFN.h"
#import <PoporFoundation/PrefixFun.h>

#if TARGET_OS_IOS
#import <PoporNetRecord/PoporNetRecord.h>

#elif TARGET_OS_MAC || TARGET_OS_TV || TARGET_OS_WATCH

#endif


static NSString * MethodGet  = @"GET";
static NSString * MethodPost = @"POST";

//如何添加head.
//https://www.jianshu.com/p/c741236c5c30

@implementation PoporAFN

#pragma mark - post
// 使用默认 AFHTTPSessionManager
- (void)postUrl:(NSString *_Nullable)urlString
     parameters:(NSDictionary * _Nullable)parameters
        success:(PoporAFNFinishBlock _Nullable)success
        failure:(PoporAFNFailureBlock _Nullable)failure
{
    [self postUrl:urlString title:nil parameters:parameters afnManager:nil success:success failure:failure];
}

// 使用自定义 AFHTTPSessionManager,title
- (void)postUrl:(NSString *_Nullable)urlString
          title:(NSString *_Nullable)title
     parameters:(NSDictionary * _Nullable)parameters
     afnManager:(AFHTTPSessionManager * _Nullable)manager
        success:(PoporAFNFinishBlock _Nullable )success
        failure:(PoporAFNFailureBlock _Nullable)failure
{
    
    NSString * method = MethodPost;
    if (!manager) {
        manager = [PoporAFNConfig createManager];
    }
    __weak typeof(manager) weakManager = manager;
    
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [PoporAFN successManager:weakManager url:urlString title:title method:method parameters:parameters task:task response:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [PoporAFN failManager:weakManager url:urlString title:title method:method parameters:parameters task:task error:error failure:failure];
    }];
    
}

#pragma mark - get
// 使用默认 AFHTTPSessionManager
- (void)getUrl:(NSString *_Nullable)urlString
    parameters:(NSDictionary * _Nullable)parameters
       success:(PoporAFNFinishBlock _Nullable)success
       failure:(PoporAFNFailureBlock _Nullable)failure
{
    [self getUrl:urlString title:nil parameters:parameters afnManager:nil success:success failure:failure];
}

// 使用自定义 AFHTTPSessionManager,title
- (void)getUrl:(NSString *_Nullable)urlString
         title:(NSString *_Nullable)title
    parameters:(NSDictionary * _Nullable)parameters
    afnManager:(AFHTTPSessionManager * _Nullable)manager
       success:(PoporAFNFinishBlock _Nullable)success
       failure:(PoporAFNFailureBlock _Nullable)failure
{
    NSString * method = MethodGet;
    if (!manager) {
        manager = [PoporAFNConfig createManager];
    }
    __weak typeof(manager) weakManager = manager;
    
    [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [PoporAFN successManager:weakManager url:urlString title:title method:method parameters:parameters task:task response:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [PoporAFN failManager:weakManager url:urlString title:title method:method parameters:parameters task:task error:error failure:failure];
    }];
}

+ (void)successManager:(AFHTTPSessionManager *)manager url:(NSString *)urlString title:(NSString *_Nullable)title method:(NSString *)method parameters:(NSDictionary * _Nullable)parameters task:(NSURLSessionDataTask * _Nullable)task response:(id _Nullable) responseObject success:(PoporAFNFinishBlock _Nullable )success
{
    [manager invalidateSessionCancelingTasks:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic;
        if (responseObject) {
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (success) {
            success(urlString, responseObject, dic);
        }
#if TARGET_OS_IOS
        if (dic) {
            [PoporNetRecord addUrl:task.currentRequest.URL.absoluteString title:title method:method head:manager.requestSerializer.HTTPRequestHeaders parameter:parameters response:dic];
        }else{
            NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            if (str) {
                [PoporNetRecord addUrl:task.currentRequest.URL.absoluteString title:title method:method head:manager.requestSerializer.HTTPRequestHeaders parameter:parameters response:str];
            }else{
                [PoporNetRecord addUrl:task.currentRequest.URL.absoluteString title:title method:method head:manager.requestSerializer.HTTPRequestHeaders parameter:parameters response:nil];
            }
        }
        
#elif TARGET_OS_MAC || TARGET_OS_TV || TARGET_OS_WATCH
        
#endif
        
        
    });
}

+ (void)failManager:(AFHTTPSessionManager *)manager url:(NSString *)urlString title:(NSString *_Nullable)title method:(NSString *)method parameters:(NSDictionary * _Nullable)parameters task:(NSURLSessionDataTask * _Nullable)task error:(NSError *)error failure:(PoporAFNFailureBlock _Nullable)failure
{
    [manager invalidateSessionCancelingTasks:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (failure) {
            failure(task, error);
        }
#if TARGET_OS_IOS
        [PoporNetRecord addUrl:task.currentRequest.URL.absoluteString title:title method:method head:manager.requestSerializer.HTTPRequestHeaders parameter:parameters response:@{@"异常":error.localizedDescription}];
        
#elif TARGET_OS_MAC || TARGET_OS_TV || TARGET_OS_WATCH
        
#endif
    });
}

#pragma mark - 下载
- (void)downloadUrl:(NSURL * _Nonnull)downloadUrl
        destination:(NSURL * _Nullable)destinationUrl
           progress:(nullable void (^)(float progress, NSProgress * _Nonnull downloadProgress))progressBlock
             finish:(nullable void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))finishBlock
{
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadUrl];
    
    //下载Task操作
    self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            float progress = (float)downloadProgress.completedUnitCount/(float)downloadProgress.totalUnitCount;
            // 回到主队列刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                progressBlock(progress, downloadProgress);
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (destinationUrl) {
            return destinationUrl;
        }else{
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
            return [NSURL fileURLWithPath:path];
        }
    } completionHandler:finishBlock];
    
    [self.downloadTask resume];
}


@end

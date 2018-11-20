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

- (void)postUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(PoporAFNFinishBlock _Nullable )success failure:(PoporAFNFailureBlock _Nullable)failure {
    
    NSString * method = MethodPost;
    AFHTTPSessionManager *manager = [PoporAFNConfig createManager];
    __weak typeof(manager) weakManager = manager;
    
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [PoporAFN successManager:weakManager url:urlString method:method parameters:parameters task:task response:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [PoporAFN failManager:weakManager url:urlString method:method parameters:parameters task:task error:error failure:failure];
    }];
}

- (void)getUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(PoporAFNFinishBlock _Nullable )success failure:(PoporAFNFailureBlock _Nullable)failure {
    
    NSString * method = MethodGet;
    AFHTTPSessionManager *manager = [PoporAFNConfig createManager];
    __weak typeof(manager) weakManager = manager;
    
    [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [PoporAFN successManager:weakManager url:urlString method:method parameters:parameters task:task response:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [PoporAFN failManager:weakManager url:urlString method:method parameters:parameters task:task error:error failure:failure];
    }];
}

+ (void)successManager:(AFHTTPSessionManager *)manager url:(NSString *)urlString method:(NSString *)method parameters:(NSDictionary * _Nullable)parameters task:(NSURLSessionDataTask * _Nullable)task response:(id _Nullable) responseObject success:(PoporAFNFinishBlock _Nullable )success {
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
        [PoporNetRecord addUrl:task.currentRequest.URL.absoluteString method:method head:manager.requestSerializer.HTTPRequestHeaders request:parameters response:dic];
        
#elif TARGET_OS_MAC || TARGET_OS_TV || TARGET_OS_WATCH
        
#endif

        
    });
}

+ (void)failManager:(AFHTTPSessionManager *)manager url:(NSString *)urlString method:(NSString *)method parameters:(NSDictionary * _Nullable)parameters task:(NSURLSessionDataTask * _Nullable)task error:(NSError *)error failure:(PoporAFNFailureBlock _Nullable)failure {
    [manager invalidateSessionCancelingTasks:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (failure) {
            failure(task, error);
        }
#if TARGET_OS_IOS
        [PoporNetRecord addUrl:task.currentRequest.URL.absoluteString method:method head:manager.requestSerializer.HTTPRequestHeaders request:parameters response:@{@"异常":error.localizedDescription}];
        
#elif TARGET_OS_MAC || TARGET_OS_TV || TARGET_OS_WATCH
        
#endif

        
    });
}


#pragma mark - 下载
- (void)downloadUrl:(NSURL * _Nonnull)downloadUrl destination:(NSURL * _Nullable)destinationUrl progress:(void (^)(float progress, NSProgress * _Nonnull downloadProgress))progressBlock finish:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))finishBlock {
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

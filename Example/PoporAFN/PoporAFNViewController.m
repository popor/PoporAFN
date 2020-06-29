//
//  PoporAFNViewController.m
//  PoporAFN
//
//  Created by wangkq on 07/09/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporAFNViewController.h"

#import <PoporAFN/PoporAFN.h>
#import <PoporNetRecord/PoporNetRecord.h>

@interface PoporAFNViewController ()

@property (nonatomic, strong) PoporAFN * pAFN;

@end

@implementation PoporAFNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置head示例
    PoporAFNConfig * config = [PoporAFNConfig share];
    config.afnSMBlock = ^AFHTTPSessionManager *{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        // request
        manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        //[manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"]; //有些form-data会被这个参数弄错.
        
        // head
        [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"system"];
        [manager.requestSerializer setValue:@"popor" forHTTPHeaderField:@"name"];
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"appType"];
        [manager.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"version"];
        
        // response
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        manager.requestSerializer.timeoutInterval = 10.0f;
        
        return manager;
    };
    
    // 设置 监测回调结果 block 方法
    
    {
        // extra
         __block NSString * pnrExtraForwadUrl;
        config.recordBlock = ^(NSString *url, NSString *title, PoporMethod method, id head, id parameters, id response) {
            //[PoporNetRecord addUrl:url title:title method:method head:head parameter:parameters response:response];
            [PoporNetRecord addUrl:url title:title method:@"GET" head:head parameter:parameters response:response];
        };
        
        [PoporNetRecord share].blockExtraRecord = ^(PnrEntity * _Nonnull pnrEntity) {
            PnrExtraEntity * e = [PnrExtraEntity share];
            if (e.forward) {
                pnrExtraForwadUrl = [NSString stringWithFormat:@"%@/recordAdd", e.selectUrlPort];
                if (![pnrExtraForwadUrl isEqualToString:pnrEntity.url]) {
                    //[NetService title:@"" url:pnrExtraForwadUrl method:PoporMethodPost parameters:entity.desDic success:nil failure:nil];
                    
                    [PoporAFNTool title:@"" url:pnrExtraForwadUrl method:PoporMethodPost parameters:pnrEntity.parameterValue afnManager:nil header:pnrEntity.headValue progress:nil success:nil failure:nil];
                }
            }
        };
    }
    
    NSString * url;
    // 测试网络请求
    // [PoporAFNTool getUrl:@"https://api.androidhive.info/volley/person_object.json" title:@"JSON接口" parameters:@{@"test":@"test1"} afnManager:nil success:nil failure:nil];
    
    // [PoporNetRecord addUrl:@"http://www.baidu.com/testText1" title:@"网络假接口" method:@"POST" head:@"head" parameter:nil response:@"response"];
    
    // 老接口
    //    [PoporAFNTool getUrl:@"http://192.168.2.174:8081/" title:@"本地假接口" parameters:nil afnManager:nil success:^(NSString * _Nonnull url, NSData * _Nonnull data, NSDictionary * _Nonnull dic) {
    //        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        NSLog(@"str: %@", str);
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //    }];
    
    // 新接口
    //[PoporAFNTool title:@"测试" url:@"https://www.baidu.com" method:PoporMethodPostJson parameters:nil afnManager:nil header:nil success:nil failure:nil];
    // http://192.168.7.111:9000/record
    //    [PoporAFNTool title:@"测试" url:@"http://192.168.7.111:9000/test_a" method:PoporMethodGetJson parameters:nil afnManager:nil header:nil success:^(NSString * _Nonnull url, NSData * _Nonnull data, NSDictionary * _Nonnull dic) {
    //        NSString * str  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        NSLog(@"0 请求结果: %@", str);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"0 请求error: %@", error.localizedDescription);
    //    }];
    
    //url = @"http://192.168.7.105:8881/api/userService/verification/getCode";
    url = @"http://192.168.7.249:18881/api/userService/verification/getCode";
    
    [PoporAFNTool title:@"测试" url:url method:PoporMethodFormData parameters:@{@"phone":@"13311110000", @"clientId":@"unknown"} afnManager:nil header:nil success:^(NSString * _Nonnull url, NSData * _Nonnull data, NSDictionary * _Nonnull dic) {
        if (data) {
            NSString * str  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"1 请求结果: %@", str);
        } else if(dic) {
            NSLog(@"1 请求结果: %@", [dic description]);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"1 请求error: %@", error.localizedDescription);
    }];
}

// 测试form-data请求
- (void)testForm_data_request {
    NSString * urlString = @"http://192.168.7.105:8881/api/userService/verification/getCode";
    urlString = @"http://192.168.7.249:18881/api/userService/verification/getCode";
    //url = @"http://www.baidu.com";
    
    NSDictionary * parameters = @{@"phone":@"18717930030", @"clientId":@"unknown"};
    
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:nil];
    [request addValue:@"1" forHTTPHeaderField:@"appType"];
    [request addValue:@"1" forHTTPHeaderField:@"version"];
    
    [request addValue:@"zh-Hans-US;q=1, en;q=0.9" forHTTPHeaderField:@"Accept-Language"];
    //[request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"PoporAFN_Example/1.0 (iPhone; iOS 13.5; Scale/2.00)" forHTTPHeaderField:@"User-Agent"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"response:%@, responseObject:%@", response, responseObject);
            NSString * message = responseObject[@"message"];
            //NSString * str  = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"message: %@", message);
        }
    }];
    
    [uploadTask resume];
}

// 使用自定义的AFNManage
- (void)customeAFNManage {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer     = [AFJSONRequestSerializer serializer];
    manager.responseSerializer    = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]; // 不然不支持www.baidu.com.
    
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"system"];
    
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    [PoporAFNTool title:@"测试json" url:@"https://api.androidhive.info/volley/person_object.json" method:PoporMethodPost parameters:@{@"test":@"test1"} afnManager:nil header:nil success:nil failure:nil];
}

- (void)downloadAction {
    NSURL * URL = [NSURL URLWithString:@"https://stdl.qq.com/stdl/MACQQBrowser/kantu/img/gallery/1.png"];
    URL = [NSURL URLWithString:@"https://dldir1.qq.com/qqfile/QQforMac/QQ_V6.5.2.dmg"];
    self.pAFN = PoporAFNTool;
    [self.pAFN downloadUrl:URL destination:nil progress:^(float progress, NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度: %f", progress);
    } finish:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        NSLog(@"filePath: %@", filePath.absoluteString);
    }];
}

@end

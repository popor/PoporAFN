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
    
    // 设置head示例
    PoporAFNConfig * config = [PoporAFNConfig share];
    config.afnSMBlock = ^AFHTTPSessionManager *{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer  = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]; // 不然不支持www.baidu.com.
        
        [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"system"];
        [manager.requestSerializer setValue:@"popor" forHTTPHeaderField:@"name"];
        
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        manager.requestSerializer.timeoutInterval = 10.0f;
        
        return manager;
    };
    
    // 测试网络请求
    // [PoporAFNTool getUrl:@"https://api.androidhive.info/volley/person_object.json" title:@"JSON接口" parameters:@{@"test":@"test1"} afnManager:nil success:nil failure:nil];
    
    // [PoporNetRecord addUrl:@"http://www.baidu.com/testText1" title:@"网络假接口" method:@"POST" head:@"head" parameter:nil response:@"response"];
    
    // 老接口
    [PoporAFNTool getUrl:@"http://192.168.2.174:8081/" title:@"本地假接口" parameters:nil afnManager:nil success:^(NSString * _Nonnull url, NSData * _Nonnull data, NSDictionary * _Nonnull dic) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"str: %@", str);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    // 新接口
    [PoporAFNTool title:@"测试" record:YES url:@"https://www.baidu.com" method:PoporMethodGet parameters:nil afnManager:nil success:nil failure:nil];
    
    //[self downloadAction];
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
    
    [PoporAFNTool getUrl:@"https://api.androidhive.info/volley/person_object.json" title:@"测试json" parameters:@{@"test":@"test1"} afnManager:manager success:nil failure:nil];
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

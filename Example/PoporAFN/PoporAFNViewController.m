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
        
        manager.requestSerializer =  [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]; // 不然不支持www.baidu.com.
        
        [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"system"];
        [manager.requestSerializer setValue:@"popor" forHTTPHeaderField:@"name"];
        
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        manager.requestSerializer.timeoutInterval = 10.0f;
        
        return manager;
    };
    
    // 测试网络请求
    [PoporAFNTool getUrl:@"https://api.androidhive.info/volley/person_object.json" parameters:@{@"test":@"test1"} success:nil failure:nil];
    [PoporAFNTool postUrl:@"https://api.androidhive.info/volley/person_object.json" parameters:@{@"test":@"test1"} success:nil failure:nil];
    
    //[self downloadAction];
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

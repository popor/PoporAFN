//
//  ViewController.m
//  PoporAFNMac
//
//  Created by apple on 2018/9/5.
//  Copyright © 2018年 wangkq. All rights reserved.
//

#import "ViewController.h"

#import <PoporAFN/PoporAFN.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PoporAFNTool getUrl:@"https://api.androidhive.info/volley/person_object.json" parameters:@{@"test":@"test1"} monitor:YES success:^(NSString * _Nonnull url, NSData * _Nonnull data, NSDictionary * _Nonnull dic) {
        NSLog(@"\n\nPoporAFNMac data : %li", data.length);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n\nPoporAFNMac error : %@", error.localizedDescription);
    }];
}

@end

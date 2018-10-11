//
//  PoporAFNConfig.h
//  PoporAFN
//
//  Created by popor on 17/4/28.
//  Copyright © 2017年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface PoporAFNConfig : NSObject

typedef AFHTTPSessionManager*(^PoporAFNSMBlock)(void); // __BlockTypedef

@property (nonatomic, copy  ) PoporAFNSMBlock afnSMBlock;

@property (nonatomic, getter=isMonitorAFNNet) BOOL monitorAFNNet;// 监测网络

+ (AFHTTPSessionManager *)createManager;
+ (PoporAFNConfig *)share;


@end


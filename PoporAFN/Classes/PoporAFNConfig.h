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

@property (nonatomic, copy  ) PoporAFNSMBlock afnSMBlock;//APP 需要设置p默认的head block. 假如需要设置单独的head可以自定义,使用PoporAFN的自定义manage接口.

+ (AFHTTPSessionManager *)createManager;
+ (PoporAFNConfig *)share;


@end


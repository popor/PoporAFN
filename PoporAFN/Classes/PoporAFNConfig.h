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

+ (AFHTTPSessionManager *)createManager;

@end


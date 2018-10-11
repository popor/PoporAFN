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

#define PoporAFNTool [[PoporAFN alloc] init]

@interface PoporAFN : NSObject

- (void)postUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(PoporAFNFinishBlock _Nullable )success failure:(PoporAFNFailureBlock _Nullable)failure;

- (void)getUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(PoporAFNFinishBlock _Nullable )success failure:(PoporAFNFailureBlock _Nullable)failure;

@end

NS_ASSUME_NONNULL_END

//
//  PoporNetRecord.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PnrPrefix.h"
#import "PnrConfig.h"
#import "PnrView.h"
#import "PnrEntity.h"
#import "PnrExtraEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoporNetRecord : NSObject

@property (nonatomic, weak  ) PnrConfig * config;
@property (nonatomic, weak  ) PnrView   * view;

@property (nonatomic, strong) NSMutableArray * infoArray;
@property (nonatomic, weak  ) UINavigationController * nc;

@property (nonatomic, copy  ) PnrBlockPPnrEntity blockExtraRecord; // 转发完成之后的回调

+ (instancetype)share;

// 网络请求部分
/**
 headValue:      NSDictionary | NSString
 parameterValue: NSDictionary | NSString
 responseValue:  NSDictionary | NSString
 */
+ (void)addUrl:(NSString *)urlString method:(NSString *)method head:(id _Nullable)headValue parameter:(id _Nullable)parameterValue response:(id _Nullable)responseValue;

// 增加title
+ (void)addUrl:(NSString *)urlString title:(NSString *)title method:(NSString *)method head:(id _Nullable)headValue parameter:(id _Nullable)parameterValue response:(id _Nullable)responseValue;

+ (void)setPnrBlockResubmit:(PnrBlockResubmit _Nullable)block extraDic:(NSDictionary * _Nullable)dic;

// Log 部分
+ (void)addLog:(NSString *)log;
+ (void)addLog:(NSString *)log title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END


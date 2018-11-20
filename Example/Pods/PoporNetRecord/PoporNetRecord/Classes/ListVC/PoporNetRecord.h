//
//  NetMonitorTool.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoporNetRecordConfig.h"

typedef void(^PoporNetRecordBlockPVoid) (void);

@interface PoporNetRecord : NSObject

@property (nonatomic, weak  ) PoporNetRecordConfig * config;

@property (nonatomic, weak  ) UIWindow * window;
@property (nonatomic, strong) UIButton * ballBT;

@property (nonatomic        ) CGFloat sBallHideWidth;
@property (nonatomic        ) CGFloat sBallWidth;
@property (nonatomic, strong) NSMutableArray * infoArray;

@property (nonatomic, weak  ) UINavigationController * nc;
@property (nonatomic, copy  ) PoporNetRecordBlockPVoid openBlock;
@property (nonatomic, copy  ) PoporNetRecordBlockPVoid closeBlock;

@property (nonatomic, getter=isShow) BOOL show;

+ (instancetype)share;

+ (void)addUrl:(NSString *)urlString method:(NSString *)method head:(NSDictionary *)headDic request:(NSDictionary *)requestDic response:(NSDictionary *)responseDic;

// 把ballBT提到最高层.
+ (void)bringFrontBallBT;

@end

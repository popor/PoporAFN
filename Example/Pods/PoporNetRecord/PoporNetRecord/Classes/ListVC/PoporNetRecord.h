//
//  NetMonitorTool.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PoporFoundation/PrefixBlock.h>

typedef NS_ENUM(int, PoporNetRecordType) {
    PoporNetRecordAuto = 1, // 开发环境或者虚拟机环境
    PoporNetRecordEnable, // 全部监测
    PoporNetRecordDisable, // 全部忽略
};

typedef void(^PoporNetRecordNcBlock) (UINavigationController * nc);

@interface PoporNetRecord : NSObject

@property (nonatomic        ) CGFloat   activeAlpha;
@property (nonatomic        ) CGFloat   normalAlpha;
@property (nonatomic        ) NSInteger recordMaxNum;

@property (nonatomic        ) PoporNetRecordType recordType;//监测类型
@property (nonatomic, copy  ) BlockPVoid freshBlock;
@property (nonatomic, copy  ) PoporNetRecordNcBlock presentNCBlock;// 用户更新 presentViewController NC的状态

+ (instancetype)share;

+ (void)addUrl:(NSString *)urlString method:(NSString *)method head:(NSDictionary *)headDic request:(NSDictionary *)requestDic response:(NSDictionary *)responseDic;

@end

//
//  NetMonitorTool.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PoporFoundation/BlockMacroDefines.h>

@interface PoporNetRecord : NSObject

@property (nonatomic        ) CGFloat   activeAlpha;
@property (nonatomic        ) CGFloat   normalAlpha;
@property (nonatomic        ) NSInteger recordMaxNum;

@property (nonatomic, copy  ) BlockPVoid freshBlock;

+ (instancetype)share;

+ (void)addUrl:(NSString *)urlString method:(NSString *)method head:(NSDictionary *)headDic request:(NSDictionary *)requestDic response:(NSDictionary *)responseDic;

@end

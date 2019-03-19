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

@interface PoporNetRecord : NSObject

@property (nonatomic, weak  ) PnrConfig * config;
@property (nonatomic, weak  ) PnrView   * view;

@property (nonatomic, strong) NSMutableArray * infoArray;
@property (nonatomic, weak  ) UINavigationController * nc;

+ (instancetype)share;

/**
 headValue:      NSDictionary | NSString
 parameterValue: NSDictionary | NSString
 responseValue:  NSDictionary | NSString
 */
+ (void)addUrl:(NSString *)urlString method:(NSString *)method head:(id)headValue parameter:(id)parameterValue response:(id)responseValue;

// 增加title
+ (void)addUrl:(NSString *)urlString title:(NSString *)title method:(NSString *)method head:(id)headValue parameter:(id)parameterValue response:(id)responseValue;

+ (void)setPnrBlockResubmit:(PnrBlockResubmit)block extraDic:(NSDictionary *)dic;

@end

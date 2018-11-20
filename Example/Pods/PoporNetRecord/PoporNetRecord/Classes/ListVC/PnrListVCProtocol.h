//
//  PnrListVCProtocol.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import "PnrVCEntity.h"
#import <PoporFoundation/PrefixBlock.h>
#import <PoporAlertBubbleView/AlertBubbleView.h>

static NSString * PoporNetRecordTextColorBlack  = @"黑色";
static NSString * PoporNetRecordTextColorColors = @"彩色";

// 对外接口
@protocol PnrListVCProtocol <NSObject>

- (UIViewController *)vc;
- (void)setMyPresent:(id)present;

// self   : 自己的
@property (nonatomic, strong) UITableView     * infoTV;
@property (nonatomic, copy  ) BlockPVoid      closeBlock;

@property (nonatomic, strong) AlertBubbleView * alertBubbleView;
@property (nonatomic, strong) UITableView     * alertBubbleTV;
@property (nonatomic, strong) UIColor         * alertBubbleTVColor;

// inject : 外部注入的
@property (nonatomic, weak  ) NSMutableArray<PnrVCEntity *> * weakInfoArray;

@end

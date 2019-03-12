//
//  PnrListVCProtocol.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import "PnrEntity.h"
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
@property (nonatomic, strong) UIButton        * serverBT;
@property (nonatomic, copy  ) BlockPVoid      closeBlock;

@property (nonatomic, strong) AlertBubbleView * alertBubbleView;
@property (nonatomic, strong) UITableView     * alertBubbleTV;
@property (nonatomic, strong) UIColor         * alertBubbleTVColor;

// inject : 外部注入的
@property (nonatomic, weak  ) NSMutableArray<PnrEntity *> * weakInfoArray;

@end


// 数据来源
@protocol PnrListVCDataSource <NSObject>

@end


// UI事件
@protocol PnrListVCEventHandler <NSObject>

- (void)closeAction;
- (void)clearAction;
- (void)updateServerBT;

- (void)editPortAction;

- (void)setRightBarAction;
- (void)setTextColorAction:(UIBarButtonItem *)sender event:(UIEvent *)event;

@end

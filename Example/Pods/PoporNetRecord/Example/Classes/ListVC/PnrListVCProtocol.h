//
//  PnrListVCProtocol.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import "PnrEntity.h"
#import "PnrCellEntity.h"
#import <PoporFoundation/Block+pPrefix.h>
#import <PoporAlertBubbleView/AlertBubbleView.h>
#import "PnrPrefix.h"

// 对外接口
@protocol PnrListVCProtocol <NSObject>

- (UIViewController *)vc;

// self   : 自己的
@property (nonatomic, strong) UITableView     * infoTV;
@property (nonatomic, strong) UIButton        * serverBT;
@property (nonatomic, copy  ) BlockPVoid      closeBlock;

@property (nonatomic, strong) AlertBubbleView * alertBubbleView;
@property (nonatomic, strong) UITableView     * alertBubbleTV;
@property (nonatomic, strong) UIColor         * alertBubbleTVColor;
@property (nonatomic, strong) NSArray         * rightBarArray;
// inject : 外部注入的
@property (nonatomic, weak  ) NSMutableArray<PnrEntity *> * weakInfoArray;
@property (nonatomic, copy  ) PnrBlockPPnrEntity blockExtraRecord; // 转发完成之后的回调

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

@end

//
//  PnrMessageVCProtocol.h
//  PoporNetRecord
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 wangkq. All rights reserved.

#import <UIKit/UIKit.h>
#import "PnrPrefix.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: 对外接口
@protocol PnrMessageVCProtocol <NSObject>

- (UIViewController *)vc;

// MARK: 自己的
@property (nonatomic, strong) UITextView * textTV;
@property (nonatomic, strong) UIButton   * sendBT;

// MARK: 外部注入的
@property (nonatomic, copy  ) PnrBlockPPnrEntity blockExtraRecord; // 转发完成之后的回调

@end

// MARK: 数据来源
@protocol PnrMessageVCDataSource <NSObject>

@end

// MARK: UI事件
@protocol PnrMessageVCEventHandler <NSObject>

- (void)sendAction;

@end

NS_ASSUME_NONNULL_END

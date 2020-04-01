//
//  PnrExtraVCProtocol.h
//  PoporNetRecord
//
//  Created by apple on 2019/11/16.
//  Copyright © 2019 wangkq. All rights reserved.

#import <UIKit/UIKit.h>
#import <PoporFoundation/Color+pPrefix.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: 对外接口
@protocol PnrExtraVCProtocol <NSObject>

- (UIViewController *)vc;

// MARK: 自己的
@property (nonatomic, strong) UITableView * infoTV;
@property (nonatomic, strong) UIButton * serverBT;

// MARK: 外部注入的

@end

// MARK: 数据来源
@protocol PnrExtraVCDataSource <NSObject>

@end

// MARK: UI事件
@protocol PnrExtraVCEventHandler <NSObject>

- (void)addUrlPortAction;
- (void)forwardAction;

@end

NS_ASSUME_NONNULL_END

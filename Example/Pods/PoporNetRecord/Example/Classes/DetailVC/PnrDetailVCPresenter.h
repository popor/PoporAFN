//
//  PnrDetailVCPresenter.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import "PnrDetailVCProtocol.h"

// 处理和View事件
@interface PnrDetailVCPresenter : NSObject <PnrDetailVCEventHandler, PnrDetailVCDataSource, UITableViewDelegate, UITableViewDataSource>

// 初始化数据处理
- (void)setMyInteractor:(id)interactor;

// 很多操作,需要在设置了view之后才可以执行.
- (void)setMyView:(id)view;

@end

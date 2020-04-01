//
//  PnrExtraVCPresenter.h
//  PoporNetRecord
//
//  Created by apple on 2019/11/16.
//  Copyright © 2019 wangkq. All rights reserved.

#import <Foundation/Foundation.h>
#import "PnrExtraVCProtocol.h"

// 处理和View事件
@interface PnrExtraVCPresenter : NSObject <PnrExtraVCEventHandler, PnrExtraVCDataSource, UITableViewDelegate, UITableViewDataSource>

- (void)setMyInteractor:(id)interactor;

- (void)setMyView:(id)view;

// 开始执行事件,比如获取网络数据
- (void)startEvent;

@end

//
//  PnrDetailVCPresenter.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import "PnrDetailVCEventHandler.h"
#import "PnrDetailVCDataSource.h"

// 处理和View事件
@interface PnrDetailVCPresenter : NSObject <PnrDetailVCEventHandler, PnrDetailVCDataSource, UITableViewDelegate, UITableViewDataSource>

- (void)setMyView:(id)view;
- (void)initInteractors;

@end

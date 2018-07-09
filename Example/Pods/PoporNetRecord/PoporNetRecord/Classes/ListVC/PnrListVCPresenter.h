//
//  PnrListVCPresenter.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import "PnrListVCEventHandler.h"
#import "PnrListVCDataSource.h"

// 处理和View事件
@interface PnrListVCPresenter : NSObject <PnrListVCEventHandler, PnrListVCDataSource, UITableViewDelegate, UITableViewDataSource>

- (void)setMyView:(id)view;
- (void)initInteractors;

@end

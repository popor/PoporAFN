//
//  PnrListVCEventHandler.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>

// UI事件
@protocol PnrListVCEventHandler <NSObject>

- (void)closeAction;
- (void)clearAction;

@end

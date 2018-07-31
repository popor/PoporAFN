//
//  PnrListVCProtocol.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import "PnrVCEntity.h"
#import <PoporFoundation/PrefixBlock.h>

// 对外接口
@protocol PnrListVCProtocol <NSObject>

- (UIViewController *)vc;
- (void)setMyPresent:(id)present;

// self   : 自己的
@property (nonatomic, strong) UITableView * infoTV;
@property (nonatomic, copy  ) BlockPVoid closeBlock;

// inject : 外部注入的
@property (nonatomic, weak  ) NSMutableArray<PnrVCEntity *> * weakInfoArray;

@end

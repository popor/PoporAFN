//
//  PnrDetailVCProtocol.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>

// 对外接口
@protocol PnrDetailVCProtocol <NSObject>

- (UIViewController *)vc;
- (void)setMyPresent:(id)present;

// self   : 自己的
@property (nonatomic, strong) UITableView * infoTV;
@property (nonatomic        ) int selectRow;
@property (nonatomic, strong) UIMenuController * menu;

// inject : 外部注入的
@property (nonatomic, strong) NSArray * jsonArray;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * cellAttArray;

@end

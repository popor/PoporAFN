//
//  PnrDetailVC.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import <UIKit/UIKit.h>
#import "PnrDetailVCEventHandler.h"
#import "PnrDetailVCDataSource.h"
#import "PnrDetailVCProtocol.h"

@interface PnrDetailVC : UIViewController <PnrDetailVCProtocol>

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

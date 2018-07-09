//
//  PnrListVC.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import <UIKit/UIKit.h>
#import "PnrListVCEventHandler.h"
#import "PnrListVCDataSource.h"
#import "PnrListVCProtocol.h"

@interface PnrListVC : UIViewController <PnrListVCProtocol>

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

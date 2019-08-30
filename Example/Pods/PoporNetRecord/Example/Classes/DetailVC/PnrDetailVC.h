//
//  PnrDetailVC.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import <UIKit/UIKit.h>
#import "PnrDetailVCProtocol.h"

@interface PnrDetailVC : UIViewController <PnrDetailVCProtocol>

- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)addViews;

@end

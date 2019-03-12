//
//  PnrDetailVCRouter.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import "PnrDetailVCRouter.h"
#import "PnrDetailVCPresenter.h"
#import "PnrDetailVC.h"

@implementation PnrDetailVCRouter

+ (UIViewController *)vcWithDic:(NSDictionary *)dic {
    PnrDetailVC * vc = [[PnrDetailVC alloc] initWithDic:dic];
    PnrDetailVCPresenter * present = [PnrDetailVCPresenter new];
    
    [vc setMyPresent:present];
    [present setMyView:vc];
    
    return vc;
}

+ (void)setVCPresent:(UIViewController *)vc {
    if ([vc isKindOfClass:[PnrDetailVC class]]) {
        PnrDetailVC * oneVC = (PnrDetailVC *)vc;
        PnrDetailVCPresenter * present = [PnrDetailVCPresenter new];
        
        [oneVC setMyPresent:present];
        [present setMyView:oneVC];
    }
}

@end

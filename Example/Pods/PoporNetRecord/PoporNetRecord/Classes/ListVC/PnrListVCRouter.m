//
//  PnrListVCRouter.m
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import "PnrListVCRouter.h"
#import "PnrListVCPresenter.h"
#import "PnrListVC.h"

@implementation PnrListVCRouter

+ (UIViewController *)vcWithDic:(NSDictionary *)dic {
    PnrListVC * vc = [[PnrListVC alloc] initWithDic:dic];
    PnrListVCPresenter * present = [PnrListVCPresenter new];
    
    [vc setMyPresent:present];
    [present setMyView:vc];
    
    return vc;
}

+ (void)setVCPresent:(UIViewController *)vc {
    if ([vc isKindOfClass:[PnrListVC class]]) {
        PnrListVC * oneVC = (PnrListVC *)vc;
        PnrListVCPresenter * present = [PnrListVCPresenter new];
        
        [oneVC setMyPresent:present];
        [present setMyView:oneVC];
    }
}

@end

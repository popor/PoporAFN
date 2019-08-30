//
//  PnrView.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PnrPrefix.h"
#import "PnrConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface PnrView : NSObject

@property (nonatomic, weak  ) PnrConfig * config;

@property (nonatomic, weak  ) UIWindow * window;
@property (nonatomic, strong) UIButton * ballBT;

@property (nonatomic        ) CGFloat sBallHideWidth;
@property (nonatomic        ) CGFloat sBallWidth;
@property (nonatomic, weak  ) NSMutableArray * infoArray; // 来自PoporNetRecord.h

@property (nonatomic, weak  ) UINavigationController * nc;
@property (nonatomic, copy  ) PnrBlockPVoid openBlock;
@property (nonatomic, copy  ) PnrBlockPVoid closeBlock;

+ (instancetype)share;

- (void)addViews;

// 弹出请求列表 UINavigationController
- (void)showPnrListVCNC;

// 获取VC,可以设置在自定义 UINavigationController 中
- (UIViewController *)getPnrListVC;

// 把ballBT提到最高层.
+ (void)bringFrontBallBT;

@end

NS_ASSUME_NONNULL_END


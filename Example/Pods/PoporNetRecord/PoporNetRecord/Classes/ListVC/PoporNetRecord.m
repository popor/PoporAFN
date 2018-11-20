//
//  NetMonitorTool.m
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PoporNetRecord.h"
#import "PnrVCEntity.h"

#import "PnrListVCRouter.h"
#import <PoporUI/UIView+Extension.h>
#import <PoporFoundation/PrefixFun.h>
#import <PoporFoundation/NSDate+Tool.h>
#import <JSONSyntaxHighlight/JSONSyntaxHighlight.h>

#define LL_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define LL_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface PoporNetRecord () <UIGestureRecognizerDelegate>

@end

@implementation PoporNetRecord

+ (instancetype)share {
    static dispatch_once_t once;
    static PoporNetRecord * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        instance.sBallHideWidth = 10;
        instance.sBallWidth     = 80;
        instance.infoArray      = [NSMutableArray new];
        
        {
            instance.config = [PoporNetRecordConfig share];
            __weak typeof(instance) weakSelf = instance;
            instance.config.recordTypeBlock = ^(PoporNetRecordType type) {
                [weakSelf setRecordType:type];
            };
            instance.config.recordTypeBlock(instance.config.recordType);
        }
    });
    return instance;
}

+ (void)addUrl:(NSString *)urlString method:(NSString *)method head:(NSDictionary *)headDic request:(NSDictionary *)requestDic response:(NSDictionary *)responseDic {
    if ([PoporNetRecord share].isShow) {
        PnrVCEntity * entity = [PnrVCEntity new];
        entity.url = urlString;
        if (urlString.length>0) {
            NSURL * url = [NSURL URLWithString:urlString];
            entity.domain = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
            if (entity.domain.length < urlString.length) {
                entity.request = [urlString substringFromIndex:entity.domain.length];
            }
        }
        
        entity.method      = method;
        entity.headDic     = headDic;
        entity.requestDic  = requestDic;
        entity.responseDic = responseDic;
        entity.time = [NSDate stringFromDate:[NSDate date] formatter:@"HH:mm:ss"];
        if ([PoporNetRecord share].infoArray.count >= [PoporNetRecord share].config.recordMaxNum) {
            [[PoporNetRecord share].infoArray removeLastObject];
        }
        [[PoporNetRecord share].infoArray insertObject:entity atIndex:0];
        
        if ([PoporNetRecord share].config.freshBlock) {
            [PoporNetRecord share].config.freshBlock();
        }
    }
}

- (void)addViews {
    if (self.window) {
        return;
    }
    self.window = [[UIApplication sharedApplication] keyWindow];
    self.ballBT = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =  CGRectMake(0, 0, self.sBallWidth, self.sBallWidth);
        [button setTitle:@"网络请求" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor brownColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        button.layer.cornerRadius = button.frame.size.width/2;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1;
        button.clipsToBounds = YES;
        
        [self.window addSubview:button];
        
        [button addTarget:self action:@selector(showPnrListVC) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    NSString * pointString = [self getBallPoint];
    if (pointString) {
        self.ballBT.center = CGPointFromString(pointString);
    }else{
        self.ballBT.center = CGPointMake(self.ballBT.width/2- self.sBallHideWidth, 180);
    }
    self.ballBT.alpha = self.config.normalAlpha;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    [self.ballBT addGestureRecognizer:pan];
}

- (void)showPnrListVC {
    self.ballBT.hidden = YES;
    __weak typeof(self) weakSelf = self;
    BlockPVoid closeBlock = ^() {
        if (weakSelf.isShow) {
            weakSelf.ballBT.hidden = NO;
        }
        if (weakSelf.closeBlock) {
            weakSelf.closeBlock();
        }
    };
    UIViewController * vc = [PnrListVCRouter vcWithDic:@{@"title":@"网络请求", @"weakInfoArray":self.infoArray, @"closeBlock":closeBlock}];
    UINavigationController * oneNC = [[UINavigationController alloc] initWithRootViewController:vc];
    if (self.config.presentNCBlock) {
        self.config.presentNCBlock(oneNC);
    }
    if (self.window.rootViewController.presentationController
        && self.window.rootViewController.presentedViewController) {
        [self.window.rootViewController.presentedViewController presentViewController:oneNC animated:YES completion:nil];
    }else{
        [self.window.rootViewController presentViewController:oneNC animated:YES completion:nil];
    }
    oneNC.interactivePopGestureRecognizer.delegate = self;
    
    // 打开block事件
    if (self.openBlock) {
        self.openBlock();
    }
    self.nc = oneNC;
}

#pragma mark - Action
// 侧滑返回判断
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.nc.interactivePopGestureRecognizer) {
        if (self.nc.viewControllers.count == 1) {
            [self.nc dismissViewControllerAnimated:YES completion:nil];
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}

// 球移动轨迹
- (void)panGR:(UIPanGestureRecognizer *)gr {
    CGPoint panPoint = [gr locationInView:[[UIApplication sharedApplication] keyWindow]];
    //NSLog(@"panPoint: %f-%f", panPoint.x, panPoint.y);
    if (gr.state == UIGestureRecognizerStateBegan) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resignActive) object:nil];
        [self becomeActive];
    } else if (gr.state == UIGestureRecognizerStateChanged) {
        [self changeSBallViewFrameWithPoint:panPoint];
    } else if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled || gr.state == UIGestureRecognizerStateFailed) {
        [self resignActive];
    }
}

- (void)becomeActive {
    self.ballBT.alpha = self.config.activeAlpha;
}

- (void)resignActive {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.ballBT.alpha = self.config.normalAlpha;
        // Calculate End Point
        CGFloat x = self.ballBT.center.x;
        CGFloat y = self.ballBT.center.y;
        CGFloat x1 = LL_SCREEN_WIDTH / 2.0;
        CGFloat y1 = LL_SCREEN_HEIGHT / 2.0;
        
        CGFloat distanceX = x1 > x ? x : LL_SCREEN_WIDTH - x;
        CGFloat distanceY = y1 > y ? y : LL_SCREEN_HEIGHT - y;
        CGPoint endPoint = CGPointZero;
        
        if (distanceX <= distanceY) {
            // animation to left or right
            endPoint.y = y;
            if (x1 < x) {
                // to right
                endPoint.x = LL_SCREEN_WIDTH - self.ballBT.frame.size.width / 2.0 + self.sBallHideWidth;
            } else {
                // to left
                endPoint.x = self.ballBT.frame.size.width / 2.0 - self.sBallHideWidth;
            }
        } else {
            // animation to top or bottom
            endPoint.x = x;
            if (y1 < y) {
                // to bottom
                endPoint.y = LL_SCREEN_HEIGHT - self.ballBT.frame.size.height / 2.0 + self.sBallHideWidth;
            } else {
                // to top
                endPoint.y = self.ballBT.frame.size.height / 2.0 - self.sBallHideWidth;
            }
        }
        self.ballBT.center = endPoint;
        
        [self saveBallPoint:NSStringFromCGPoint(endPoint)];
    } completion:nil];
}

- (void)changeSBallViewFrameWithPoint:(CGPoint)point {
    self.ballBT.center = CGPointMake(point.x, point.y);
}

#pragma mark - 记录按钮位置
- (void)saveBallPoint:(NSString *)BallPoint {
    [[NSUserDefaults standardUserDefaults] setObject:BallPoint forKey:@"BallPoint"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getBallPoint {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:@"BallPoint"];
    return info;
}

// 开关
- (void)setRecordType:(PoporNetRecordType)recordType {
    switch (recordType) {
        case PoporNetRecordAuto:
#if TARGET_IPHONE_SIMULATOR
            _show = YES;
#else
            if (IsDebugVersion) {
                _show = YES;
            }else{
                _show = NO;
            }
#endif
            break;
        case PoporNetRecordEnable:
            _show = YES;
            break;
            
        case PoporNetRecordDisable:
            _show = NO;
            break;
            
        default:
            break;
    }
    if (_show) {
        if (!_window) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addViews];
            });
        }
        _ballBT.hidden = NO;
    }else{
        _ballBT.hidden = YES;
    }
    
    
}
// 把ballBT提到最高层.
+ (void)bringFrontBallBT {
    PoporNetRecord * pnr = [PoporNetRecord share];
    [pnr.window bringSubviewToFront:pnr.ballBT];
}
@end

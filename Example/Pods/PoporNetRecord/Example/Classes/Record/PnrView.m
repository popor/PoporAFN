//
//  PnrView.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PnrView.h"
#import "PnrEntity.h"
#import "PnrWebServer.h"
#import "PoporNetRecord.h"

#import "PnrListVC.h"
#import <PoporUI/UIView+pExtension.h>
#import <PoporUI/UIDevice+pScreenSize.h>
#import <PoporFoundation/Fun+pPrefix.h>
#import <PoporFoundation/NSDate+pTool.h>
#import <JSONSyntaxHighlight/JSONSyntaxHighlight.h>

#define LL_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define LL_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface PnrView () <UIGestureRecognizerDelegate>

@property (nonatomic, getter=isIphoneX) BOOL iphoneX;
@property (nonatomic        ) int screenWidth;
@property (nonatomic        ) int screenHeight;

@end

@implementation PnrView

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrView * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _sBallHideWidth      = 10;
        _sBallWidth          = 80;
        _iphoneX             = [UIDevice isIphoneXScreen];
        _autoFixIphoneXFrame = YES;
        _config              = [PnrConfig share];
        _screenWidth         = LL_SCREEN_WIDTH;
        _screenHeight        = LL_SCREEN_HEIGHT;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addViews];
        });
    }
    return self;
}

- (void)addViews {
    if (self.window && self.ballBT) {
        return;
    }
    self.window = [[UIApplication sharedApplication] keyWindow];
    if (self.window) {
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
            
            [button addTarget:self action:@selector(showPnrListVCNC) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
        
        if (self.viewDidloadBlock) {
            self.viewDidloadBlock();
        }
        
        NSString * pointString = [self getBallPoint];
        if (pointString) {
            self.ballBT.center = CGPointFromString(pointString);
        }else{
            self.ballBT.center = CGPointMake(self.ballBT.width/2- self.sBallHideWidth, 180);
        }
        
        if (self.config.isRecord) {
            [self addViews];
            if (self.config.isCustomBallBtVisible) {
                self.ballBT.hidden = YES;
            }else{
                self.ballBT.hidden = NO;
                self.ballBT.alpha  = self.config.normalAlpha;
            }
        }else{
            // 默认设置的是隐藏,假如设置的时候,不允许recorde,那么设置为隐藏
            self.ballBT.hidden = YES;
        }
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
        [self.ballBT addGestureRecognizer:pan];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addViews];
        });
    }
}

- (void)showPnrListVCNC {
    if (!self.config.isCustomBallBtVisible) {
        self.ballBT.hidden = YES;
    }
    UINavigationController * oneNC = [[UINavigationController alloc] initWithRootViewController:[self getPnrListVC]];
    oneNC.navigationBar.translucent = NO;
    
    if (self.config.presentNCBlock) {
        self.config.presentNCBlock(oneNC);
    }
    if (self.window.rootViewController.presentationController && self.window.rootViewController.presentedViewController) {
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

- (UIViewController *)getPnrListVC {
    __weak typeof(self) weakSelf = self;
    
    BlockPVoid closeBlock = ^() {
        if (weakSelf.config.isRecord) {
            if (!weakSelf.config.isCustomBallBtVisible) {
                weakSelf.ballBT.hidden = NO;
            }
        }
        if (weakSelf.closeBlock) {
            weakSelf.closeBlock();
        }
    };
    PoporNetRecord * pnr  = [PoporNetRecord share];
    UIViewController * vc = [[PnrListVC alloc] initWithDic:@{@"title":self.config.vcRootTitle, @"weakInfoArray":self.infoArray, @"closeBlock":closeBlock, @"blockExtraRecord":pnr.blockExtraRecord}];
    
    return vc;
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
        self.ballBT.alpha  = self.config.normalAlpha;
        self.ballBT.center = [self fixIphoneXCenter];
    } completion:^(BOOL finished) {
        [self saveBallPoint:NSStringFromCGPoint(self.ballBT.center)];
        //NSLog(@"__frame:%@ center:%@", NSStringFromCGRect(self.ballBT.frame), NSStringFromCGPoint(self.ballBT.center));
    }];
}

- (void)changeSBallViewFrameWithPoint:(CGPoint)point {
    self.ballBT.center = CGPointMake(point.x, point.y);
}

// 获取到对应的center
- (CGPoint)fixIphoneXCenter {
    
    CGFloat x         = self.ballBT.center.x;
    CGFloat y         = self.ballBT.center.y;
    CGFloat x1        = self.screenWidth / 2.0;
    CGFloat y1        = self.screenHeight / 2.0;
    CGFloat Width     = self.ballBT.frame.size.width;
    CGFloat Height    = self.ballBT.frame.size.height;
    
    if (self.isIphoneX && self.autoFixIphoneXFrame) {
        if (y < 60) {
            y = 60;
            if (x <= x1) {
                x = Width / 2.0 - self.sBallHideWidth;
            } else {
                x = self.screenWidth - Width / 2.0 + self.sBallHideWidth;;
            }
        }
    }
    
    CGFloat distanceX = x1 > x ? x : self.screenWidth - x;
    CGFloat distanceY = y1 > y ? y : self.screenHeight - y;
    CGPoint endPoint  = CGPointZero;
    
    if (distanceX <= distanceY) {
        // animation to left or right
        endPoint.y = y;
        if (x1 < x) {
            // to right
            endPoint.x = self.screenWidth - Width / 2.0 + self.sBallHideWidth;
        } else {
            // to left
            endPoint.x = Width / 2.0 - self.sBallHideWidth;
        }
    } else {
        // animation to top or bottom
        endPoint.x = x;
        if (y1 < y) {
            // to bottom
            endPoint.y = self.screenHeight - Height / 2.0 + self.sBallHideWidth;
        } else {
            // to top
            endPoint.y = Height / 2.0 - self.sBallHideWidth;
        }
    }
  
    return endPoint;
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

// 把ballBT提到最高层.
+ (void)bringFrontBallBT {
    PnrView * pnrView = [PnrView share];
    [pnrView.window bringSubviewToFront:pnrView.ballBT];
}

@end

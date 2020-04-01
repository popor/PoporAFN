//
//  PnrUITool.m
//  PoporNetRecord_Example
//
//  Created by apple on 2019/11/18.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import "PnrUITool.h"

@implementation PnrUITool

+ (int)fetchTopMargin:(UINavigationController *)nc {
    int top;
    if (nc.navigationBar.translucent) {
        if (@available(iOS 11.0, *)) {
            UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
            if (mainWindow.safeAreaInsets.top > 20.0) {
                top = nc.navigationBar.frame.size.height + mainWindow.safeAreaInsets.top;
            }else{
                top = 64;
            }
            
        }else{
            top = 64;
        }
    }else{
        top = 0;
    }
    return top;
}

@end

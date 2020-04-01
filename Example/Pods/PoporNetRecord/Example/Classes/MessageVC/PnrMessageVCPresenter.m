//
//  PnrMessageVCPresenter.m
//  PoporNetRecord
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 wangkq. All rights reserved.

#import "PnrMessageVCPresenter.h"
#import "PnrMessageVCInteractor.h"

#import "PnrEntity.h"
#import <PoporFoundation/NSDate+pTool.h>
#import <PoporUI/IToastPTool.h>

@interface PnrMessageVCPresenter ()

@property (nonatomic, weak  ) id<PnrMessageVCProtocol> view;
@property (nonatomic, strong) PnrMessageVCInteractor * interactor;

@end

@implementation PnrMessageVCPresenter

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setMyInteractor:(PnrMessageVCInteractor *)interactor {
    self.interactor = interactor;
    
}

- (void)setMyView:(id<PnrMessageVCProtocol>)view {
    self.view = view;
    
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    
    
}

#pragma mark - VC_DataSource

#pragma mark - VC_EventHandler
- (void)sendAction {
    if (self.view.blockExtraRecord) {
        PnrEntity * pnrEntity = [PnrEntity new];
        pnrEntity.title = @"转发文本";
        pnrEntity.time  = [NSDate stringFromDate:[NSDate date] formatter:@"HH:mm:ss"];
        pnrEntity.log = self.view.textTV.text;
        pnrEntity.deviceName = [[UIDevice currentDevice] name];;
        self.view.blockExtraRecord(pnrEntity);
        
        AlertToastTitle(@"已转发");
    }
    
}

#pragma mark - Interactor_EventHandler

@end

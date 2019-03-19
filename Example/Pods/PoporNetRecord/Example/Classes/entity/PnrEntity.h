//
//  PnrEntity.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PnrEntityBlock) (NSArray *titleArray, NSArray *jsonArray, NSMutableArray *cellAttArray);

static NSString * PnrRootTitle0     = @"名称:  ";
static NSString * PnrRootPath1      = @"接口:  ";
static NSString * PnrRootUrl2       = @"链接:  ";
static NSString * PnrRootTime3      = @"时间:  ";
static NSString * PnrRootMethod4    = @"方法:  ";
static NSString * PnrRootHead5      = @"head参数:  ";
static NSString * PnrRootParameter6 = @"请求参数:  ";
static NSString * PnrRootResponse7  = @"返回数据:  ";
static NSString * PnrRootExtra8     = @"额外参数:  ";

static int PnrListHeight            = 50;
static NSString * PnrIframeList     = @"IframeList";
static NSString * PnrIframeDetail   = @"IframeDetail";
static NSString * PnrIframeFeedback = @"IframeFeedback";

static NSString * PnrFormResubmit   = @"formResubmit";


static NSString * PnrPathList      = @"list";
static NSString * PnrPathDetail    = @"detail";
static NSString * PnrPathEdit      = @"edit";
static NSString * PnrPathResubmit  = @"resubmit";

static NSString * PnrKeyConent     = @"content";
// post 查看json等
static NSString * PnrPathJsonXml   = @"jsonXml";
static NSString * PnrPathHead      = @"head";
static NSString * PnrPathParameter = @"parameter";
static NSString * PnrPathResponse  = @"response";

static NSString * PnrClassTaAutoH  = @"TaAutoH";



@interface PnrEntity : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * domain;
@property (nonatomic, strong) NSString * path;
@property (nonatomic, strong) NSString * method;// post get

@property (nonatomic, strong) id       headValue;
@property (nonatomic, strong) id       parameterValue;
@property (nonatomic, strong) id       responseValue;

@property (nonatomic, strong) NSString * time;

@property (nonatomic, strong) NSString * listWebH5; // 列表网页html5代码

//@property (nonatomic        ) float cellH;

- (void)createListWebH5:(NSInteger)index;

- (NSArray *)titleArray;
- (NSArray *)jsonArray;

- (void)getJsonArrayBlock:(PnrEntityBlock)finish;

@end

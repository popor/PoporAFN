//
//  PnrEntity.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PnrEntityBlock) (NSArray *titleArray, NSArray *jsonArray, NSMutableArray *cellAttArray);

static NSString * PnrRootPath1      = @"路径:";
static NSString * PnrRootUrl1       = @"链接:";
static NSString * PnrRootTime2      = @"时间:";
static NSString * PnrRootMethod3    = @"方法:";
static NSString * PnrRootHead4      = @"head参数:";
static NSString * PnrRootParameter5 = @"请求参数:";
static NSString * PnrRootResponse6  = @"返回数据:";

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

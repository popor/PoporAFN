//
//  PnrServerTool.h
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import <Foundation/Foundation.h>
#import <GCDWebServer/GCDWebServer.h>
#import "PnrPortEntity.h"
#import "PnrEntity.h"
#import "PnrPrefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface PnrServerTool : NSObject

+ (instancetype)share;

@property (nonatomic, weak  ) PnrPortEntity * portEntity;
@property (nonatomic, weak  ) NSMutableArray * infoArray; // PoporNetRecord.infoArray
@property (nonatomic, strong) NSMutableString * h5List;
@property (nonatomic        ) NSInteger lastIndex;

#pragma mark - server
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * jsonArray;

@property (nonatomic, strong, nullable) GCDWebServer * webServer;

@property (nonatomic, copy  ) PnrResubmitBlock resubmitBlock;
@property (nonatomic, strong) NSDictionary * resubmitExtraDic;

- (void)startListServer:(NSMutableString *)listBodyH5;
- (void)stopServer;

- (void)clearListWeb;

@end

NS_ASSUME_NONNULL_END

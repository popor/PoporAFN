//
//  PnrWebPortEntity.h
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import <Foundation/Foundation.h>
#import <GCDWebServer/GCDWebServer.h>

NS_ASSUME_NONNULL_BEGIN

static int PnrPortGet  = 8080;
//static int PnrPortPost = 8081;

@interface PnrPortEntity : NSObject

@property (nonatomic        ) int portGetInt;
//@property (nonatomic        ) int portPostInt;
+ (instancetype)share;

#pragma mark - plist
+ (void)savePort_get:(int)port;
+ (int)getPort_get;
//+ (void)savePort_post:(int)port;
//+ (int)getPort_post;

@end

NS_ASSUME_NONNULL_END

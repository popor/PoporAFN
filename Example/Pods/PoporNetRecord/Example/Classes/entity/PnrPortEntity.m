//
//  PnrPortEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import "PnrPortEntity.h"

static NSString * PoporNetRecord_port_get  = @"PoporNetRecord_port_get";
//static NSString * PoporNetRecord_port_post = @"PoporNetRecord_port_post";

@implementation PnrPortEntity

+ (instancetype)share {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        [self initPort];
    }
    return self;
}

- (void)initPort {
    int portGet  = [PnrPortEntity getPort_get];
    if (portGet != 0) {
        self.portGetInt  = portGet;
    }else{
        self.portGetInt  = PnrPortGet;
        [PnrPortEntity savePort_get:PnrPortGet];
    }
    //    int portGet  = [PnrPortEntity getPort_get];
    //    int portPost = [PnrPortEntity getPort_post];
    //    
    //    if (portGet != portPost) {
    //        self.portGetInt  = portGet;
    //        self.portPostInt = portPost;
    //    }else{
    //        self.portGetInt  = PnrPortGet;
    //        self.portPostInt = PnrPortPost;
    //        [PnrPortEntity savePort_get:PnrPortGet];
    //        [PnrPortEntity savePort_post:PnrPortPost];
    //    }
}

#pragma mark - plist
+ (void)savePort_get:(int)port {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", port] forKey:PoporNetRecord_port_get];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)getPort_get {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_port_get];
    return info.intValue;
}

//+ (void)savePort_post:(int)port {
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", port] forKey:PoporNetRecord_port_post];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (int)getPort_post {
//    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_port_post];
//    return info.intValue;
//}

@end

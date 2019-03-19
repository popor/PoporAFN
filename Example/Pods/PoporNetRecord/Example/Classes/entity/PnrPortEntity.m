//
//  PnrPortEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import "PnrPortEntity.h"

static NSString * PoporNetRecord_port_get  = @"PoporNetRecord_port_get";

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

@end

//
//  PnrWebPortEntity.m
//  GCDWebServer
//
//  Created by apple on 2018/12/18.
//

#import "PnrWebPortEntity.h"

#import <PoporUI/IToastKeyboard.h>

#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import <PoporFoundation/NSDictionary+tool.h>

static NSString * PoporNetRecord_allPort      = @"PoporNetRecord_allPort";
static NSString * PoporNetRecord_headPort     = @"PoporNetRecord_headPort";
static NSString * PoporNetRecord_requestPort  = @"PoporNetRecord_requestPort";
static NSString * PoporNetRecord_responsePort = @"PoporNetRecord_responsePort";

static NSString * PoporNetRecord_JsonWindow   = @"PoporNetRecord_JsonWindow";
static NSString * PoporNetRecord_DetailVCStartServer = @"PoporNetRecord_DetailVCStartServer";


@interface PnrWebPortEntity ()

@property (nonatomic, getter=isRun) BOOL run;

@end

@implementation PnrWebPortEntity

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
    //------- 端口号
    NSString * allPortString      = [PnrWebPortEntity getAllPort];
    NSString * headString         = [PnrWebPortEntity getHeadPort];
    NSString * requestString      = [PnrWebPortEntity getRequestPort];
    NSString * responsePortString = [PnrWebPortEntity getResponsePort];
    
    if (allPortString && allPortString.length>0) {
        self.allPortInt = [allPortString intValue];
    }else{
        self.allPortInt = PoporNetRecordAllPort;
    }
    
    if (headString && headString.length>0) {
        self.headPortInt = [headString intValue];
    }else{
        self.headPortInt = PoporNetRecordHeadPort;
    }
    
    if (requestString && requestString.length>0) {
        self.requestPortInt = [requestString intValue];
    }else{
        self.requestPortInt = PoporNetRecordRequestPort;
    }
    
    if (responsePortString && responsePortString.length>0) {
        self.responsePortInt = [responsePortString intValue];
    }else{
        self.responsePortInt = PoporNetRecordResponsePort;
    }
    
    // 判断
    NSMutableSet * set = [NSMutableSet new];
    [set addObject:[NSString stringWithFormat:@"%i", self.allPortInt]];
    [set addObject:[NSString stringWithFormat:@"%i", self.headPortInt]];
    [set addObject:[NSString stringWithFormat:@"%i", self.requestPortInt]];
    [set addObject:[NSString stringWithFormat:@"%i", self.responsePortInt]];
    if (set.count != 4) {
        AlertToastTitle(@"端口号有重复,请检查!");
        self.allPortInt      = PoporNetRecordAllPort;
        self.headPortInt     = PoporNetRecordHeadPort;
        self.requestPortInt  = PoporNetRecordRequestPort;
        self.responsePortInt = PoporNetRecordResponsePort;
    }
    
    //------- 开关
    self.jsonWindow          = [PnrWebPortEntity getJsonWindow];
    self.detailVCStartServer = [PnrWebPortEntity getDetailVCStartServer];
    
    
    //-------
}

#pragma mark - server
- (void)startServerTitle:(NSArray *)titleArray json:(NSArray *)jsonArray {
    if (!self.isRun) {
        if (titleArray.count == jsonArray.count) {
            self.run        = YES;
            self.titleArray = titleArray;
            self.jsonArray  = jsonArray;
            
            [self addServer];
        }else{
            AlertToastTitle(@"无法开启服务，titleArray与jsonArray数组不一致");
        }
    }
}

- (void)addServer {
    
    NSMutableArray * webServerArray = [NSMutableArray new];
    [webServerArray addObjectsFromArray:@[[NSNull null], [NSNull null], [NSNull null], [NSNull null]]];
    
    self.webServerHead     = [self addIndex:4 port:self.headPortInt array:webServerArray];
    self.webServerRequest  = [self addIndex:5 port:self.requestPortInt array:webServerArray];
    self.webServerResponse = [self addIndex:6 port:self.responsePortInt array:webServerArray];
    
    
    NSString * target = self.jsonWindow ? @" target='_blank'" : @"";
    if (!self.webServerAll) {
        NSMutableString * h5 = [NSMutableString new];
        [h5 appendString:@"<html> <head><title>请求详情</title></head> <body><p>请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。</p>"];
        for (int i=0; i<self.titleArray.count; i++) {
            NSString * title         = self.titleArray[i];
            id content               = self.jsonArray[i];
            GCDWebServer * webServer = webServerArray[i];
            
            if ([webServer isKindOfClass:[NSNull class]]) {
                [h5 appendFormat:@"<p>%@</p>", title];
            }else{
                if ([content isKindOfClass:[NSDictionary class]]) {
                    [h5 appendFormat:@"<p><a href='%@'%@>%@</a> %@</p>", webServer.serverURL.absoluteString, target, title, [(NSDictionary *)content toJsonString]];
                }else if([content isKindOfClass:[NSString class]]) {
                    [h5 appendFormat:@"<p><a href='%@'%@>%@</a> %@</p>", webServer.serverURL.absoluteString, target, title, (NSString *)content];
                }else{
                    [h5 appendFormat:@"<p>%@ NULL</p>", title];
                }
            }
        }
        
        [h5 appendString:@"</body></html>"];
        
        GCDWebServer * server = [GCDWebServer new];
        [server addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            return [GCDWebServerDataResponse responseWithHTML:h5];
        }];
        [server startWithPort:self.allPortInt bonjourName:nil];
        NSLog(@"Visit %@ in your web browser", server.serverURL);
        
        self.webServerAll = server;
    }
}

- (GCDWebServer *)addIndex:(int)index port:(int)port array:(NSMutableArray *)array {
    NSString * title = self.titleArray[index];
    id content = self.jsonArray[index];
    if (content) {
        NSMutableString * h5 = [NSMutableString new];
        [h5 appendFormat:@"<html> <head><title>%@</title></head> <body><br/>", title];
        
        if([content isKindOfClass:[NSDictionary class]]) {
            [h5 appendFormat:@"<p>%@</p>", [(NSDictionary *)content toJsonString]];
        }else if([content isKindOfClass:[NSString class]]){
            [h5 appendFormat:@"<p>%@</p>", (NSString *)content];
        }
        
        [h5 appendString:@"</body></html>"];
        
        GCDWebServer * server = [GCDWebServer new];
        [server addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            return [GCDWebServerDataResponse responseWithHTML:h5];
        }];
        [server startWithPort:port bonjourName:nil];
        
        // 增加到数组中
        [array addObject:server];
        
        return server;
    }else{
        // 增加一个普通数组
        [array addObject:[NSNull null]];
        
        return nil;
    }
}

- (void)stopServer {
    
    [self.webServerAll      stop];
    [self.webServerHead     stop];
    [self.webServerRequest  stop];
    [self.webServerResponse stop];
    
    self.webServerAll      = nil;
    self.webServerHead     = nil;
    self.webServerRequest  = nil;
    self.webServerResponse = nil;
    
    self.run               = NO;
}

#pragma mark - plist
+ (void)saveAllPort:(NSString *)allPort {
    [[NSUserDefaults standardUserDefaults] setObject:allPort forKey:PoporNetRecord_allPort];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getAllPort {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_allPort];
    return info;
}

//
+ (void)saveHeadPort:(NSString *)headPort {
    [[NSUserDefaults standardUserDefaults] setObject:headPort forKey:PoporNetRecord_headPort];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getHeadPort {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_headPort];
    return info;
}

//
+ (void)saveRequestPort:(NSString *)requestPort {
    [[NSUserDefaults standardUserDefaults] setObject:requestPort forKey:PoporNetRecord_requestPort];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getRequestPort {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_requestPort];
    return info;
}

//
+ (void)saveResponsePort:(NSString *)responsePort {
    [[NSUserDefaults standardUserDefaults] setObject:responsePort forKey:PoporNetRecord_responsePort];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getResponsePort {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_responsePort];
    return info;
}

//
+ (void)saveJsonWindow:(BOOL)jsonWindow {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", jsonWindow] forKey:PoporNetRecord_JsonWindow];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getJsonWindow {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_JsonWindow];
    if (info) {
        return [info boolValue];
    }else{
        //[self saveJsonWindowSwitch:NO];
        return NO;
    }
}

//
+ (void)saveDetailVCStartServer:(BOOL)detailVCStartServer {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", detailVCStartServer] forKey:PoporNetRecord_DetailVCStartServer];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getDetailVCStartServer {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_DetailVCStartServer];
    if (info) {
        return [info boolValue];
    }else{
        [self saveDetailVCStartServer:YES];
        return YES;
    }
}

@end

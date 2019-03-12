//
//  PnrWebPortEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import "PnrServerTool.h"

#import "PnrEntity.h"
#import "PnrPortEntity.h"
#import "PnrConfig.h"

#import <PoporUI/IToastKeyboard.h>

#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import <GCDWebServer/GCDWebServerPrivate.h>

#import <PoporFoundation/NSDictionary+tool.h>

static NSString * ErrorUrl    = @"<html> <head><title>错误</title></head> <body><p> URL异常 </p> </body></html>";
static NSString * ErrorEntity = @"<html> <head><title>错误</title></head> <body><p> 无法找到对应请求 </p> </body></html>";
static NSString * ErrorUnknow = @"<html> <head><title>错误</title></head> <body><p> 未知bug </p> </body></html>";
static NSString * ErrorEmpty  = @"<html> <head><title>错误</title></head> <body><p> 无 </p> </body></html>";

static NSString * PnrWebCode1 = @"PnrWebCode1";

@interface PnrServerTool ()

@property (nonatomic, strong) NSString * h5Root;
@property (nonatomic, strong) NSString * h5Head;
@property (nonatomic, strong) NSString * h5Request;
@property (nonatomic, strong) NSString * h5Response;
@property (nonatomic, strong) NSString * h5Edit;

@end

@implementation PnrServerTool

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrServerTool * instance;
    dispatch_once(&once, ^{
        instance = [PnrServerTool new];
        instance.h5List     = [NSMutableString new];
        instance.lastIndex  = -1;
        [GCDWebServer setLogLevel:kGCDWebServerLoggingLevel_Error];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        self.portEntity = [PnrPortEntity share];
    }
    return self;
}

#pragma mark - list server
- (void)startListServer:(NSMutableString *)listBodyH5 {
    if (!listBodyH5) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    {
        [self.h5List setString:@""];
        [self.h5List appendString:@"<html> <head><title>网络请求</title></head> <body><p>请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。</p>"];
        [self.h5List appendString:listBodyH5];
        [self.h5List appendString:@"</body></html>"];
    }
    
    if (!self.webServer) {
        GCDWebServer * server = [GCDWebServer new];
        self.webServer = server;
        
        [self.webServer addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            NSString * path = request.URL.path;
            if (path.length>=2) {
                path = [path substringFromIndex:1];
                NSArray * pathArray = [path componentsSeparatedByString:@"/"];
                if (pathArray.count == 2) {
                    [weakSelf analysisGetIndex:[pathArray[0] integerValue] path:pathArray[1] request:request complete:completionBlock];
                }else{
                    completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
                }
            }else{
                completionBlock([GCDWebServerDataResponse responseWithHTML:weakSelf.h5List]);
            }
        }];
        
        [self.webServer addDefaultHandlerForMethod:@"POST" requestClass:[GCDWebServerURLEncodedFormRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            NSString * path = request.URL.path;
            if (path.length>=2) {
                path = [path substringFromIndex:1];
                NSArray * pathArray = [path componentsSeparatedByString:@"/"];
                if (pathArray.count == 2) {
                    [weakSelf analysisPostIndex:[pathArray[0] integerValue] path:pathArray[1] request:request complete:completionBlock];
                }else{
                    completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
                }
            }else{
                completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
            }
        }];
        
        PnrPortEntity * port = [PnrPortEntity share];
        [server startWithPort:port.portGetInt bonjourName:nil];
    }
}

// 分析 get 请求
- (void)analysisGetIndex:(NSInteger)index path:(NSString *)path request:(GCDWebServerRequest * _Nonnull)request complete:(GCDWebServerCompletionBlock  _Nonnull)complete {
    
    PnrEntity * entity;
    if (self.infoArray.count > index) {
        entity = self.infoArray[index];
    }
    //NSLog(@"index:%li, all: %li, entity:%@", index, self.infoArray.count, entity);
    if (entity) {
        if (index != self.lastIndex) {
            self.lastIndex = index;
            [self startServerUnitEntity:entity index:index];
        }
        NSString * str;
        if ([path isEqualToString:PnrPathRoot]) {
            str = self.h5Root;
        }else if ([path isEqualToString:PnrPathHead]){
            str = self.h5Head;
        }else if ([path isEqualToString:PnrPathParameter]){
            str = self.h5Request;
        }else if ([path isEqualToString:PnrPathResponse]){
            str = self.h5Response;
        }else if([path isEqualToString:PnrPathEdit]){
            str = self.h5Edit;
        }
        if (str) {
            complete([GCDWebServerDataResponse responseWithHTML:str]);
        }else{
            complete([GCDWebServerDataResponse responseWithHTML:ErrorUnknow]);
        }
        
    }else{
        complete([GCDWebServerDataResponse responseWithHTML:ErrorEntity]);
    }
}

// 分析 post 请求
- (void)analysisPostIndex:(NSInteger)index path:(NSString *)path request:(GCDWebServerRequest * _Nonnull)request complete:(GCDWebServerCompletionBlock  _Nonnull)complete {
    
    PnrEntity * entity;
    if (self.infoArray.count > index) {
        entity = self.infoArray[index];
    }
    if (entity) {
        if (index != self.lastIndex) {
            self.lastIndex = index;
            [self startServerUnitEntity:entity index:index];
        }
        NSString * str;
        if([path isEqualToString:PnrPathResubmit]){
            str = @"<html> <head><title>update</title></head> <body><p> 已经重新提交 </p> </body></html>";
            [self resubmitEntity:entity request:request];
        }
        if (str) {
            complete([GCDWebServerDataResponse responseWithHTML:str]);
        }else{
            complete([GCDWebServerDataResponse responseWithHTML:ErrorUnknow]);
        }
        
    }else{
        complete([GCDWebServerDataResponse responseWithHTML:ErrorEntity]);
    }
}

#pragma mark - server 某个单独请求
- (void)startServerUnitEntity:(PnrEntity *)pnrEntity index:(NSInteger)index {
    NSArray * titleArray = pnrEntity.titleArray;
    NSArray * jsonArray  = pnrEntity.jsonArray;
    if (titleArray.count == jsonArray.count) {
        self.titleArray         = titleArray;
        self.jsonArray          = jsonArray;
        
        PnrConfig * config      = [PnrConfig share];
        NSString * colorKey     = config.rootColorKeyHex;
        NSString * colorValue   = config.rootColorValueHex;
        
        NSString * pnrTitle     = pnrEntity.title? [NSString stringWithFormat:@"%@: ", pnrEntity.title]: @"";
        NSString * headStr      = [self contentString:pnrEntity.headValue];
        NSString * parameterStr = [self contentString:pnrEntity.parameterValue];
        NSString * responseStr  = [self contentString:pnrEntity.responseValue];
        NSString * extraStr     = self.resubmitExtraDic ? self.resubmitExtraDic.toJsonString : @"{\"extraKey\":\"extraValue\"}";
        
        {
            // 设置 h5Root
            NSMutableString * h5;
            
            h5 = [NSMutableString new];
            [h5 appendFormat:@"<html> <head><title>%@ 请求详情</title></head> <body><p>请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。</p>", pnrTitle];
            // 是否开启了重新提交
            if (self.resubmitBlock) {
                [h5 appendFormat:@"<p> <a href='/%i/%@'> <button type='button' style=\"width:200px;\" > 重新请求 </button> </a> </p>", (int)index, PnrPathEdit];
            }
            [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootPath1, colorValue, pnrEntity.path];
            [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootUrl1, colorValue, pnrEntity.url];
            [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootTime2, colorValue, pnrEntity.time];
            [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootMethod3, colorValue, pnrEntity.method];
            
            void (^ hrefBlock)(NSString*, id, NSString*) = ^(NSString * title, NSString * content, NSString * secondPath){
                [h5 appendFormat:@"<p><a href='/%i/%@'> <font color='%@'> %@ </font></a> <font color='%@'> %@ </font></p>", (int)index, secondPath, colorKey, title, colorValue, content];
            };
            
            NSString * (^ webBlock)(NSString *, id) = ^(NSString * subtitle, NSString * content){
                if (content) {
                    return [NSString stringWithFormat:@"<html> <head><title>%@%@</title></head> <body><br/> <p>%@</p> </body></html>", pnrTitle, subtitle, content];
                }else{
                    return ErrorEmpty;
                }
            };
            
            hrefBlock(PnrRootHead4,      [self contentString:headStr],      PnrPathHead);
            hrefBlock(PnrRootParameter5, [self contentString:parameterStr], PnrPathParameter);
            hrefBlock(PnrRootResponse6,  [self contentString:responseStr],  PnrPathResponse);
            
            self.h5Head     = webBlock(PnrRootHead4,      headStr);
            self.h5Request  = webBlock(PnrRootParameter5, parameterStr);
            self.h5Response = webBlock(PnrRootResponse6,  responseStr);
            
            [h5 appendString:@"</body></html>"];
            self.h5Root = h5;
        }
        // 是否开启了重新提交
        if (self.resubmitBlock) {
            int textSize = 16;
            // 设置 h5Edit
            NSMutableString * h5;
            
            h5 = [NSMutableString new];
            [h5 appendFormat:@"<html> <head><title>%@重新提交</title></head> <body>", pnrTitle];
            [h5 appendFormat:@"<form action='/%i/%@' method='POST' target='myIframe' >",  (int)index, PnrPathResubmit];
            
            // url
            [h5 appendFormat:@"<font color='%@'>%@</font><br> \
             <textarea id='%@' name='%@' wrap='off' cols='100' rows='2' style='font-size:%ipx;' >%@/%@</textarea> ", colorKey, PnrRootPath1, @"url", @"url", textSize, pnrEntity.domain, pnrEntity.path];
            // method
            [h5 appendFormat:@"<br><font color='%@'>%@</font><br> \
             <textarea id='%@' name='%@' wrap='off' cols='100' rows='1' style='font-size:%ipx;' >%@</textarea> ", colorKey, PnrRootMethod3, @"method", @"method", textSize, pnrEntity.method];
            // head
            [h5 appendFormat:@"<br><font color='%@'>%@</font><br> \
             <textarea id='%@' name='%@' wrap='off' cols='100' rows='3' style='font-size:%ipx;' >%@</textarea> ", colorKey, PnrRootHead4, @"head", @"head", textSize, headStr];
            // parameter
            [h5 appendFormat:@"<br><font color='%@'>%@</font><br> \
             <textarea id='%@' name='%@' wrap='off' cols='100' rows='5' style='font-size:%ipx;' >%@</textarea> ", colorKey,  PnrRootParameter5, @"parameter", @"parameter", textSize, parameterStr];
            // 额外参数
            [h5 appendFormat:@"<br><font color='%@'>%@</font><br> \
             <textarea id='%@' name='%@' wrap='off' cols='100' rows='1' style='font-size:%ipx;' >%@</textarea> ", colorKey,  @"额外参数", @"extra", @"extra", textSize, extraStr];
            
            [h5 appendString:@"<br><br><input type=\"submit\" style=\"width:200px;\" value=\"  提交  \"> <br>"];
            
            [h5 appendString:@"</form>"];
            
            [h5 appendString:@"<iframe id='myIframe' name='myIframe' width ='400' height='40'></iframe>"];
            
            [h5 appendString:@"</body></html>"];
            self.h5Edit = h5;
        }
        
    }else{
        AlertToastTitle(@"无法开启服务，titleArray与jsonArray数组不一致");
    }
}

- (NSString *)contentString:(id)content {
    if ([content isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)content toJsonString];
    }else if([content isKindOfClass:[NSString class]]) {
        return (NSString *)content;
    }else{
        return @"NULL";
    }
}

- (void)resubmitEntity:(PnrEntity *)pnrEntity request:(GCDWebServerRequest * _Nonnull)request {
    if (self.resubmitBlock) {
        GCDWebServerURLEncodedFormRequest * formRequest= (GCDWebServerURLEncodedFormRequest *)request;
        self.resubmitBlock(pnrEntity, formRequest.arguments);
    }
}

- (void)stopServer {
    [self.webServer stop];
    self.webServer = nil;
}

- (void)clearListWeb {
    self.lastIndex = -1;
    {
        [self.h5List setString:@""];
        [self.h5List appendString:@"<html> <head><title>网络请求</title></head> <body><p>请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。</p>"];
        [self.h5List appendString:@"暂无数据"];
        [self.h5List appendString:@"</body></html>"];
    }
}

@end

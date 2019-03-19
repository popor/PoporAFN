//
//  PnrWebBody.m
//  PoporNetRecord
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import "PnrWebBody.h"
#import "PnrEntity.h"
#import "PnrConfig.h"
#import "PnrWebCss.h"
#import "PnrWebJs.h"

#import <PoporFoundation/NSDictionary+tool.h>

@implementation PnrWebBody

+ (NSString *)jsonReadForm:(NSString *)form key:(NSString *)key name:(NSString *)keyName content:(NSString *)content {
    return [NSString stringWithFormat:@"\n<form id='%@' name='%@' method='POST' target='_blank' > \n <button class=\"w180Green\" type='button' \" onclick=\"jsonStatic('%@')\" > %@ 查看详情 </button> <br> \n <textarea id='%@' name='%@' class='%@'>%@</textarea> \n</form>",
            form, form, form, keyName, key, key, PnrClassTaAutoH, content
            ];
}

+ (NSString *)rootBody {
    PnrConfig * config = [PnrConfig share];
    
    NSMutableString * h5 = [NSMutableString new];
    [h5 appendFormat:@"<html> <head><title>%@</title></head> \n<body>\n<p>请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。</p>", config.webRootTitle];
    
    [h5 appendString:@"\n<script>"];
    {
        // 方便 浏览器查看 代码
        [h5 appendFormat:@"\n function detail(row) {\n var src = '/' +row + '/%@';\n  document.getElementById('%@').src = src;\n }", PnrPathDetail, PnrIframeDetail];
        
        [h5 appendFormat:@"\n\n function resubmit() {\n var form = document.getElementById('%@').contentWindow.document.getElementById('%@');\n form.submit();\n }", PnrIframeDetail, PnrFormResubmit];
        
        [h5 appendFormat:@"\n\n function freshList() {\n  document.getElementById('%@').contentWindow.location.reload(true);\n  }", PnrIframeList];
    }
    [h5 appendString:@"\n\n </script>\n"];
    
    [h5 appendFormat:@"\n <iframe id='%@' name='%@' src='/%@' style=\"width:28%%; height:94%%;\" ></iframe>", PnrIframeList, PnrIframeList, PnrPathList];
    [h5 appendFormat:@"\n <iframe id='%@' name='%@' style=\"width:68%%; height:94%%;\" ></iframe>", PnrIframeDetail, PnrIframeDetail];
    
    [h5 appendString:@"\n\n </body></html>"];
    return h5;
}

+ (NSString *)listH5:(NSString *)body {
    static NSString * h5_head;
    static NSString * h5_tail;
    if (!h5_head) {
        NSMutableString * html = [NSMutableString new];
        [html appendString:@"<html> <head><title>网络请求</title></head> \n<body>"];
        // css
        [html appendString:@"\n<style type='text/css'> \n"];
        [html appendString:[PnrWebCss cssDivWordOneLine]];
        [html appendString:[PnrWebCss cssButton]];
        [html appendString:@"\n</style>"];

        [html appendFormat:@"\n <button class='w100p' type='button' onclick='location.reload();' > 刷新列表 </button>"];
        [html appendFormat:@"\n <div style=\" background-color:#eeeeee; height:100%%; width:100%%; float:left; \">"];
        
        h5_head = html;
    }
    if (!h5_tail) {
        NSMutableString * html = [NSMutableString new];
        [html appendString:@"\n </div>"];
        [html appendString:@"\n </body></html>"];
        
        h5_tail = html;
    }
    return [NSString stringWithFormat:@"%@ %@ %@", h5_head, body, h5_tail];
}
// self.resubmitExtraDic
+ (void)deatilEntity:(PnrEntity *)pnrEntity index:(NSInteger)index extra:(NSDictionary *)extraDic finish:(void (^ __nullable)(NSString * detail, NSString * resubmit))finish
{
    static BOOL isInit;
    static NSString * h5_detail_head;
    static NSString * h5_detail_tail;
    static NSString * h5_resubmit_head;
    static NSString * h5_resubmit_tail;
    
    PnrConfig * config    = [PnrConfig share];
    NSString * colorKey   = config.rootColorKeyHex;
    NSString * colorValue = config.rootColorValueHex;
    
    if (!isInit) {
        isInit = YES;
        // MARK: 设置 detail 头
        {
            NSMutableString * h5 = [NSMutableString new];
            [h5 appendFormat:@"<html> <head><title>请求详情</title></head>"];
            
            // css
            [h5 appendString:@"\n<style type='text/css'>"];
            [h5 appendString:[PnrWebCss cssTextarea]];
            [h5 appendString:[PnrWebCss cssButton]];
            [h5 appendString:@"\n</style>"];
            
            // body
            [h5 appendString:@"\n<body>"];
            
            h5_detail_head = h5;
        }
        // MARK: 设置 detail 尾
        {
            NSMutableString * h5 = [NSMutableString new];
            // js
            [h5 appendFormat:@"\n<script> %@", [PnrWebJs jsJsonStatic]];
            [h5 appendFormat:@"\n %@ %@", [PnrWebJs textareaAutoHeightFuntion], [PnrWebJs textareaAuhoHeigtEventClass:PnrClassTaAutoH]];
            [h5 appendString:@"</script>"];
            
            [h5 appendString:@"</body></html>"];
            h5_detail_tail = h5;
        }
        // MARK: 重新提交 头
        {
            NSMutableString * h5 = [NSMutableString new];
            [h5 appendFormat:@"<html> <head><title>重新提交</title></head>"];
            
            // css
            [h5 appendString:@"\n<style type='text/css'>"];
            [h5 appendString:[PnrWebCss cssTextarea]];
            [h5 appendString:[PnrWebCss cssButton]];
            [h5 appendString:@"\n</style>"];
            
            // body
            [h5 appendString:@"\n<body>"];
            
            h5_resubmit_head = h5;
        }
        // MARK: 重新提交 尾
        {
            NSMutableString * h5 = [NSMutableString new];
            [h5 appendString:@"<p> <button class=\"w180Red\" type='button' onclick=\"parent.resubmit()\" > 重新请求 </button>"];
            [h5 appendString:@"&nbsp; <button class=\"w180Green\" type='button' onclick=\"parent.freshList()\" > 刷新列表 </button> </p>"];
            [h5 appendString:@"</form>"];
            
            [h5 appendFormat:@"<iframe id='%@' name='%@' width ='100%%' height='400'></iframe>", PnrIframeFeedback, PnrIframeFeedback];
            // js
            [h5 appendFormat:@"\n<script> \n%@", [PnrWebJs jsJsonDynamic]];
            [h5 appendFormat:@"\n %@ %@", [PnrWebJs textareaAutoHeightFuntion], [PnrWebJs textareaAuhoHeigtEventClass:PnrClassTaAutoH]];
            
            [h5 appendString:@"</script>"];
            [h5 appendString:@"\n</body></html>"];
            
            h5_resubmit_tail = h5;
        }
    }
    // MARK: 每次都需要拼接的部分
    NSString * headStr      = [self contentString:pnrEntity.headValue];
    NSString * parameterStr = [self contentString:pnrEntity.parameterValue];
    NSString * responseStr  = [self contentString:pnrEntity.responseValue];
    NSString * extraStr     = extraDic ? extraDic.toJsonString : @"{\"extraKey\":\"extraValue\"}";
    
    NSMutableString * detail   = [NSMutableString new];
    NSMutableString * resubmit = [NSMutableString new];
    {
        NSMutableString * h5 = [NSMutableString new];
        
        [h5 appendFormat:@"<p> <a href='/%i/%@'> <button class=\"w180Red\" type='button' > 重新请求 </button> </a> </p>", (int)index, PnrPathEdit];
        
        [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootTitle0, colorValue, pnrEntity.title];
        [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootTime3, colorValue, pnrEntity.time];
        
        [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootPath1, colorValue, pnrEntity.path];
        [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootUrl2, colorValue, pnrEntity.url];
        [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootMethod4, colorValue, pnrEntity.method];
        
        void (^ hrefBlock)(NSString*, id, NSString*) = ^(NSString * title, NSString * content, NSString * secondPath){
            [h5 appendString:[PnrWebBody jsonReadForm:secondPath key:PnrKeyConent name:title content:content]];
        };
        
        hrefBlock(PnrRootHead5,      headStr,      PnrPathHead);
        hrefBlock(PnrRootParameter6, parameterStr, PnrPathParameter);
        hrefBlock(PnrRootResponse7,  responseStr,  PnrPathResponse);
        
        [detail appendFormat:@"%@ \n %@ \n %@", h5_detail_head, h5, h5_detail_tail];
    }
    
    {
        NSMutableString * h5 = [NSMutableString new];
        
        [h5 appendFormat:@"<p> <a href='/%i/%@'> <button class=\"w180Red\" type='button' > <==返回 </button> </a> </p>", (int)index, PnrPathDetail];
        [h5 appendFormat:@"<form id='%@' name='%@' action='/%i/%@' method='POST' target='%@' >", PnrFormResubmit, PnrFormResubmit, (int)index, PnrPathResubmit, PnrIframeFeedback];
        
        void (^ hrefBlock)(NSString*, NSString*, NSString*) = ^(NSString* title, NSString* key, NSString* value){
            
            [h5 appendFormat:@"\n<br> <button class=\"w180Green\" type='button' \" onclick=\"jsonDynamic('%@', '%@')\" > %@ 查看详情 </button> ",
             PnrFormResubmit, key, title
             ];
            [h5 appendFormat:@"\n <textarea id='%@' name='%@' class='%@'>%@</textarea> <br>",
             key, key, PnrClassTaAutoH, value];
        };
        
        hrefBlock(PnrRootTitle0,     @"title",     pnrEntity.title);
        hrefBlock(PnrRootPath1,      @"url", [NSString stringWithFormat:@"%@/%@", pnrEntity.domain, pnrEntity.path]);
        
        if ([pnrEntity.method.lowercaseString isEqualToString:@"post"]) {
            [h5 appendFormat:@"\n <br> <button class=\"w180Green\" type='button' \" > %@ </button> \n\
             <input type='radio' name='method' id='methodGet'  value='GET'          /><label for='methodGet'>GET</label>\n\
             <input type='radio' name='method' id='methodPost' value='POST' checked /><label for='methodPost'>POST</label>\n\
             <br>\n ", PnrRootMethod4];
        }else if ([pnrEntity.method.lowercaseString isEqualToString:@"get"]) {
            [h5 appendFormat:@"\n <br> <button class=\"w180Green\" type='button' \" > %@ </button> \n\
             <input type='radio' name='method' id='methodGet'  value='GET'  checked /><label for='methodGet'>GET</label>\n\
             <input type='radio' name='method' id='methodPost' value='POST'         /><label for='methodPost'>POST</label>\n\
             <br>\n ", PnrRootMethod4];
        }else{
            hrefBlock(PnrRootMethod4, @"method", pnrEntity.method);
        }
        
        hrefBlock(PnrRootHead5,      @"head",      headStr);
        hrefBlock(PnrRootParameter6, @"parameter", parameterStr);
        hrefBlock(PnrRootExtra8,     @"extra",     extraStr);
        
        [resubmit appendFormat:@"%@ \n %@ \n %@", h5_resubmit_head, h5, h5_resubmit_tail];
    }
    finish(detail, resubmit);
}

+ (NSString *)contentString:(id)content {
    if ([content isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)content toJsonString];
    }else if([content isKindOfClass:[NSString class]]) {
        return (NSString *)content;
    }else{
        return @"NULL";
    }
}

+ (NSString *)feedbackH5:(NSString *)body {
    static NSString * h5_head;
    static NSString * h5_tail;
    if (!h5_head) {
        NSMutableString * h5 = [NSMutableString new];
        [h5 setString:@"<html> <head><title>update</title></head>"];
        
        // css
        [h5 appendString:@"\n<style type='text/css'>"];
        [h5 appendString:[PnrWebCss cssTextarea]];
        [h5 appendString:[PnrWebCss cssButton]];
        [h5 appendString:@"\n</style>"];
        
        // body
        [h5 appendString:@"\n<body>"];
        h5_head = h5;
    }
    if (!h5_tail) {
        NSMutableString * h5 = [NSMutableString new];
        [h5 appendString:@"\n<script>"];
        
        // js
        [h5 appendString:@"\n window.onload=function (){\
         parent.parent.freshList();\
         } "];
        [h5 appendFormat:@"\n %@ \n %@ \n", [PnrWebJs textareaAutoHeightFuntion], [PnrWebJs textareaAuhoHeigtEventClass:PnrClassTaAutoH]];
        
        [h5 appendString:[PnrWebJs jsJsonStatic]];
        [h5 appendString:@"\n </script>"];
        
        [h5 appendString:@"\n</body></html>"];
        
        h5_tail = h5;
    }
    
    return [NSString stringWithFormat:@"%@ %@ %@", h5_head, [PnrWebBody jsonReadForm:@"feedback" key:PnrKeyConent name:@"返回数据" content:body], h5_tail];
}

@end

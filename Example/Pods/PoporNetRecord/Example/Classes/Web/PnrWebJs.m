//
//  PnrWebJs.m
//  PoporNetRecord
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import "PnrWebJs.h"

#import "PnrEntity.h"
#import "PnrPortEntity.h"
#import "PnrConfig.h"

@implementation PnrWebJs

// MARK: 固定的查看json js代码
+ (NSString *)jsJsonStatic {
    return [NSString stringWithFormat: @"\n\
            function jsonStatic(formKey) {\n\
            var form = document.getElementById(formKey);\n form.action='/%@';\n form.submit();\n\
            }\n\
            ", PnrPathJsonXml];
}

// MARK: 动态的查看json js代码, 生成新的form,并且submit.
+ (NSString *)jsJsonDynamic {
    // http://www.cnblogs.com/haoqipeng/p/create-form-with-js.html
    return [NSString stringWithFormat: @"\n\
            function jsonDynamic(formKey, contentkey) {\n\
            var valueFrom = document.forms[formKey].elements[contentkey].value;\n\
            \n\
            var dlform = document.createElement('form');\n\
            dlform.style = 'display:none;';\n\
            dlform.method = 'POST';\n\
            dlform.action = '/%@';\n\
            dlform.target = '_blank';\n\
            \n\
            var hdnFilePath = document.createElement('input');\n\
            hdnFilePath.type = 'hidden';\n\
            hdnFilePath.name = '%@';\n\
            hdnFilePath.value = valueFrom;\n\
            dlform.appendChild(hdnFilePath);\n\
            \n\
            document.body.appendChild(dlform);\n\
            dlform.submit();\n\
            document.body.removeChild(dlform);\n\
            }\n\
            ", PnrPathJsonXml, PnrKeyConent];
}

// MARK: 高度自适应的textarea
+ (NSString *)textareaAutoHeightFuntion {
    // http://caibaojian.com/textarea-autoheight.html
    
    return @" function makeExpandingArea(el) { var setStyle = function (el) { el.style.height = 'auto'; el.style.height = el.scrollHeight + 'px'; }; var delayedResize = function (el) { window.setTimeout(function () { setStyle(el); }, 0); }; if (el.addEventListener) { el.addEventListener('input', function () { setStyle(el) }, false); setStyle(el); } else if (el.attachEvent) { el.attachEvent('onpropertychange', function () { setStyle(el); }); setStyle(el); } if (window.VBArray && window.addEventListener) { el.attachEvent('onkeydown', function () { var key = window.event.keyCode; if (key == 8 || key == 46) {delayedResize(el);} }); el.attachEvent('oncut', function () { delayedResize(el); }); } } ";
}

+ (NSString *)textareaAuhoHeigtEventClass:(NSString *)className {
    return [NSString stringWithFormat:@"\n var taArray = document.getElementsByClassName('%@'); for (var i = 0; i < taArray.length; i++) { makeExpandingArea(taArray[i]); } \n", className];
}

@end

//
//  PoporNetRecordConfig.m
//  JSONSyntaxHighlight
//
//  Created by apple on 2018/11/2.
//

#import "PoporNetRecordConfig.h"
#import <JSONSyntaxHighlight/JSONSyntaxHighlight.h>

@implementation PoporNetRecordConfig

+ (instancetype)share {
    static dispatch_once_t once;
    static PoporNetRecordConfig * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
        instance.activeAlpha         = 1.0;
        instance.normalAlpha         = 0.6;
        instance.recordMaxNum        = 100;
        
        instance.recordType          = PoporNetRecordAuto;
        UIFont * font                = [UIFont systemFontOfSize:15];
        //NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        //paraStyle.lineSpacing = 1;
        
        instance.cellTitleFont       = font;
        // instance.titleAttributes     = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x000000], NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
        // instance.keyAttributes       = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0xE46F5C], NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
        // instance.stringAttributes    = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x4BB748], NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
        // instance.nonStringAttributes = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x4BB748], NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
        
        // ---
        instance.titleAttributes     = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:font};
        instance.keyAttributes       = @{NSForegroundColorAttributeName:PnrColorGreen, NSFontAttributeName:font};
        instance.stringAttributes    = @{NSForegroundColorAttributeName:PnrColorRed, NSFontAttributeName:font};
        instance.nonStringAttributes = @{NSForegroundColorAttributeName:PnrColorRed, NSFontAttributeName:font};
    });
    return instance;
}

// 开关
- (void)setRecordType:(PoporNetRecordType)recordType {
    if (_recordType == 0 || _recordType != recordType) {
        _recordType = recordType;
        if (self.recordTypeBlock) {
            self.recordTypeBlock(recordType);
        }
    }
}

@end

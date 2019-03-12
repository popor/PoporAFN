
//
//  PnrEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PnrEntity.h"
#import "PnrConfig.h"
#import "PnrPortEntity.h"
#import <JSONSyntaxHighlight/JSONSyntaxHighlight.h>
#import <PoporFoundation/NSString+format.h>

@implementation PnrEntity

- (void)createListWebH5:(NSInteger)index {
    PnrConfig * config = [PnrConfig share];
    
    NSString * bgColor = index%2==1 ? config.listColorCell0Hex:config.listColorCell1Hex;
    NSMutableString * h5 = [NSMutableString new];
    
    [h5 appendFormat:@"<div style=\" background:%@; height:50px; position:relative; \" onclick= \"javascript:location.href='/%i/%@'\" >", bgColor, (int)index, PnrPathRoot];
    
    [h5 appendString:@"<div style=\" position:relative; top:4px; left:5px; \">"];
    
    [h5 appendFormat:@"<font color='%@'>%@ </font> <font color='%@'>%@  </font>", config.listColorTitleHex, self.title , config.listColorRequestHex, [self.path substringToIndex:MIN(self.path.length, 80)]];
    [h5 appendFormat:@"<br/> <font color='%@'>%@  </font> <font color='%@'>%@ </font>", config.listColorTimeHex, self.time, config.listColorDomainHex, self.domain];
    
    [h5 appendString:@"</div></div>"];
    
    self.listWebH5 = [h5 copy];
}



- (NSArray *)titleArray {
    PnrEntity * entity = self;
    NSString * title;
    if (entity.title) {
        title = [NSString stringWithFormat:@" %@\n%@", entity.title, entity.path];
    }else{
        title = [NSString stringWithFormat:@" \n%@",entity.path];
    }
    NSArray * titleArray = @[[NSString stringWithFormat:@"%@\n%@", PnrRootPath1, title],
                             [NSString stringWithFormat:@"%@\n%@", PnrRootUrl1, entity.url],
                             [NSString stringWithFormat:@"%@\n%@", PnrRootTime2, entity.time],
                             [NSString stringWithFormat:@"%@\n%@", PnrRootMethod3, entity.method],
                             
                             [NSString stringWithFormat:@"%@\n", PnrRootHead4],
                             [NSString stringWithFormat:@"%@\n", PnrRootParameter5],
                             [NSString stringWithFormat:@"%@\n", PnrRootResponse6],
                             ];
    return titleArray;
}

- (NSArray *)jsonArray {
    PnrEntity * entity = self;
    NSArray * jsonArray = @[[NSNull null],
                            [NSNull null],
                            [NSNull null],
                            [NSNull null],
                            
                            entity.headValue ?:[NSNull null],
                            entity.parameterValue ?:[NSNull null],
                            entity.responseValue ?:[NSNull null],
                            ];
    
    return jsonArray;
}

- (void)getJsonArrayBlock:(PnrEntityBlock)finish {
    if (!finish) {
        return;
    }
    PnrConfig * config   = [PnrConfig share];
    NSArray * titleArray = [self titleArray];
    NSArray * jsonArray  = [self jsonArray];
    
    NSMutableArray * cellAttArray = [NSMutableArray new];
    for (int i = 0; i<jsonArray.count; i++) {
        NSDictionary * json = jsonArray[i];
        
        NSMutableAttributedString * cellAtt = [[NSMutableAttributedString alloc] initWithString:titleArray[i] attributes:config.titleAttributes];
        
        if (json) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                JSONSyntaxHighlight *jsh = [[JSONSyntaxHighlight alloc] initWithJSON:json];
                jsh.keyAttributes       = config.keyAttributes;
                jsh.stringAttributes    = config.stringAttributes;
                jsh.nonStringAttributes = config.nonStringAttributes;
                NSAttributedString * jsonAtt = [jsh highlightJSON];
                [cellAtt appendAttributedString:jsonAtt];
            }else if ([json isKindOfClass:[NSString class]]) {
                [cellAtt addString:(NSString *)json font:nil color:[UIColor darkGrayColor]];
            }
        }
        
        [cellAttArray addObject:cellAtt];
    }
    
    finish(titleArray, jsonArray, cellAttArray);
}

@end
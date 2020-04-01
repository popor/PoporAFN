//
//  PnrExtraEntity.m
//  PoporNetRecord_Example
//
//  Created by apple on 2019/11/16.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import "PnrExtraEntity.h"

static NSString * PnrExtraUrlPortEntityKey  = @"PnrExtraUrlPortEntityKey";
static NSString * PnrExtraUrlPortSelectKey  = @"PnrExtraUrlPortSelectKey";
static NSString * PnrExtraUrlPortForwardKey = @"PnrExtraUrlPortForwardKey";

@implementation PnrExtraUrlPortEntity

@end

@interface PnrExtraEntity ()

@end

@implementation PnrExtraEntity

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrExtraEntity * instance;
    dispatch_once(&once, ^{
        instance = [PnrExtraEntity new];
        instance.urlPortArray = [NSMutableArray<PnrExtraUrlPortEntity *> new];
        [instance updateArray];
        instance.selectNum = [instance getSelectNum];
        instance.forward = [instance get__forward];
        [instance updateSelectUrlPort];
    });
    return instance;
}

- (void)saveArray {
    NSMutableString * json = [NSMutableString new];
    [json appendString:@"["];
    for (PnrExtraUrlPortEntity * e in self.urlPortArray) {
        [json appendFormat:@"{\"title\":\"%@\",\"url\":\"%@\",\"port\":\"%@\"},", e.title, e.url, e.port];
    }
    [json deleteCharactersInRange:(NSRange){json.length-1, 1}];
    [json appendString:@"]"];
    
    [[NSUserDefaults standardUserDefaults] setObject:json forKey:PnrExtraUrlPortEntityKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateArray {
    [self.urlPortArray removeAllObjects];
    NSString * json = [[NSUserDefaults standardUserDefaults] objectForKey:PnrExtraUrlPortEntityKey];
    if (json) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        for (NSDictionary * dic in array) {
            NSLog(@"one d: %@", dic);
            PnrExtraUrlPortEntity * entity = [PnrExtraUrlPortEntity new];
            entity.title = dic[@"title"]; //@"本地";
            entity.url   = dic[@"url"];   //@"http://127.0.0.1";
            entity.port  = dic[@"port"];  //@"9000";
            
            [self.urlPortArray addObject:entity];
        }
        
    } else {
        PnrExtraUrlPortEntity * entity = [PnrExtraUrlPortEntity new];
        entity.title = @"本地";
        entity.url   = @"http://127.0.0.1";
        entity.port  = @"9000";
        
        [self.urlPortArray addObject:entity];
        
        [self saveArray];
    }
}

- (void)saveSelectNum:(NSInteger)selectNum {
    self.selectNum = selectNum;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%li", selectNum] forKey:PnrExtraUrlPortSelectKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateSelectUrlPort];
}

- (NSInteger)getSelectNum {
    NSString * text = [[NSUserDefaults standardUserDefaults] objectForKey:PnrExtraUrlPortSelectKey];
    if (text) {
        return [text integerValue];
    } else {
        return 0;
    }
}

- (void)updateSelectUrlPort {
    PnrExtraUrlPortEntity * entity = self.urlPortArray[self.selectNum];
    self.selectUrlPort = [NSString stringWithFormat:@"%@:%@", entity.url, entity.port];
}

- (void)saveForward {
    
    [[NSUserDefaults standardUserDefaults] setObject:@(self.forward) forKey:PnrExtraUrlPortForwardKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)get__forward {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PnrExtraUrlPortForwardKey];
    return [info boolValue];
}


@end

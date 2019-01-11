//
//  PnrVCEntity.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PnrVCEntity : NSObject

@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * domain;
@property (nonatomic, strong) NSString * request;
@property (nonatomic, strong) NSString * method;// post get

@property (nonatomic, strong) id       headValue;
@property (nonatomic, strong) id       requesValue;
@property (nonatomic, strong) id       responseValue;

@property (nonatomic, strong) NSString * time;

//@property (nonatomic        ) float cellH;

@end

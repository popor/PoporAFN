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
@property (nonatomic, strong) NSString * method; // post get
@property (nonatomic, strong) NSDictionary * headDic;
@property (nonatomic, strong) NSDictionary * requestDic;
@property (nonatomic, strong) NSDictionary * responseDic;
@property (nonatomic, strong) NSString * time;

//@property (nonatomic        ) float cellH;

@end

//
//  PoporAFNViewController.m
//  PoporAFN
//
//  Created by wangkq on 07/09/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporAFNViewController.h"

#import <PoporAFN/PoporAFN.h>

@interface PoporAFNViewController ()

@end

@implementation PoporAFNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [PoporAFNTool getUrl:@"https://api.androidhive.info/volley/person_object.json" parameters:@{@"test":@"test1"} success:nil failure:nil monitor:YES];
    [PoporAFNTool postUrl:@"https://api.androidhive.info/volley/person_object.json" parameters:@{@"test":@"test1"} success:nil failure:nil monitor:YES];
    
}

@end

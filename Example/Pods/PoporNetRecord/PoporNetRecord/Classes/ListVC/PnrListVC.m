//
//  PnrListVC.m
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import "PnrListVC.h"
#import "PnrListVCPresenter.h"
#import "PnrListVCRouter.h"

#import "PoporNetRecord.h"
#import <Masonry/Masonry.h>

@interface PnrListVC ()

@property (nonatomic, strong) PnrListVCPresenter * present;

@end

@implementation PnrListVC
@synthesize infoTV;
@synthesize weakInfoArray;
@synthesize closeBlock;

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        if (dic) {
            self.title         = dic[@"title"];
            self.weakInfoArray = dic[@"weakInfoArray"];
            self.closeBlock    = dic[@"closeBlock"];
        }
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (!self.navigationController.view.window) {
        if (self.closeBlock) {
            self.closeBlock();
        }
    }
}

- (void)rootVCDismissApply {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.title) {
        self.title = @"PnrListVC";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.present) {
        [PnrListVCRouter setVCPresent:self];
    }
    
    [self addViews];
    
    __weak typeof(self) weakSelf = self;
    [PoporNetRecord share].freshBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.infoTV reloadData];
        });
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 参考: https://www.jianshu.com/p/c244f5930fdf
    if (self.isViewLoaded && !self.view.window) {
        // self.view = nil;//当再次进入此视图中时能够重新调用viewDidLoad方法
        
    }
}

#pragma mark - VCProtocol
- (UIViewController *)vc {
    return self;
}

- (void)setMyPresent:(id)present {
    self.present = present;
}

#pragma mark - views
- (void)addViews {
    self.infoTV = [self addTVs];
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self.present action:@selector(closeAction)];
        self.navigationItem.leftBarButtonItems = @[item1];
    }
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self.present action:@selector(clearAction)];
        self.navigationItem.rightBarButtonItems = @[item1];
    }
}

- (UITableView *)addTVs {
    UITableView * oneTV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    oneTV.delegate   = self.present;
    oneTV.dataSource = self.present;
    
    oneTV.allowsMultipleSelectionDuringEditing = YES;
    oneTV.directionalLockEnabled = YES;
    
    oneTV.estimatedRowHeight           = 0;
    oneTV.estimatedSectionHeaderHeight = 0;
    oneTV.estimatedSectionFooterHeight = 0;
    
    [self.view addSubview:oneTV];
    
    __weak typeof (self) weakSelf = self;
    [oneTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    return oneTV;
}

@end

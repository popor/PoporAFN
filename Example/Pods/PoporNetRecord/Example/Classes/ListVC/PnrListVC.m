//
//  PnrListVC.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import "PnrListVC.h"
#import "PnrListVCPresenter.h"
#import "PnrListVCRouter.h"

#import "PoporNetRecord.h"
#import <Masonry/Masonry.h>
#import <PoporUI/UINavigationController+Size.h>

@interface PnrListVC ()

@property (nonatomic, strong) PnrListVCPresenter * present;

@end

@implementation PnrListVC
@synthesize infoTV;
@synthesize serverBT;
@synthesize weakInfoArray;
@synthesize closeBlock;

@synthesize alertBubbleView;
@synthesize alertBubbleTV;
@synthesize alertBubbleTVColor;

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
    self.navigationController.topMargin = [self.navigationController getTopMargin];
    
    if (!self.present) {
        [PnrListVCRouter setVCPresent:self];
    }
    
    if (!self.alertBubbleTVColor) {
        self.alertBubbleTVColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    [self addViews];
    
    __weak typeof(self) weakSelf = self;
    [PoporNetRecord share].config.freshBlock = ^{
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
    [self addServerBT];
    self.infoTV   = [self addTVs];
    if ([self.navigationController.viewControllers indexOfObject:self] == 0) {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self.present action:@selector(closeAction)];
        self.navigationItem.leftBarButtonItems = @[item1];
    }
    [self.present setRightBarAction];
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
    
    [oneTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.serverBT.mas_bottom);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    return oneTV;
}

- (UITableView *)alertBubbleTV {
    UITableView * oneTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 150, 88) style:UITableViewStylePlain];
    
    oneTV.delegate   = self.present;
    oneTV.dataSource = self.present;
    
    oneTV.allowsMultipleSelectionDuringEditing = YES;
    oneTV.directionalLockEnabled = YES;
    
    oneTV.estimatedRowHeight           = 0;
    oneTV.estimatedSectionHeaderHeight = 0;
    oneTV.estimatedSectionFooterHeight = 0;
    
    oneTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    oneTV.layer.cornerRadius = 4;
    oneTV.clipsToBounds      = YES;
    oneTV.scrollEnabled      = NO;
    
    oneTV.backgroundColor = [UIColor clearColor];
    
    return oneTV;
}

- (void)addServerBT {
    self.serverBT = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 0, 40);
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [button addTarget:self.present action:@selector(editPortAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    [self.serverBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.navigationController.topMargin);
        
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(self.serverBT.frame.size.height);
    }];
    
    {
        UIView * lineView = [UIView new];
        lineView.backgroundColor = ColorTV_separator;
        
        [self.serverBT addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0);
        }];
    }
    [self.present updateServerBT];
}

@end

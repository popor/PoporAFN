//
//  PnrExtraVC.m
//  PoporNetRecord
//
//  Created by apple on 2019/11/16.
//  Copyright © 2019 wangkq. All rights reserved.

#import "PnrExtraVC.h"
#import "PnrExtraVCPresenter.h"
#import "PnrExtraVCInteractor.h"
#import <Masonry/Masonry.h>
#import "PnrUITool.h"

@interface PnrExtraVC ()

@property (nonatomic, strong) PnrExtraVCPresenter * present;

@end

@implementation PnrExtraVC
@synthesize infoTV;
@synthesize serverBT;

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [self assembleViper];
    [super viewDidLoad];
    
    if (!self.title) {
        self.title = @"额外设置";
    }
    self.view.backgroundColor = [UIColor whiteColor];
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

#pragma mark - viper views
- (void)assembleViper {
    if (!self.present) {
        PnrExtraVCPresenter * present = [PnrExtraVCPresenter new];
        PnrExtraVCInteractor * interactor = [PnrExtraVCInteractor new];
        
        self.present = present;
        [present setMyInteractor:interactor];
        [present setMyView:self];
        
        [self addViews];
        [self startEvent];
    }
}

- (void)addViews {
    [self addServerBT];
    self.infoTV = [self addTVs];
    
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"＋" style:UIBarButtonItemStylePlain target:self.present action:@selector(addUrlPortAction)];
        
        self.navigationItem.rightBarButtonItems = @[item1];
    }
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    [self.present startEvent];
    
}

// -----------------------------------------------------------------------------
- (void)addServerBT {
    self.serverBT = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [button addTarget:self.present action:@selector(forwardAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    [self.serverBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo([PnrUITool fetchTopMargin:self.navigationController]);
        
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    {
        UIView * lineView = [UIView new];
        lineView.backgroundColor = PRGB16(0XE3E3E3);
        
        [self.serverBT addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0);
        }];
    }
    //[self.present updateServerBT];
}

- (UITableView *)addTVs {
    UITableView * oneTV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    oneTV.backgroundColor = [UIColor clearColor];
    //oneTV.separatorColor  = [UIColor clearColor];
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



@end

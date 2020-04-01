//
//  PnrMessageVC.m
//  PoporNetRecord
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 wangkq. All rights reserved.

#import "PnrMessageVC.h"
#import "PnrMessageVCPresenter.h"
#import "PnrMessageVCInteractor.h"
#import <Masonry/Masonry.h>

@interface PnrMessageVC ()

@property (nonatomic, strong) PnrMessageVCPresenter * present;

@end

@implementation PnrMessageVC
@synthesize textTV;
@synthesize sendBT;
@synthesize blockExtraRecord;

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        if (dic) {
            self.title = dic[@"title"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [self assembleViper];
    [super viewDidLoad];
    
    if (!self.title) {
        self.title = @"转发文本";
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
        PnrMessageVCPresenter * present = [PnrMessageVCPresenter new];
        PnrMessageVCInteractor * interactor = [PnrMessageVCInteractor new];
        
        self.present = present;
        [present setMyInteractor:interactor];
        [present setMyView:self];
        
        [self addViews];
        [self startEvent];
    }
}

- (void)addViews {
    self.textTV = ({
        UITextView * tv = [UITextView new];
        tv.layer.borderColor = [UIColor grayColor].CGColor;
        tv.layer.borderWidth = 1;
        
        tv.layer.cornerRadius = 5;
        tv.clipsToBounds = YES;
        tv.font = [UIFont systemFontOfSize:15];
        
        [self.view addSubview:tv];
        tv;
    });
    
    [self.textTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(16);
        make.height.mas_equalTo(200);
        make.right.mas_equalTo(-16);
    }];
    
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self.present action:@selector(sendAction)];
        // [item1 setTitleTextAttributes:@{NSFontAttributeName:Font16} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItems = @[item1];
    }
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    [self.present startEvent];
    
}

// -----------------------------------------------------------------------------



@end

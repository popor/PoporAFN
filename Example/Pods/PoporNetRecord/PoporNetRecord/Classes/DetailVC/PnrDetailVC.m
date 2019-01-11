//
//  PnrDetailVC.m
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import "PnrDetailVC.h"
#import "PnrDetailVCPresenter.h"
#import "PnrDetailVCRouter.h"

#import <Masonry/Masonry.h>
#import <PoporFoundation/NSDictionary+tool.h>
#import <PoporFoundation/PrefixColor.h>
#import <PoporUI/IToastKeyboard.h>

#import "PnrWebPortEntity.h"

@interface PnrDetailVC ()

@property (nonatomic, strong) PnrDetailVCPresenter * present;
@property (nonatomic, weak  ) PnrWebPortEntity     * portEntity;

@end

@implementation PnrDetailVC
@synthesize infoTV;
@synthesize jsonArray;
@synthesize titleArray;
@synthesize cellAttArray;
@synthesize selectRow;
@synthesize menu;
@synthesize serverBT;

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        if (dic) {
            self.title        = dic[@"title"];
            
            self.jsonArray    = dic[@"jsonArray"];
            self.titleArray   = dic[@"titleArray"];
            self.cellAttArray = dic[@"cellAttArray"];
        }
        self.portEntity = [PnrWebPortEntity share];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.menu) {
        [self.menu setMenuVisible:NO];
        self.menu = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.title) {
        self.title = @"PnrDetailVC";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.present) {
        [PnrDetailVCRouter setVCPresent:self];
    }
    
    [self addViews];
    [self.present startServer];
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
    if (self.portEntity.detailVCStartServer) {
        self.serverBT = ({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 0, 40);
            [button setBackgroundColor:[UIColor whiteColor]];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
            
            button.userInteractionEnabled = NO;
            button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            
            [self.view addSubview:button];
            button;
        });
        
        [self.serverBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
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
    }
    self.infoTV = [self addTVs];
    self.infoTV.separatorInset = UIEdgeInsetsMake(0, 14, 0, 14);
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.infoTV addGestureRecognizer:recognizer];
    
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"复制" style:UIBarButtonItemStylePlain target:self.present action:@selector(copyAction)];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Web" style:UIBarButtonItemStylePlain target:self.present action:@selector(pushWebVC)];
        
        self.navigationItem.rightBarButtonItems = @[item1, item2];
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
    
    [oneTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        if (self.serverBT) {
            make.top.mas_equalTo(self.serverBT.mas_bottom);
        }else{
            make.top.mas_equalTo(0);
        }
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    oneTV.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    return oneTV;
}

#pragma mark - 复制
// uiscrollview 会把touch事件覆盖掉,但是我不想重新定义UITableView,因为涉及到了很多runtime函数.
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    //两句话是保存触摸起点位置
//    UITouch *touch=[touches anyObject];
//    CGPoint cureentTouchPosition=[touch locationInView:self.infoTV];
//    //得到cell中的IndexPath
//    NSIndexPath *indexPath=[self.infoTV indexPathForRowAtPoint:cureentTouchPosition];
//
//    self.selectRow = (int)indexPath.row;
//
//    [self showUIMenuAtPoint:cureentTouchPosition];
//}

- (void)tapGRAction:(UITapGestureRecognizer *)tapGR {
    CGPoint point = [tapGR locationInView:self.infoTV];
    if (point.y > self.infoTV.contentSize.height) {
        if (self.menu) {
            [self.menu setMenuVisible:NO];
            self.menu = nil;
        }
    }else{
        NSIndexPath *indexPath = [self.infoTV indexPathForRowAtPoint:point];
        self.selectRow = (int)indexPath.row;
        if (self.selectRow >=0 && self.selectRow<self.cellAttArray.count) {
            [self showUIMenuAtPoint:point];
        }
    }
}

- (void)showUIMenuAtPoint:(CGPoint)point {
    [self.view becomeFirstResponder];
    
    UIMenuItem *copyTextContentMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制Text" action:@selector(copyTextContent:)];
    UIMenuItem *copyJsonContentMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制Json" action:@selector(copyJsonContent:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    if ([self.jsonArray[self.selectRow] isKindOfClass:[NSDictionary class]]) {
        [menu setMenuItems:@[copyTextContentMenuItem, copyJsonContentMenuItem]];
    }else{
        [menu setMenuItems:@[copyTextContentMenuItem]];
    }
    
    [menu setTargetRect:CGRectMake(point.x - 50, point.y - 30, 100, 40) inView:self.infoTV];
    [menu setMenuVisible:YES animated:YES];
    
    self.menu = menu;
}

- (void)copyTextContent:(UIMenuItem *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSMutableAttributedString * att = self.cellAttArray[self.selectRow];
    [pasteboard setString:att.string];
}

- (void)copyJsonContent:(UIMenuItem *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSDictionary * dic = self.jsonArray[self.selectRow];
    NSString * jsonString = [dic toJsonString];
    if (jsonString) {
        [pasteboard setString:jsonString];
    }else{
        AlertToastTitle(@"复制失败");
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    BOOL result = NO;
    if(@selector(copyTextContent:) == action
       ||@selector(copyJsonContent:) == action
       ) {
        result = YES;
    }
    return result;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
